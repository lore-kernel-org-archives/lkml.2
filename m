Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0HWUFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:05:46 -0400
Received: from lo.gmane.org ([80.91.229.12]:34969 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab0HWUFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:05:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
Date: Mon, 23 Aug 2010 22:05:06 +0200
Message-ID: <20100823220506.7248c51b@schatten.dmk.lab>
References: <4C728145.4030808@Free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: f053215205.adsl.alicedsl.de
In-Reply-To: <4C728145.4030808@Free.fr>
X-Newsreader: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 16:10:13 +0200
Eric Valette <Eric.Valette@Free.fr> wrote:

> Hi,
> 
> I just bought an new external disk enclosure with e-sata/USB2 connector 
> to replace an old USB2 only external disk enclosure.
> 
> My internal drive is a small SSD because I use the small factor PC as a 
> home theater and do want silence and fast boot. I build my own kernel to 
> put only what I need in and also boot somehow faster.
> 
> I use grub2 (up to date) as a loader. As soon as I power on the external 
> sata disk, the system does not boot because hardware designer add the 
> great idea to put the internal sata connector on ata3 whereas the 
> external e-sata is wired on ata2.
> 
> consequence is that root file system is on sda1 when no external drive 
> is connected and sdb1 when the external drive is connected.
> 
> As my grub setup was having a root=/dev/sda1 command line parameter and 
> it was advertised everywhere that root=UUID=xxxxx was now supported, I 
> changed the line to discover that this only work if an initramfs was 
> loaded because support is done entirely in used space! Reading 
> init/do_mounts.c made it very clear.
> 
> I find it extremely curious to have to add an initramfs to support 
> dynamic drive identification, especially when the BYID value is 
> displayed during boot message.
> 
> The boot loader cannot do a better job than the kernel and its life may 
> be even worse as bios value for the same disk may change according to 
> boot disk priorities.
> 
> Any hint comment? Any other way to avoid using a ramdisk? Please CC me 
> as I'm not subscribed.
> 
> -- eric
> 
> 
> 


I'm not exactly shure, but isn't the search command in grub2 what you
want?

http://forums.linuxmint.com/viewtopic.php?f=46&t=38599

You can let grub2 figure out which drive is which and pass the right
devices to the kernel...



