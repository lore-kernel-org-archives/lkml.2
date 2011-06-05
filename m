Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1FEO3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:29:33 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:64361 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1FEO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AFuU3t832DBcQR/I4IsLrZHsYanpSdVmrsSzmNyvXTwmDjQyP3Wj8m56auLXWLvsh3
         SApxVnRPghmGDW0mcR6F8MzKXCXb1oD6VchLqM4V4mK/2nrUfoICXeYD0krsDp7LmULc
         iKxsUB9bjGF7BHDSj/O9NwaTT3Fejd/a7bMuQ=
MIME-Version: 1.0
Date: Sun, 5 Jun 2011 22:29:31 +0800
Message-ID: <BANLkTik84U0p7hf1+ofvPvJ2CO1MmutcWQ@mail.gmail.com>
Subject: Realtek RTL8192CU Polling FW ready fail!! REG_MCUFWDL:0x00000006
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just trying out the PCi GW-USBExtreme USB Wireless adaptor. It's
detected as Realtek 2019:ed17 and I'm using the kernel rtl8192cu
module.

Here's the dmesg ... it seems having problem with the firmware
(rtl8192cufw.bin) ... (Polling FW ready fail!!
REG_MCUFWDL:0x00000006). I downloaded the firmware from
http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git

cfg80211: Calling CRDA to update world regulatory domain
rtl8192cu: MAC address: 00:22:cf:43:d3:8b
rtl8192cu: Board Type 0
rtl8192cu: rx_max_size 15360, rx_urb_num 8, in_ep 1
ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
usbcore: registered new interface driver rtl8192cu
rtl8192cu: MAC auto ON okay!
rtl8192cu: Tx queue select: 0x05
rtl8192c: Loading firmware file rtlwifi/rtl8192cufw.bin
rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Polling FW ready fail!!
REG_MCUFWDL:0x00000006 .
rtl8192c_common:rtl92c_download_fw():<0-0> Firmware is not ready to run!


# Linux Kernel 3.0.0-rc1

-rw-rw-r-- 1 root root 16014 Jun  3 22:53
/usr/lib/firmware/rtlwifi/rtl8192cufw.bin

Thanks,
Jeff
