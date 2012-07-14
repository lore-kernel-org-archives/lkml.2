Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2GNCTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 22:19:03 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:45711 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750745Ab2GNCTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 22:19:00 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.5-rc6 fb hw inteldrmfb
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 13 Jul 2012 22:18:55 -0400
Message-ID: <web-769686321@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a computer of someone else, on which today I tried to 
install 3.5-rc6 (what on my computer and on an HP pavillon 
laptop runs without problem - on the laptop however needs 
ircpoll otherwhise don't find the harddisk), few seconds 
after start booting it sticks and don't continue longer 
(reboot not possible with Ctr-Alt-C but only pressing the 
reboot button), the last message is:   "conflicting fb hw 
usage inteldrmfb vs VESA VGA - removing generic driver" 
        then the cursor stops blinking, and the computer 
sticks.
With 3.4 the same computer runs since weeks without 
problems.  So, that's a regression.

Inspection of syslog, messages, debug don't show anything 
from this boot, it seems before the crash it hasn't nor 
time to log something.

Below is the lspci of that computer.


wl




00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL 
Memory Controller Hub (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 
82945G/GZ Integrated Graphics Controller (rev 02)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 
Family) High Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) 
PCI Express Port 1 (rev 01)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) 
PCI Express Port 2 (rev 01)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) 
PCI Express Port 3 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) 
PCI Express Port 4 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 
Family) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 
Family) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 
Family) USB UHCI Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 
Family) USB UHCI Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 
Family) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge 
(rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 
Family) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 
Family) IDE Controller (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH 
(ICH7 Family) SATA IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) 
SMBus Controller (rev 01)
05:00.0 Ethernet controller: Broadcom Corporation 
NetXtreme BCM5751 Gigabit Ethernet PCI Express (rev 01)

---
Professional hosting for everyone - http://www.host.ru
