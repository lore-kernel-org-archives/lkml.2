Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1FGEo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:44:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46967 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1FGEo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:44:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=LeCQcHJ+8qRBn2tjep5jcToDIPCoDRj5y0F4kfJPEubKbO2loOBu1VfzbiNcjkeZur
         7zTRiNB7Y2MyrdunETLYOyIn6KeXpT9lzPW9xykVc5H7zNpbQRxOAYJryRI/mlioS8xQ
         DUKbUDTUm31WaJhMqGctXjNH2fV5oFUpqN1dA=
MIME-Version: 1.0
In-Reply-To: <BANLkTik84U0p7hf1+ofvPvJ2CO1MmutcWQ@mail.gmail.com>
References: <BANLkTik84U0p7hf1+ofvPvJ2CO1MmutcWQ@mail.gmail.com>
Date: Tue, 7 Jun 2011 12:44:57 +0800
Message-ID: <BANLkTika3VUB6mmY=JLikQYgrFXk2xuP1A@mail.gmail.com>
Subject: Re: Realtek RTL8192CU Polling FW ready fail!! REG_MCUFWDL:0x00000006
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 10:29 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> Just trying out the PCi GW-USBExtreme USB Wireless adaptor. It's
> detected as Realtek 2019:ed17 and I'm using the kernel rtl8192cu
> module.
>
> Here's the dmesg ... it seems having problem with the firmware
> (rtl8192cufw.bin) ... (Polling FW ready fail!!
> REG_MCUFWDL:0x00000006). I downloaded the firmware from
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
>
> cfg80211: Calling CRDA to update world regulatory domain
> rtl8192cu: MAC address: 00:22:cf:43:d3:8b
> rtl8192cu: Board Type 0
> rtl8192cu: rx_max_size 15360, rx_urb_num 8, in_ep 1
> ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
> usbcore: registered new interface driver rtl8192cu
> rtl8192cu: MAC auto ON okay!
> rtl8192cu: Tx queue select: 0x05
> rtl8192c: Loading firmware file rtlwifi/rtl8192cufw.bin
> rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Polling FW ready fail!!
> REG_MCUFWDL:0x00000006 .
> rtl8192c_common:rtl92c_download_fw():<0-0> Firmware is not ready to run!
>
>
> # Linux Kernel 3.0.0-rc1
>
> -rw-rw-r-- 1 root root 16014 Jun  3 22:53
> /usr/lib/firmware/rtlwifi/rtl8192cufw.bin


Not sure anyone got a chance to look into this. I could get the device
to work with RTL8192CU_linux_v3.0.1590.20110511.zip (just that
ifconfig wlan0 froze the whole system).

rtw driver version=v3.0.1590.20110511
CHIP TYPE: RTL8188C_8192C
MAC Address from efuse= 00:22:cf:43:d3:8b


Thanks,
Jeff
