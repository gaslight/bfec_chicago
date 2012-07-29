class Cookbook.Routers.RecipeRouter extends Backbone.Router
  
  constructor: ->
    super
    @recipe = new Cookbook.Models.Recipe(id: 1)
    @recipes = new Cookbook.Collections.Recipes()
    @categories = new Cookbook.Collections.Categories window.categoriesJson
    @recipeView = new Cookbook.Views.RecipeView(el: $("#recipe_view"))
    @recipeEditView = new Cookbook.Views.RecipeEditView(el: $("#recipe_edit_view"))
    @recipeListView = new Cookbook.Views.RecipeListView
      el: $("#recipe_list_view")
      collection: @recipes
    @recipes.fetch()
    @recipes.on "sync", (recipe) => @navigate "recipes/#{recipe.id}", trigger: true
    
  routes:
    "recipes/new": "newRecipe"
    "recipes/:id/edit": "editRecipe"
    "recipes/:id": "showRecipe"
    "recipes": "listRecipes"
    
  listRecipes: ->
    @recipeView.hide()
    @recipeEditView.hide()
    @recipeListView.render()
    
  showRecipe: (id) ->
    @recipe = @recipes.get(id)
    return unless @recipe
    @recipeView.model = @recipe
    @recipeEditView.hide()
    @recipeView.render()

  newRecipe:  ->
    @recipe = new Cookbook.Models.Recipe
    @recipe.on "sync", =>
      @recipes.add(@recipe)
      @navigate "recipes/#{@recipe.id}", trigger: true
    @recipeEditView.model = @recipe
    @recipeView.hide()
    @recipeEditView.render()

  editRecipe: (id) ->
    @recipe = @recipes.get(id)
    return unless @recipe
    @recipeEditView.model = @recipe
    @recipeView.hide()
    @recipeEditView.render()

$ ->
  window.recipeRouter = new Cookbook.Routers.RecipeRouter()
  Backbone.history.start()
