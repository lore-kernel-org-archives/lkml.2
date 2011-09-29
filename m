Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab1I2RQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:16:37 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:35012 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab1I2RQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:16:36 -0400
X-Greylist: delayed 1468 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Sep 2011 13:16:36 EDT
Date: Fri, 30 Sep 2011 01:52:07 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Cc: ipw3945-devel@lists.sourceforge.net
Subject: iwlagn after suspend to ram and wakeup unusable, probe failed
	error -22
Message-ID: <20110929165207.GD19653@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please cc)

I am running one very recent kernel from git, currently 815d405cef,
and I am regularly having problem getting iwlagn to work after some
suspend/resume activity. It ends with no (NO!) way to get it working
but rebooting. Removing the iwlagn module does *not* help.

In the syslog I see:
[33824.855174] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[33824.855178] Copyright(c) 2003-2011 Intel Corporation
[33824.868124] iwlagn 0000:06:00.0: Refused to change power state, currently in D3
[33824.868153] iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[33824.868601] iwlagn 0000:06:00.0: pci_resource_len = 0x00002000
[33824.868609] iwlagn 0000:06:00.0: pci_resource_base = ffffc900048fc000
[33824.868616] iwlagn 0000:06:00.0: HW Revision ID = 0x0
[33824.868631] iwlagn 0000:06:00.0: pci_enable_msi failed
[33824.868654] iwlagn 0000:06:00.0: PCI INT A disabled
[33824.868674] iwlagn: probe of 0000:06:00.0 failed with error -22


OTOH, a good log from booting is:
[   54.232710] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   54.255001] Copyright(c) 2003-2011 Intel Corporation
[   54.264822] iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   54.277528] iwlagn 0000:06:00.0: setting latency timer to 64
[   54.277588] iwlagn 0000:06:00.0: pci_resource_len = 0x00002000
[   54.280334] iwlagn 0000:06:00.0: pci_resource_base = ffffc9000007c000
[   54.292903] iwlagn 0000:06:00.0: HW Revision ID = 0x0
[   54.319506] iwlagn 0000:06:00.0: irq 46 for MSI/MSI-X
[   54.319805] iwlagn 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   54.322467] iwlagn 0000:06:00.0: L1 Enabled; Disabling L0S

Thanks for any suggestion or help

Norbert

------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
GANGES (n. rare : colonial Indian)
Leg-rash contracted from playing too much polo. (It is a little-known
fact that Prince Charles is troubled by ganges down the inside of his
arms.)
			--- Douglas Adams, The Meaning of Liff
