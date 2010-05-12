Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab0ELCLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:11:36 -0400
Received: from fmailhost06.isp.att.net ([204.127.217.106]:47840 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0ELCLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:11:35 -0400
X-Originating-IP: [65.7.130.205]
Message-ID: <4BEA0E54.4080208@turmel.org>
Date: Tue, 11 May 2010 22:11:32 -0400
From: Phil Turmel <pturmel-kernel@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100417 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Phil Reynolds <phil-linux@tinsleyviaduct.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com> <4BE964C2.1010702@turmel.org> <20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com> <4BE9A1B3.3020208@turmel.org> <4BE9C796.7080605@garzik.org>
In-Reply-To: <4BE9C796.7080605@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On 05/11/2010 05:09 PM, Jeff Garzik wrote:
> On 05/11/2010 02:28 PM, Phil Turmel wrote:
>> On 05/11/2010 01:21 PM, Phil Reynolds wrote:
>>> Quoting "Phil Turmel"<pturmel-kernel@turmel.org>:
>>>
>>>> I have a similar chipset in my office server: 88SE6145.  If yours
>>>> can run
>>>> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel
>>>> command
>>>> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I
>>>> have
>>>> ahci built-in, and no initramfs, so I put the option in my grub.conf.)
>>>
>>> Neither works for me unfortunately.
>>>

[snip /]

> sata_mv is not related to this hardware.
> 
> pata_marvell works with 6101/6121/6141/6145 PATA ports.
> 
> ahci works with 6101/6121/6141/6145 SATA ports, with marvell_enable=1.
> 
>     Jeff

I think you might have me (Phil T) confused with the original poster, Phil
Reynolds [1].

I have working SATA hotplug on my 88SE6145 w/ the ahci driver and
marvell_enable=1.  The OP, Phil R., has an 88SE6121 that has been running
with the Marvell driver, without hotplug.  Neither of us cares about the
PATA ports.  Phil R. wants hotplug, but has not successfully enabled
marvell support in the ahci driver.

I've suggested Phil R. post his dmesg, lspci, and config, so we can figure out
what's going on.

Did I miss something else?

Phil

[1] http://marc.info/?l=linux-kernel&m=127341691613147&w=2
