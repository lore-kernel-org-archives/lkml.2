Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2JVGDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:03:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41517 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2JVGDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:03:53 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 08:03:51 +0200
Message-ID: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com>
Subject: Major performance regressions in 3.7rc1/2
From: Patrik Kullman <patrik.kullman@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using an Asus Zenbook UX31E and have been installing all RCs in
hope of improving the Wireless and Touchpad functionality.
However, when trying 3.7 (rc1 and now rc2) I have major performance issues.

Easiest way to reproduce is to launch and play a game like Nexuiz,
where the computer will lag, stutter and freeze until the machine is
unresponsive within a couple of minutes.
But an easy workload like browsing will also cause lags when switching
tabs or redrawing a web page after a tab switch.
Basically 3.7 is unusable for this machine.

I have been installing the pre-built kernels from
http://kernel.ubuntu.com/~kernel-ppa/mainline/

In case lspci is interesting:
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
Family DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200
Series Chipset Family MEI Controller #1 (rev 04)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 1 (rev b5)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 2 (rev b5)
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 4 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation QS67 Express Chipset Family LPC
Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
Chipset Family 6 port SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
SMBus Controller (rev 05)
02:00.0 Network controller: Atheros Communications Inc. AR9485
Wireless Network Adapter (rev 01)
03:00.0 USB controller: Fresco Logic Device 1009 (rev 02)


Let me know if there are some simple tests I can do, I'm not sure I'll
have time to bisect any time soon.

Thanks in advance,
Patrik
