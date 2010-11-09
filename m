Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0KIU2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:28:03 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44227 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0KIU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:28:00 -0500
Date: Tue, 9 Nov 2010 15:27:55 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: Dan Carpenter <error27@gmail.com>, Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: gadget: goku_udc: add registered flag bit
Message-ID: <20101109202755.GC1984@penfold>
References: <1288807358-11813-1-git-send-email-apw@canonical.com>
 <20101103182314.GA8010@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103182314.GA8010@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 11:23:14AM -0700, Greg KH wrote:
> On Wed, Nov 03, 2010 at 06:02:38PM +0000, Andy Whitcroft wrote:
> > The commit below cleaned up error handling, in part by introducing a
> > registered flag bit.  This however was not added to the device
> > structure leding to build failures:
> > 
> >   commit 319feaabb6c7ccd90da6e3207563c265da7d21ae
> >   Author: Dan Carpenter <error27@gmail.com>
> >   Date:   Tue Oct 5 18:55:34 2010 +0200
> > 
> >     usb: gadget: goku_udc: Fix error path
> > 
> > Add the missing registered flag bit.
> 
> 
> Dan, is this patch below the correct fix?  Or should we be looking at
> some other flag?
> 
> [Andy, please always cc: the original patch author when reporting
> problems, to not do so is a bit rude and causes others (i.e. me) extra
> work.]

Appologies.  I thought I used get_maintainers which I thought pulled in
the recent committers.  More care next time.

-apw
