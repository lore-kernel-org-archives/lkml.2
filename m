Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2LAXty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 18:49:54 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:47623 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2LAXtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 18:49:53 -0500
Date: Sat, 1 Dec 2012 18:49:51 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: daniel.vetter@ffwll.ch, mjg59@srcf.ucam.org
Message-ID: <1328143975.121508.1354405791738.JavaMail.root@elliptictech.com>
In-Reply-To: <268628838.121506.1354405604521.JavaMail.root@elliptictech.com>
Subject: Brightness control fails between 3.6.8 and 3.7.0-rc7 (Intel
 915/Dell Vostro 3560)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.112]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - FF3.0 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Somewhere between v3.6.8 [vanilla] and 3.7.0-rc7 the ability to control the LCD brightness was broken on this laptop [details below].  Basically it locks the brightness as full brightness and cannot be changed.  It works properly in v3.6.8 though [and below...].

Details:

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
	Subsystem: Dell Device 056e
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at c3000000 (64-bit, non-prefetchable) [size=4M]
	Memory at b0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 5000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Capabilities: [a4] PCI Advanced Features
	Kernel driver in use: i915

This is on a Dell Vostro 3560/0C05GV

I have the discrete radeon turned off [via vgaswitcheroo].  I have dell_wmi and dell_laptop loaded.  I use the same kernel config between the two builds.

Tom
