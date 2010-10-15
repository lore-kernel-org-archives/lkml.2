Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab0JOSR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 14:17:28 -0400
Received: from kroah.org ([198.145.64.141]:39715 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab0JOSR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 14:17:27 -0400
Date: Fri, 15 Oct 2010 11:16:56 -0700
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, lud <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for October 15 (usb/xhci)
Message-ID: <20101015181656.GA6473@kroah.com>
References: <20101015165002.0b6e418f.sfr@canb.auug.org.au>
 <20101015084420.6624796d.randy.dunlap@oracle.com>
 <20101015164830.GA21576@kroah.com>
 <20101015175211.GA13313@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015175211.GA13313@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:52:11AM -0700, Sarah Sharp wrote:
> On Fri, Oct 15, 2010 at 09:48:30AM -0700, Greg KH wrote:
> > On Fri, Oct 15, 2010 at 08:44:20AM -0700, Randy Dunlap wrote:
> > > On Fri, 15 Oct 2010 16:50:02 +1100 Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Changes since 20101014:
> > > 
> > > 
> > > When CONFIG_PM is not enabled:
> > > 
> > > drivers/usb/host/xhci.c:675: error: implicit declaration of function 'usb_root_hub_lost_power'
> > > 
> > > Also, can xhci.c:xhci_suspend() and xhci_resume() be inside
> > > #ifdef CONFIG_PM / #endif ?
> > 
> > Sarah, care to send me a follow-on patch fixing this up?
> 
> Sure.  Do you want me to rework the last patch (patch 8), or just send a
> bug fix?

A bug fix is fine.

thanks,

greg k-h
