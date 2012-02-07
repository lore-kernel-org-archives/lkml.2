Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2BGQH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:07:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45606 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2BGQH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:07:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_Zup7Wg7FO95Z63e_sniu21gyzdCjcBNgsS0aw6MguDwLw@mail.gmail.com>
References: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
	<m2pqdr2tyq.fsf@bob.laptop.org>
	<CAAJw_Zv4Hk_kfc33xsVcdi-0_C6tsf_FD3sUx1JPDX_fZZMzeQ@mail.gmail.com>
	<4F30E19B.9020503@intel.com>
	<CAAJw_Zth+QM8OhMEWweBBek8QNW_9CseHSDuB-LCGrvwuqfV2A@mail.gmail.com>
	<4F310529.4020101@intel.com>
	<CAAJw_ZsHwdvXuw+edXUfyGOSMOu5oUw3zX8nUryxJJiiZXzXKQ@mail.gmail.com>
	<CAAJw_Zup7Wg7FO95Z63e_sniu21gyzdCjcBNgsS0aw6MguDwLw@mail.gmail.com>
Date: Wed, 8 Feb 2012 00:07:26 +0800
Message-ID: <CAAJw_Zv6HkLLqEzNKRCfQ7EbMNEVe_hzbW+mHOnDAWLidOhMBQ@mail.gmail.com>
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: Chris Ball <cjb@laptop.org>, Pierre Ossman <pierre@ossman.eu>,
        lkml <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        arindam.nath@amd.com, zhangfei.gao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 12:04 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Tue, Feb 7, 2012 at 11:00 PM, Philip Rakity <prakity@marvell.com> wrote:
>
>> Chris just took a patch upstream from us that reverts the sd card to HS if we fail uhs.  You might need this.  Could you send me  a complete console log.
>>
>> echo 17 > /proc/sys/kernel/printk
>>
>> Then insert card.


Philip,

Here you go. Gmail is not bad at replying.

