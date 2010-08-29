Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0H2N6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:58:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36730 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0H2N63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=S1WYbxmIKjDqL90gCs2T+gxy1IJW6aeap7Np5q6Vbg+ykRcxa/+ACpW7OrrDF7Hvsw
         8PtJv/jdWRydHlz9mwjhFy+pBIHc5Hyg43oEuvsqg2UWnGwYV+3FCuJFcWcxSdokIGB6
         vao+vb06X6gZiqCTTjQuDqJVvcYybGiIo5csw=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Arno Schuring <aelschuring@hotmail.com>
Subject: Re: i386 WARNING: at kernel/softirq.c:143 _local_bh_enable_ip+0x2f/0x7e
Date: Sun, 29 Aug 2010 15:58:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4C781A3A.4010707@hotmail.com>
In-Reply-To: <4C781A3A.4010707@hotmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008291558.24588.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 27 sierpnia 2010 o 22:04:10 Arno Schuring wrote:
> Hello list,
> 
> [ if this is the wrong place, please redirect. Kerneloops and bugzilla
> seem down atm, only other reference I found is this thread from
> February: http://lkml.org/lkml/2010/2/25/454 ]
> 
> 
> Testing current -git on my old desktop machine yields the following
> warning:
> 
> [   12.437090] WARNING: at kernel/softirq.c:143
> _local_bh_enable_ip+0x2f/0x7e()
> [   12.437094] Hardware name:
> [   12.437097] Modules linked in: xfs exportfs w83627hf_wdt w83627hf
> hwmon_vid dm_crypt dm_mod usbhid 8250_pnp 8250 hid processor pcspkr
> i2c_sis96x serial_core evdev usb_storage rtc_cmos button rtc_core
> rtc_lib ext4 jbd2 crc16 ohci_hcd ehci_hcd usbcore thermal thermal_sys
> floppy nls_base sr_mod cdrom [last unloaded: scsi_wait_scan]
> [   12.437148] Pid: 0, comm: swapper Not tainted 2.6.36-rc2+ #18
> [   12.437152] Call Trace:
> [   12.437167]  [<c1024fc1>] ? warn_slowpath_common+0x6a/0x7b
> [   12.437172]  [<c102975a>] ? _local_bh_enable_ip+0x2f/0x7e
> [   12.437178]  [<c1024fdf>] ? warn_slowpath_null+0xd/0x10
> [   12.437183]  [<c102975a>] ? _local_bh_enable_ip+0x2f/0x7e
> [   12.437191]  [<c125c782>] ? netpoll_rx+0x71/0x77
> [   12.437195]  [<c125c796>] ? netif_rx+0xe/0xf7
> [   12.437204]  [<c12207c3>] ? sis900_interrupt+0x1c7/0x4ab
> [   12.437212]  [<c10580e7>] ? handle_IRQ_event+0x54/0x102
> [   12.437218]  [<c1059985>] ? handle_fasteoi_irq+0x8c/0xdf
> [   12.437223]  [<c10598f9>] ? handle_fasteoi_irq+0x0/0xdf
> [   12.437226]  <IRQ>  [<c1003a3c>] ? do_IRQ+0x2b/0x7f
> [   12.437237]  [<c1002ca9>] ? common_interrupt+0x29/0x30
> [   12.437246]  [<c1007eba>] ? default_idle+0x39/0x4c
> [   12.437250]  [<c1001b00>] ? cpu_idle+0x35/0xad
> [   12.437258]  [<c14346c0>] ? start_kernel+0x274/0x277
> [   12.437262] ---[ end trace d2278ae4badf238c ]---
> 
> 
> Kernel version is current git (well, yesterday's):
> aschuring@neminis:~/work/linux-GIT$ git describe HEAD
> v2.6.36-rc2-237-gd4348c6
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=17321
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
