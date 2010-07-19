Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936252Ab0GSPuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:50:01 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47558 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936115Ab0GSPt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:49:59 -0400
Message-ID: <4C44741D.5010409@fusionio.com>
Date: Mon, 19 Jul 2010 09:49:49 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tino Keitel <tino.keitel@tikei.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
References: <4C4325E0.5020407@fusionio.com> <20100718184243.GA4062@srcf.ucam.org> <4C436566.8060609@fusionio.com> <20100719054027.GA30246@mac.home>
In-Reply-To: <20100719054027.GA30246@mac.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 11:40 PM, Tino Keitel wrote:
> On Sun, Jul 18, 2010 at 14:34:46 -0600, Jens Axboe wrote:
> 
> [...]
> 
>> See this is where I'm getting confused, since I'm not entirely sure what
>> the boot process is. If I boot a DVD directly, then it's in piix mode.
>> Booting through refit -> Linux, it's in piix mode. So my logic was that
>> it is probably getting switched into ahci mode by the OSX boot loader or
>> perhaps the driver does it there.
> 
> If this helps: I switched from grub-pc to grub-efi on my oldish Mac
> mini Core 2 Duo (i945 chipset) and the hard disk used AHCI after this.
> Suspend also works fine. So I would guess that the AHCI/PIIX difference
> is caused by booting with EFI/legacy DOS bootblock, and the latter is
> just done for Windows compatibility.

Great! That sounds way better. DO you have a pointer to grub-efi? I'm
finding some grub2 efi stuff with google, just want to make sure that is
it. A grub 0.9x with efi would be preferable, I find grub2 to be horrible
to work with in general...

-- 
Jens Axboe

