Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0GRVc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 17:32:26 -0400
Received: from eazy.amigager.de ([213.239.192.238]:44150 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab0GRVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 17:32:24 -0400
Date: Sun, 18 Jul 2010 23:32:16 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
Message-ID: <20100718213216.GA19163@x61.home>
Mail-Followup-To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4C4325E0.5020407@fusionio.com>
 <20100718184243.GA4062@srcf.ucam.org>
 <4C436566.8060609@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C436566.8060609@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 18, 2010 at 14:34:46 -0600, Jens Axboe wrote:

[...]

> See this is where I'm getting confused, since I'm not entirely sure what
> the boot process is. If I boot a DVD directly, then it's in piix mode.
> Booting through refit -> Linux, it's in piix mode. So my logic was that
> it is probably getting switched into ahci mode by the OSX boot loader or
> perhaps the driver does it there.

If this helps: I switched from grub-pc to grub-efi on my oldish Mac
mini Core 2 Duo (i945 chipset) and the hard disk used AHCI after this.
Suspend also works fine. So I would guess that the AHCI/PIIX difference
is caused by booting with EFI/legacy DOS bootblock, and the latter is
just done for Windows compatibility.

Regards,
Tino
