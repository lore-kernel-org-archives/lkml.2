Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760Ab0GOVAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:00:21 -0400
Received: from mail.perches.com ([173.55.12.10]:1901 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934725Ab0GOVAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:00:19 -0400
Subject: Re: [PATCH 12/25] char: Convert pci_table entries to PCI_VDEVICE
 (if PCI_ANY_ID is used)
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Peter Huewe <PeterHuewe@gmx.de>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "Digi International, Inc" <Eng.Linux@digi.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20100715204540.GB24463@suse.de>
References: <201007152052.38060.PeterHuewe@gmx.de>
	 <20100715204540.GB24463@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Jul 2010 14:00:15 -0700
Message-ID: <1279227615.5816.96.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 13:45 -0700, Greg KH wrote:
> I much prefer the PCI_DEVICE() macro instead, and as such, I'm not
> willing to take any of these patches, sorry.

grepping for pci device ids using constants and
expecting the result to be comprehensive isn't
sensible.
 
$ grep -rwP --include=*.[ch] -w PCI_VDEVICE drivers/char | wc -l
32

The current drivers/ use of PCI_VDEVICE to PCI_DEVICE is ~50/50

$ grep --include=*.[ch] -rwP PCI_DEVICE drivers | wc -l
866
$ grep --include=*.[ch] -rwP PCI_VDEVICE drivers | wc -l
768


