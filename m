Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1J0ADy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:03:54 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43383 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1J0ADx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:03:53 -0400
Date: Wed, 26 Oct 2011 17:03:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Joe Perches <joe@perches.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        ohering@suse.com, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 1/6] Staging: hv: mousevsc: Make  boolean states  boolean
Message-ID: <20111027000342.GA6804@core.coreip.homeip.net>
References: <1319588311-9935-1-git-send-email-kys@microsoft.com>
 <1319588392-9982-1-git-send-email-kys@microsoft.com>
 <1319587427.14932.7.camel@Joe-Laptop>
 <20111026060742.GA19973@suse.de>
 <1319669211.21924.16.camel@Joe-Laptop>
 <20111026235054.GA31883@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026235054.GA31883@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:50:54AM +0200, Greg KH wrote:
> On Wed, Oct 26, 2011 at 03:46:51PM -0700, Joe Perches wrote:
> > On Wed, 2011-10-26 at 08:07 +0200, Greg KH wrote:
> > > On Tue, Oct 25, 2011 at 05:03:47PM -0700, Joe Perches wrote:
> > > > On Tue, 2011-10-25 at 17:19 -0700, K. Y. Srinivasan wrote:
> > > > > Make some state that is boolean in nature, a boolean variable.
> > > > []
> > > > > diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> > > > []
> > > > @@ -148,7 +148,7 @@ struct  mousevsc_prt_msg {
> > > > >   */
> > > > >  struct mousevsc_dev {
> > > > >  	struct hv_device	*device;
> > > > > -	unsigned char		init_complete;
> > > > > +	bool			init_complete;
> > > > >  	struct mousevsc_prt_msg	protocol_req;
> > > > >  	struct mousevsc_prt_msg	protocol_resp;
> > > > >  	/* Synchronize the request/response if needed */
> > > > > @@ -159,7 +159,7 @@ struct mousevsc_dev {
> > > > >  	unsigned char		*report_desc;
> > > > >  	u32			report_desc_size;
> > > > >  	struct hv_input_dev_info hid_dev_info;
> > > > > -	int			connected;
> > > > > +	bool			connected;
> > > > >  	struct hid_device       *hid_device;
> > > > >  };
> > > > 
> > > > One of the bools should be moved to be adjacent to the other.
> > > For a mouse driver, it really doesn't matter.
> > 
> > 'course it doesn't matter, just like whitespace
> > doesn't matter.  It's just done for form's sake.
> 
> Not at all.
> 
> Whitespace does matter, there is documented proof of that.
> 
> The fact that you want to move a bool to a different part of a structure
> really is only your personal choice.  It doesn't matter for size or
> layout to make this code work better at all to do this.

It is a good practice to try minimizing footprint though. While it might
not matter much in this particular driver we should still try to produce
best code we can as it is often taken as source for new drivers.

> 
> This is your personal opinion only, please don't construe it as anything
> else.

Same could be said about the email I am replying to.

-- 
Dmitry
