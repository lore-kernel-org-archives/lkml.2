Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935609Ab0GPE30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 00:29:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:49426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab0GPE3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 00:29:17 -0400
Date: Thu, 15 Jul 2010 21:29:43 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "Digi International, Inc" <Eng.Linux@digi.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/25] char: Convert pci_table entries to PCI_VDEVICE
	(if PCI_ANY_ID is used)
Message-ID: <20100716042943.GB28607@suse.de>
References: <201007152052.38060.PeterHuewe@gmx.de> <20100715204540.GB24463@suse.de> <1279227615.5816.96.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279227615.5816.96.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 02:00:15PM -0700, Joe Perches wrote:
> On Thu, 2010-07-15 at 13:45 -0700, Greg KH wrote:
> > I much prefer the PCI_DEVICE() macro instead, and as such, I'm not
> > willing to take any of these patches, sorry.
> 
> grepping for pci device ids using constants and
> expecting the result to be comprehensive isn't
> sensible.

But it's a nice goal :)

> $ grep -rwP --include=*.[ch] -w PCI_VDEVICE drivers/char | wc -l
> 32

drivers/char is not exactly a large collection of PCI drivers, only some
old serial port ones.

> The current drivers/ use of PCI_VDEVICE to PCI_DEVICE is ~50/50
> 
> $ grep --include=*.[ch] -rwP PCI_DEVICE drivers | wc -l
> 866
> $ grep --include=*.[ch] -rwP PCI_VDEVICE drivers | wc -l
> 768

Hey, anything to increase that ratio is good :)

thanks,

greg k-h
