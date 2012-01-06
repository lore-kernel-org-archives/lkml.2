Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab2AFPAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:00:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55006 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030329Ab2AFPAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:00:37 -0500
Message-ID: <4F070C91.7020007@gmail.com>
Date: Fri, 06 Jan 2012 23:00:33 +0800
From: lina <lina.lastname@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: inux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: how to uninstall the b43 and reinstall
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

a quick question, how to clear the b43?


a detailed background stories as following:


I installed the b43 following the advice given by list,
mainly from
http://linuxwireless.org/en/users/Drivers/b43

it WORKED.

but yesterday I removed the old kernel 3.2-rc6, which is the one b43 worked,
and installed the 3.2 from kernel.org. I guess it's latest, than 3.2-rc6 ?

I don't know how to remove the b43 since the trial of
make uninstall in pathTo/b43-fwcutter-015 not work.

so I just did something like make install again, and then
1 
<http://linuxwireless.org/en/users/Drivers/b43#CA-d6bf7044c28bbe20619873aa0dd5f8faa0864c61_1> 
export FIRMWARE_INSTALL_DIR="/lib/firmware"
2 
<http://linuxwireless.org/en/users/Drivers/b43#CA-d6bf7044c28bbe20619873aa0dd5f8faa0864c61_2> 
wget http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
3 
<http://linuxwireless.org/en/users/Drivers/b43#CA-d6bf7044c28bbe20619873aa0dd5f8faa0864c61_3> 
tar xjf broadcom-wl-5.100.138.tar.bz2
4 sudo b43-fwcutter -w "$FIRMWARE_INSTALL_DIR" 
broadcom-wl-5.100.138/linux/wl_apsta.o

dmesg showed me:
[  127.434017] cfg80211: Calling CRDA to update world regulatory domain
[  127.704793] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
[  127.704821] bcma: Switched to core: 0x812
[  127.705237] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 9, Type 7, 
Revision 1)
[  127.705244] b43: probe of bcma0:0 failed with error -95
[  127.705260] Broadcom 43xx driver loaded [ Features: PMNLS ]
[  431.367724] applesmc: FS! : read arg fail

Thanks for any advice

