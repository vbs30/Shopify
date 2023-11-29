from django.shortcuts import render, get_object_or_404, redirect
from .models import Category, Item
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from .forms import NewItemForm, EditItemForm


def items(req):
    query = req.GET.get('query', '')
    category_id = req.GET.get('category', 0)
    items = Item.objects.filter(is_sold =False)
    categories = Category.objects.all()
    
    if query:
        items = items.filter(Q(name__icontains = query) | Q(description__icontains=query))
        
    if category_id:
        items = items.filter(category_id=category_id)    
    
    return render(req, 'item/items.html', {
        'items':items,
        'query': query,
        'categories': categories,
        'category_id': int(category_id),
    })


# Create your views here.
def details(req, pk):
    item = get_object_or_404(Item, pk=pk)
    
    related_items = Item.objects.filter(category=item.category, is_sold=False).exclude(pk=pk)[0:3]
    
    return render(req, 'item/details.html', {
        'item': item,
        'related_items': related_items,
    })
    

@login_required
def new(req):
    if req.method == 'POST':
        form = NewItemForm(req.POST, req.FILES)
        if form.is_valid():
            item = form.save(commit=False)
            item.Created_by = req.user
            item.save()
            return redirect('item:details', pk=item.id)
            
    else:
        form = NewItemForm()
    
    return render(req, 'item/form.html', {
        'form': form,
        'title': 'New Item'
    })
    
    
@login_required
def edit(req, pk):
    item = get_object_or_404(Item, pk=pk, Created_by = req.user)
    if req.method == 'POST':
        form = EditItemForm(req.POST, req.FILES, instance=item)
        if form.is_valid():
            form.save()
            
            return redirect('item:details', pk=item.id)
            
    else:
        form = EditItemForm(instance=item)
    
    return render(req, 'item/form.html', {
        'form': form,
        'title': 'Edit Item'
    })
    
    
    
@login_required
def delete(req, pk):
    item = get_object_or_404(Item, pk=pk, Created_by = req.user)
    item.delete()
    return redirect('dashboard:index')