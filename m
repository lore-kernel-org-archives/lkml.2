Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0IKMf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 08:35:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57887 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0IKMfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 08:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bYsmIswSERARgoB6Fn15Fdux/0cJJOoDEIoCKVtuu+GfWUnYaXVqXKEJTnEZXk76SR
         pEkLokzaeG2GBDRldbK3r2Tt6Kc6QJgCn7cZhOoWUr6aYcy55befCZATxs8FAdFlIt7Y
         hRq6NCpaE5PoXYFz0zhi/E7LjNrAjDulOkHRU=
MIME-Version: 1.0
In-Reply-To: <19595.23873.90306.656565@pilspetsen.it.uu.se>
References: <AANLkTimMxQXxC354V=qVOrdUYFSrpJ-RZeKJfQEx0KPN@mail.gmail.com>
	<19595.23873.90306.656565@pilspetsen.it.uu.se>
Date: Sat, 11 Sep 2010 18:05:23 +0530
Message-ID: <AANLkTinQVQsjxJLpZQiP5V56o7quGPY6G0ZOnvwPAKbx@mail.gmail.com>
Subject: Re: How to determine the information about SATA controller
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 11, 2010 at 4:13 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Jaswinder Singh Rajput writes:
>  > Hello,
>  >
>  > My old IDE hard disk is broken so I installed new SATA drive on my box with F13:
>  >
>  > dmesg :
>  > http://userweb.kernel.org/~jaswinder/P4_HT/dmesg_2633_fc13.txt
>  >
>  > lsmod:
>  > http://userweb.kernel.org/~jaswinder/P4_HT/lsmod_2633_fc13.txt
>  >
>  > lspci:
>  > 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM
>  > Controller/Host-Hub Interface (rev 02)
>  > 00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated
>  > Graphics Controller (rev 02)
>  > 00:06.0 System peripheral: Intel Corporation 82865G/PE/P Processor to
>  > I/O Memory Interface (rev 02)
>  > 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
>  > 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC
>  > Interface Bridge (rev 02)
>  > 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
>  > Controller (rev 02)
>  > 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
>  >
>  > I am trying to build the kernel with this config:
>  > http://userweb.kernel.org/~jaswinder/P4_HT/config-ht-test.txt
>  >
>  > But I am getting error :
>  >
>  > No root device found.
>  > Boot has failed, sleeping forever
>  >
>  > I am trying to determine the information about the SATA controller so
>  > that I can choose the appropriate controller for SATA in kernel
>  > config. I am not able to figure out the SATA information from above
>  > dmesg and lsmod. How can I do so.
>
> In your working dmesg the disks are controlled by ata_piix,
> but you've disabled CONFIG_ATA_PIIX in the config you're trying.
> So it's not surprising that you can't boot.
>
> 1) re-enable CONFIG_ATA_PIIX and disable CONFIG_IDE

I have enabled CONFIG_ATA_PIIX
and disabled CONFIG_IDE

but still getting same error :

No root device found.
Boot has failed, sleeping forever

Am I missing some more options.

> or
> 2) go into the bios and change the option that says whether to run
>   the ATA controller in legacy/compatible mode or enhanced/ahci mode,
>   you want ahci mode
>

In my case, BIOS options are enhanced / legacy / disabled. I tried all
but of no use. So I am using enhanced to boot Fedora 13 kernel.

Thanks,
--
Jawinder Singh.
