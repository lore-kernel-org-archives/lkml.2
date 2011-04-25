Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1DYQKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:10:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39493 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1DYQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Q9hVNmKLaQr5zMvnT2m6Bx6NU2EBi4diokLaHt0mG9tK7rukMCK6PgbdOTiO50OOdZ
         QXacdTZeDQAOydHuXhSAkHu0wBdIVPSsW5uChBvxLOQ3Ld3PaAPwbb3kjPwjLvOi9Azu
         PHV6Zt7Yr/thDetaGqcyM968YQT4f+8NVrZ0A=
MIME-Version: 1.0
In-Reply-To: <BANLkTikcHuu7TchE4qzENiUK9bxwJJYFoA@mail.gmail.com>
References: <BANLkTikcHuu7TchE4qzENiUK9bxwJJYFoA@mail.gmail.com>
Date: Tue, 26 Apr 2011 00:10:51 +0800
Message-ID: <BANLkTikKt7OODqbD76mNr8G4a5vw1QP_mw@mail.gmail.com>
Subject: how to configure specifically?
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
