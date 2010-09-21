Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0IUQvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:51:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:35876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab0IUQvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:51:06 -0400
Date: Tue, 21 Sep 2010 09:44:14 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Cox <alan@linux.intel.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        lud <linux-usb@vger.kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Alek Du <alek.du@intel.com>
Subject: Re: linux-next: Tree for September 9 (usb/otg/langwell)
Message-ID: <20100921164414.GA8756@suse.de>
References: <20100909211249.2c70ac41.sfr@canb.auug.org.au>
 <20100909092645.11fc3bf0.randy.dunlap@oracle.com>
 <20100909203046.7e3d7819@linux.intel.com>
 <20100921093742.2bec5c15.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921093742.2bec5c15.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 09:37:42AM -0700, Randy Dunlap wrote:
> On Thu, 9 Sep 2010 20:30:46 +0100 Alan Cox wrote:
> 
> > On Thu, 9 Sep 2010 09:26:45 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > On Thu, 9 Sep 2010 21:12:49 +1000 Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Changes since 20100908:
> > > 
> > > on i386 (X86_32), drivers/usb/otg/langwell_otg.c has 429 errors and 2
> > > warnings.
> > > 
> > 
> > Just sorting this now.
> 
> 
> Still seeing lots of langwell_otg errors in linux-next 20100921.
> Have any patches been merged?

Sorry, I'm a bit behind, should catch up today barring anything
unexpected happening...

thanks,

greg k-h
