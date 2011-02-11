Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab1BKTOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 14:14:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:37153 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1BKTOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 14:14:10 -0500
Date: Fri, 11 Feb 2011 11:13:40 -0800
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: ycwang <yenchengwang@gmail.com>, dbrownell@users.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_mass_storage: fixed a macro coding
 style issue
Message-ID: <20110211191340.GA11733@suse.de>
References: <1297438592-8566-1-git-send-email-yenchengwang@gmail.com>
 <20110211173918.GA9176@suse.de>
 <20110211185710.GB31385@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211185710.GB31385@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:57:10AM -0800, Dmitry Torokhov wrote:
> On Fri, Feb 11, 2011 at 09:39:18AM -0800, Greg KH wrote:
> > On Fri, Feb 11, 2011 at 11:36:32PM +0800, ycwang wrote:
> > > Fixed a macro coding style issue.
> > 
> > What macro coding style issue did you fix?  Please be more specific and
> > resend the patch with a more complete changelog entry.
> > 
> 
> It is simply incorrect as it adds do {} while (0) to the module
> parameter constructors which are used outside of functions.
> 
> The change was never compiled.

Well, I was going to wait until the next iteration of the patch to let
the submitter know that, you just spoiled my fun of watching someone
send a obviously broken patch twice :)

It's the little things in life we live for...

thanks,

greg k-h
