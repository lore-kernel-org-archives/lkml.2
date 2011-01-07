Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1AGWF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:05:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:38193 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab1AGWFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:05:55 -0500
Date: Fri, 7 Jan 2011 14:00:12 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Anand Gadiyar <gadiyar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB merge for .38
Message-ID: <20110107220012.GA26091@suse.de>
References: <20110106235016.GA2212@kroah.com>
 <AANLkTi=rwv2CW-x_p9SrKghcPKD4TeOAP=2mtp8EcS34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=rwv2CW-x_p9SrKghcPKD4TeOAP=2mtp8EcS34@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 01:22:40PM -0800, Linus Torvalds wrote:
> On Thu, Jan 6, 2011 at 3:50 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > Nothing radical here at all, lots of musb changes, which touched a bunch
> > of arch-specific code, and some new drivers, mostly gadget ones.
> 
> There were also a number of conflicts with the ARM updates (omap clock
> data in particular - added aliases, changed names, you name it).
> 
> I spent some time trying to fix it up properly, and maybe I even
> succeeded, but you guys should really look the result over.

The drivers/usb/* changes look good to me.  I know Tony was looking at
the omap merge issues, and if there was one, I think he had the needed
fixup.

thanks for doing the merge.

greg k-h
