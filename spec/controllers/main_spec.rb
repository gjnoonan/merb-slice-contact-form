require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbSliceContactForm::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:MerbSliceContactForm) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbSliceContactForm::Main, :index)
    controller.slice.should == MerbSliceContactForm
    controller.slice.should == MerbSliceContactForm::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbSliceContactForm::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbSliceContactForm')
  end
  
  it "should work with the default route" do
    controller = get("/merb-slice-contact-form/main/index")
    controller.should be_kind_of(MerbSliceContactForm::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/merb-slice-contact-form/index.html")
    controller.should be_kind_of(MerbSliceContactForm::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(MerbSliceContactForm::Main, 'index')
    
    url = controller.url(:merb_slice_contact_form_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/merb-slice-contact-form/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:merb_slice_contact_form_index, :format => 'html')
    url.should == "/merb-slice-contact-form/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:merb_slice_contact_form_home)
    url.should == "/merb-slice-contact-form/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbSliceContactForm::Main, :index)
    controller.public_path_for(:image).should == "/slices/merb-slice-contact-form/images"
    controller.public_path_for(:javascript).should == "/slices/merb-slice-contact-form/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merb-slice-contact-form/stylesheets"
    
    controller.image_path.should == "/slices/merb-slice-contact-form/images"
    controller.javascript_path.should == "/slices/merb-slice-contact-form/javascripts"
    controller.stylesheet_path.should == "/slices/merb-slice-contact-form/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbSliceContactForm::Main._template_root.should == MerbSliceContactForm.dir_for(:view)
    MerbSliceContactForm::Main._template_root.should == MerbSliceContactForm::Application._template_root
  end

end