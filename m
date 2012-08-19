Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2HSJts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 05:49:48 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:36221 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2HSJtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 05:49:46 -0400
Date: Sun, 19 Aug 2012 11:49:42 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: printks messed up in 3.6-rc2+git
Message-ID: <20120819094942.GA251@x4>
References: <alpine.SOC.1.00.1208191026340.18296@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1208191026340.18296@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.08.19 at 10:30 +0300, Meelis Roos wrote:
> 1. Lots of broken HPET messages scattered in PCI prontks like this:
> pcieport 0000:00:0c.0: Force enabled HPET at 0x%lx
> irq 40 for MSI/MSI-X
> pcieport 0000:00:0d.0: Force enabled HPET at 0x%lx
> irq 41 for MSI/MSI-X
> pcieport 0000:00:0e.0: Force enabled HPET at 0x%lx
> irq 42 for MSI/MSI-X
> pcieport 0000:00:0f.0: Force enabled HPET at 0x%lx
> irq 43 for MSI/MSI-X
> 
> 2. Lots of \0x10 in different printk lines, like this:
> 
> pci 0000:00:05.0: \x010Enabling HT MSI Mapping
> pci 0000:00:05.1: \x010Enabling HT MSI Mapping
> pci 0000:00:05.2: \x010Enabling HT MSI Mapping
> pci 0000:00:06.0: \x010Enabling HT MSI Mapping
> pci 0000:00:06.1: \x010Enabling HT MSI Mapping
> pci 0000:00:08.0: \x010Enabling HT MSI Mapping
> pci 0000:00:09.0: \x010Enabling HT MSI Mapping
> pci 0000:00:0c.0: \x010Enabling HT MSI Mapping
> pci 0000:00:0d.0: \x010Enabling HT MSI Mapping
> pci 0000:00:0e.0: \x010Enabling HT MSI Mapping
> pci 0000:00:0f.0: \x010Enabling HT MSI Mapping
> and this:
> usb 2-8: \x010new low-speed USB device number 5 using ohci_hcd
> usb 2-8: \x010New USB device found, idVendor=0592, idProduct=0002
> usb 2-8: \x010New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 2-8: %s: Can't disable non-U1 or U2 state.
> 
> 3. Many more %s and runtogether lines:
> 
> sata_nv 0000:00:05.1: %s: ino %lu, used %d with only %d reserved data blocksUsing SWNCQ mode

Yes.
Fix is already queued up:
http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=commitdiff;h=ebdc82899ec5ed35af1c79ed6a4eeda69dad9b90

-- 
Markus
