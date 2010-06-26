Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0FZRk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 13:40:26 -0400
Received: from postin.uv.es ([147.156.1.90]:50093 "EHLO postin.uv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab0FZRkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 13:40:25 -0400
X-Greylist: delayed 2570 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jun 2010 13:40:24 EDT
Message-ID: <4C26317A.5070309@postal.uv.es>
Date: Sat, 26 Jun 2010 18:57:30 +0200
From: Enrico Bandiello <enban@postal.uv.es>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Thunderbird/2.0.0.22 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: i915 in kernel 2.6.35-rc3, high number of wakeups
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Userflux: User e-mail Flow checked by Userflux
X-RelayDelay-Mem: Whitelisted relay grajo.ci.uv.es [147.156.0.253]. Not delayed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all. I was testing kernel 2.6.35-rc3 and I noticed that maybe there's
a little regression: the module "i915" shows an high number of wakeups in
powertop (60-72) on an otherwise idle laptop. This is not happening on
kernel 2.6.34 that works fine (few or no i915 wakeups when idle ).
I'm using a Toshiba Satellite L300 and my distro is a Debian
testing/unstable mix.

lspci output:

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory 
Controller Hub (rev 07)
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series 
Chipset Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset 
Integrated Graphics Controller (rev 07)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio 
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 2 (rev 03)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 5 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller 
(rev 03)
00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI 
Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller 
(rev 03)
03:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless 
Network Adapter (rev 01)

This is the first time I write on LKML, so forgive please me if there're
errors in this bug(?) report and feel free to contact me if you need 
more info.
And please CC me, because I'm not subscribed to LKML.

Thank you very much, have a nice day.