> Here's the log ...
>
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000040
> mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
> mmc0: clock 0Hz busmode 2 powermode 1 cs 0 Vdd 21 width 0 timing 0
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
> mmc0: starting CMD52 arg 00000c00 flags 00000195
> mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
> mmc0: starting CMD52 arg 80000c08 flags 00000195
> mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 1 Vdd 21 width 0 timing 0
> mmc0: starting CMD0 arg 00000000 flags 000000c0
> mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
> mmc0: starting CMD8 arg 000001aa flags 000002f5
> mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
> mmc0: starting CMD5 arg 00000000 flags 000002e1
> mmc0: req failed (CMD5): -123, retrying...
> mmc0: req failed (CMD5): -123, retrying...
> mmc0: req failed (CMD5): -123, retrying...
> mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
> mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
> mmc0: starting CMD1 arg 00000000 flags 000000e1
> mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
> mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
> mmc0: mmc_rescan_try_freq: trying to init card at 300000 Hz
> mmc0: clock 0Hz busmode 2 powermode 1 cs 0 Vdd 21 width 0 timing 0
> mmc0: clock 300000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000040
> mmc0: starting CMD52 arg 00000c00 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
> mmc0: starting CMD52 arg 80000c08 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
> mmc0: clock 300000Hz busmode 2 powermode 2 cs 1 Vdd 21 width 0 timing 0
> mmc0: starting CMD0 arg 00000000 flags 000000c0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
> mmc0: clock 300000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
> mmc0: starting CMD8 arg 000001aa flags 000002f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD8): 0: 000001aa 00000000 00000000 00000000
> mmc0: starting CMD5 arg 00000000 flags 000002e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req failed (CMD5): -110, retrying...
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req failed (CMD5): -110, retrying...
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req failed (CMD5): -110, retrying...
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00400120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 00000000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: clock 300000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
> mmc0: clock 300000Hz busmode 2 powermode 2 cs 1 Vdd 20 width 0 timing 0
> mmc0: starting CMD0 arg 00000000 flags 000000c0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
> mmc0: clock 300000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
> mmc0: starting CMD8 arg 000001aa flags 000002f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD8): 0: 000001aa 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> mmc0: starting CMD55 arg 00000000 flags 000000f5
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> mmc0: starting CMD41 arg 51300000 flags 000000e1
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD41): 0: c0ff8000 00000000 00000000 00000000
> mmc0: starting CMD2 arg 00000000 flags 00000067
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD2): 0: 28424548 30383538 00000011 0a00b200
> mmc0: starting CMD3 arg 00000000 flags 00000075
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD3): 0: b3680520 00000000 00000000 00000000
> mmc0: starting CMD9 arg b3680000 flags 00000007
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD9): 0: 400e0032 5b590000 774d7f80 0a400000
> mmc0: starting CMD7 arg b3680000 flags 00000015
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD7): 0: 00000700 00000000 00000000 00000000
> mmc0: starting CMD55 arg b3680000 flags 00000095
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000920 00000000 00000000 00000000
> mmc0: starting CMD51 arg 00000000 flags 000000b5
> mmc0:     blksz 8 blocks 1 flags 00000200 tsac 100 ms nsac 0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> mmc0: req done (CMD51): 0: 00000920 00000000 00000000 00000000
> mmc0:     8 bytes transferred: 0
> mmc0: starting CMD55 arg b3680000 flags 00000095
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000920 00000000 00000000 00000000
> mmc0: starting CMD13 arg 00000000 flags 000001b5
> mmc0:     blksz 64 blocks 1 flags 00000200 tsac 100 ms nsac 0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> mmc0: req done (CMD13): 0: 00000920 00000000 00000000 00000000
> mmc0:     64 bytes transferred: 0
> mmc0: starting CMD6 arg 00fffff1 flags 000000b5
> mmc0:     blksz 64 blocks 1 flags 00000200 tsac 100 ms nsac 0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> mmc0: req done (CMD6): 0: 00000900 00000000 00000000 00000000
> mmc0:     64 bytes transferred: 0
> mmc0: starting CMD6 arg 00fff1ff flags 000000b5
> mmc0:     blksz 64 blocks 1 flags 00000200 tsac 100 ms nsac 0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> mmc0: req done (CMD6): 0: 00000900 00000000 00000000 00000000
> mmc0:     64 bytes transferred: 0
> mmc0: starting CMD6 arg 00ff1fff flags 000000b5
> mmc0:     blksz 64 blocks 1 flags 00000200 tsac 100 ms nsac 0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> mmc0: req done (CMD6): 0: 00000900 00000000 00000000 00000000
> mmc0:     64 bytes transferred: 0
> mmc0: clock 25000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
> mmc0: starting CMD55 arg b3680000 flags 00000095
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
> mmc0: starting CMD55 arg b3680000 flags 00000095
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD55): 0: 00000920 00000000 00000000 00000000
> mmc0: starting CMD6 arg 00000002 flags 00000015
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD6): 0: 00000920 00000000 00000000 00000000
> mmc0: clock 25000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> mmc0: new SDHC card at address b368
> mmc0: calculated max. discard sectors 188416 for timeout 4067 ms
> mmcblk0: mmc0:b368 H0858 14.9 GiB
> mmc0: starting CMD18 arg 00000000 flags 000000b5
> mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> mmc0:     CMD12 arg 00000000 flags 0000049d
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x000a8001
> mmc0: req done (CMD18): -84: 00000000 00000000 00000000 00000000
> mmc0:     0 bytes transferred: 0
> mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x000a8001
> mmc0: req done (CMD13): -84: 00000000 00000000 00000000 00000000
> mmcblk0: error -84 sending status command, retrying
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
> mmcblk0: error -110 sending status command, retrying
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
> mmcblk0: error -110 sending status command, aborting
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req failed (CMD13): -110, retrying...
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req failed (CMD13): -110, retrying...
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD13): 0: 00400b00 00000000 00000000 00000000
> end_request: I/O error, dev mmcblk0, sector 0
> quiet_error: 2 callbacks suppressed
> Buffer I/O error on device mmcblk0, logical block 0
> mmc0: starting CMD18 arg 00000000 flags 000000b5
> mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> mmc0:     CMD12 arg 00000000 flags 0000049d
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
> mmc0:     0 bytes transferred: 0
> mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x000a8001
> mmc0: req done (CMD13): -84: 00000000 00000000 00000000 00000000
> mmcblk0: error -84 sending status command, retrying
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
> mmcblk0: error -110 sending status command, retrying
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD13): 0: 00000b00 00000000 00000000 00000000
> mmc0: starting CMD12 arg 00000000 flags 0000049d
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> mmc0: req done (CMD12): 0: 00000b00 00000000 00000000 00000000
> mmcblk0: timed out sending r/w cmd command, card status 0xb00
> mmc0: starting CMD18 arg 00000000 flags 000000b5
> mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> mmc0:     CMD12 arg 00000000 flags 0000049d
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> mmc0:     4096 bytes transferred: 0
> mmc0:     (CMD12): -110: 00000000 00000000 00000000 00000000
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x000c8001
> mmc0: req done (CMD13): -84: 00000000 00000000 00000000 00000000
> mmcblk0: error -84 sending status command, retrying
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD13): 0: 00000b00 00000000 00000000 00000000
> mmc0: starting CMD12 arg 00000000 flags 0000049d
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x000a8003
> mmc0: req done (CMD12): 0: 00000580 00000000 00000000 00000000
> mmcblk0: error -110 sending stop command, original cmd response 0x900,
> card status 0xb00
> mmcblk0: unable to read partition table
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x000a8001
> mmc0: req failed (CMD13): -84, retrying...
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req failed (CMD13): -110, retrying...
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD13): 0: 00400900 00000000 00000000 00000000
> mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> mmc0: gated MCI clock
>
> Thanks,
> Jeff
