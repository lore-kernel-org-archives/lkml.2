Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0EOLTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 07:19:07 -0400
Received: from topdeck.tinsleyviaduct.com ([62.49.246.82]:33526 "EHLO
	topdeck.tinsleyviaduct.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138Ab0EOLTF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 07:19:05 -0400
Message-ID: <20100515121857.90932i9udmzcpp29@topdeck.tinsleyviaduct.com>
Date: Sat, 15 May 2010 12:18:57 +0100
From: "Phil Reynolds" <phil-linux@tinsleyviaduct.com>
To: "John Stoffel" <john@stoffel.org>
Cc: "Phil Turmel" <pturmel-kernel@turmel.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
	<4BE964C2.1010702@turmel.org>
	<20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com>
	<19433.44163.776781.931987@stoffel.org>
In-Reply-To: <19433.44163.776781.931987@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "John Stoffel" <john@stoffel.org>:

>>>>>> "Phil" == Phil Reynolds <phil-linux@tinsleyviaduct.com> writes:
>
> Phil> Quoting "Phil Turmel" <pturmel-kernel@turmel.org>:
>>> I have a similar chipset in my office server: 88SE6145.  If yours can run
>>> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel command
>>> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I have
>>> ahci built-in, and no initramfs, so I put the option in my grub.conf.)
>
> Phil> Neither works for me unfortunately.
>
> Can you post your dmesg output from both bootups?  Are there any
> differences?  Also submit the lspci -vvv output as well, just so
> people can help you better.

After following advice from various people, I am about there - though  
it doesn't seem to last many changes, the eSATA port is now hotplug  
capable.

I still have issues to solve to make it perform more like USB does,  
but they are not related to anything in the kernel or SCSI layer.  
Thanks to all involved.

-- 
Phil Reynolds
email: phil-linux@tinsleyviaduct.com
Not subscribed to lkml - please CC replies to me

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
