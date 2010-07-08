Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab0GHTAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:00:45 -0400
Received: from kroah.org ([198.145.64.141]:53888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab0GHTAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:00:44 -0400
Date: Thu, 8 Jul 2010 11:55:29 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Samium Gromoff <_deepfire@feelingofgreen.ru>
Subject: Re: [PATCH -mmotm] 8250_early: fix printk format warnings
Message-ID: <20100708185529.GA6291@kroah.com>
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
 <20100702182437.977c8ef8.randy.dunlap@oracle.com>
 <20100708183710.GC31823@kroah.com>
 <4C361CD7.1050007@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C361CD7.1050007@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 11:45:43AM -0700, Randy Dunlap wrote:
> On 07/08/10 11:37, Greg KH wrote:
> > On Fri, Jul 02, 2010 at 06:24:37PM -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Fix printk format warnings in serial-mmio32-support-for-8250_earlyc.patch:
> >>
> >> drivers/serial/8250_early.c:207: warning: format '%p' expects type 'void *', but argument 3 has type 'long long unsigned int'
> >> drivers/serial/8250_early.c:210: warning: format '%p' expects type 'void *', but argument 2 has type 'long long unsigned int'
> >>
> >> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >> Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>
> >> Cc: Greg KH <greg@kroah.com>
> >> ---
> >>  drivers/serial/8250_early.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> --- mmotm-2010-0701-1219.orig/drivers/serial/8250_early.c
> >> +++ mmotm-2010-0701-1219/drivers/serial/8250_early.c
> >> @@ -202,12 +202,12 @@ static int __init parse_options(struct e
> >>  	}
> >>  
> >>  	if (mmio || mmio32)
> >> -		printk(KERN_INFO "Early serial console at MMIO%s 0x%p (options '%s')\n",
> >> +		printk(KERN_INFO "Early serial console at MMIO%s 0x%llu (options '%s')\n",
> > 
> > Odd, my tree doesn't have this change in it, where is it coming from?
> 
> A patch in mmotm from Samium Gromoff.
> mmotm patch file name is "serial-mmio32-support-for-8250_earlyc.patch".

Ah.  Samium, can you fold this into your original one?

thanks,

greg k-h
