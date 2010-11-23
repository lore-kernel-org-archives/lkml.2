Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab0KWLuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:50:44 -0500
Received: from ns.hanzlici.cz ([212.158.159.56]:38766 "EHLO hanzlici.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0KWLun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:50:43 -0500
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2010 06:50:43 EST
Message-ID: <4CEBA51C.5010604@hanzlici.cz>
Date: Tue, 23 Nov 2010 12:27:24 +0100
From: Frantisek Hanzlik <franta@hanzlici.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9.1.16pre) Gecko/20101117 SeaMonkey/2.0.11pre
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrea Merello <andreamrl@tiscali.it>,
        Michael Wu <flamingice@sourmilk.net>
Subject: rtl8180 freeze some i386 systems
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.5 (hanzlici.cz [192.168.1.254]); Tue, 23 Nov 2010 12:27:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On two PCs with Fedora 14/i386 these systems freezes just after command
"ip link set wlan0 up" was entered.
"freezes" meant system is totally unuseable, ping to LAN interface
hasn't reply, kbd/mouse not work, only way is HW reset/power off.

This hang occurs always independently on system runlevel: when switch to
runlevel 1, when only kernel threads + udev + root bash are active,
system still hangs.
Systems hangs on all tested kernels 2.6.34, 2.6.35.9 and 2.6.36.
Systems hangs with implicit cmdline and too when using "nomodeset",
"acpi=noirq", "acpi=off", "pci=biosirq", "pci=routeirq", "pci=noacpi"
parameters.

I have two Zyxel "G-302 v3" wifi adapters reported as RTL 8185 rev 20
(10ec:8185), which on other two PCs with F1{3,4}/i386 and same config
works well.

Can someone help with? Is some general method for solving this issue?

Thank in advance, Franta Hanzlik
