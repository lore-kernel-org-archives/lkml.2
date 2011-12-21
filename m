Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1LUVYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:24:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1LUVYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:24:31 -0500
Date: Wed, 21 Dec 2011 13:24:13 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: balbi@ti.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: fix renesas mod_gadget printk format warning
Message-ID: <20111221212413.GA16448@suse.de>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
 <4EF2424D.4020200@xenotime.net>
 <20111221211624.GB17951@legolas.emea.dhcp.ti.com>
 <4EF25B7D.8080905@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF25B7D.8080905@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:19:41PM -0800, Randy Dunlap wrote:
> On 12/21/2011 01:16 PM, Felipe Balbi wrote:
> > Hi,
> > 
> > On Wed, Dec 21, 2011 at 12:32:13PM -0800, Randy Dunlap wrote:
> >> From: Randy Dunlap <rdunlap@xenotime.net>
> >>
> >> Fix printk format warning:
> >>
> >> drivers/usb/renesas_usbhs/mod_gadget.c:188:3: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
> >>
> >> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> >> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > 
> > a bit too late:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/balbi/usb.git;a=commitdiff;h=8418153a4ccd38a3bc3229bc4bd161e3e5db88d2
> > 
> 
> OK, that's good.  But it's not in linux-next yet??

Give me a chance to catch up on stuff happening while I'm supposed to be
on vacation please...


