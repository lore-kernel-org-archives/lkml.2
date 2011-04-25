Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1DYQPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:15:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39516 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1DYQPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=S8ow8F9MTycOPgdIszi0Goe2iLGq6G2/a0YWTveS5JuzfRzGkzjc4Jx4Wn+ym4MlHR
         F42cNeA5iNAhsC1To9QSSgC0mIlGKazU/os/xfmOcUv79PmCUy6FhP2XB2eIBZhSWA4J
         z5T4gehaf4FUPJRwiXNVzK7xplydEjT1EjgMU=
MIME-Version: 1.0
Date: Tue, 26 Apr 2011 00:15:15 +0800
Message-ID: <BANLkTikSh6WGeBE4u2tOj_rxjSVcv_4PuQ@mail.gmail.com>
Subject: kernel configuration to support network and graphic card
From: lina <lina.lastname@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am not familiar with so many options during configuration.

can anybody give me some specific clues during configuration which
make the support of below graphic driver and network connection. if
possible wireless will be great appreciated.

and which is the best version of kernel I should choose.

Really thanks for any advice,


# lspci

00:00.0 Host bridge: Intel Corporation Sandy Bridge DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Sandy Bridge PCI Express Root
Port (rev 09)
00:01.1 PCI bridge: Intel Corporation Sandy Bridge PCI Express Root
Port (rev 09)
00:16.0 Communication controller: Intel Corporation Cougar Point HECI
Controller #1 (rev 04)
00:1a.0 USB Controller: Intel Corporation Cougar Point USB Universal
Host Controller #5 (rev 05)
00:1a.7 USB Controller: Intel Corporation Cougar Point USB Enhanced
Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation Cougar Point High Definition
Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation Cougar Point PCI Express Root
Port 1 (rev b5)
00:1c.1 PCI bridge: Intel Corporation Cougar Point PCI Express Root
Port 2 (rev b5)
00:1c.2 PCI bridge: Intel Corporation Cougar Point PCI Express Root
Port 3 (rev b5)
00:1d.0 USB Controller: Intel Corporation Cougar Point USB Universal
Host Controller #1 (rev 05)
00:1d.7 USB Controller: Intel Corporation Cougar Point USB Enhanced
Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation Cougar Point LPC Controller (rev 05)
00:1f.2 IDE interface: Intel Corporation Cougar Point 4 port SATA IDE
Controller (rev 05)
00:1f.3 SMBus: Intel Corporation Cougar Point SMBus Controller (rev 05)
01:00.0 VGA compatible controller: ATI Technologies Inc NI Whistler
[AMD Radeon HD 6600M Series]
01:00.1 Audio device: ATI Technologies Inc Device aa90
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57765
Gigabit Ethernet PCIe (rev 10)
02:00.1 SD Host controller: Broadcom Corporation Device 16bc (rev 10)
03:00.0 Network controller: Broadcom Corporation Device 4331 (rev 02)
04:00.0 FireWire (IEEE 1394): Agere Systems FW643 PCI Express1394b
Controller (PHY/Link) (rev 08)


best regards,

lina
