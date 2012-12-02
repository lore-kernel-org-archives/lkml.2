Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2LBLdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 06:33:00 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:2770 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2LBLc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 06:32:58 -0500
Date: Sun, 2 Dec 2012 06:32:57 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: daniel vetter <daniel.vetter@ffwll.ch>
Message-ID: <1394390827.121688.1354447977594.JavaMail.root@elliptictech.com>
In-Reply-To: <1328143975.121508.1354405791738.JavaMail.root@elliptictech.com>
Subject: Re: Brightness control fails between 3.6.8 and 3.7.0-rc7 (Intel
 915/Dell Vostro 3560)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.112]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC23 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've narrowed it down to sometime between v3.6.8 and v3.7-rc1.  So none of the v3.7 series will work with this GPU/panel.

I don't think it has anything to do with the dell modules since they haven't changed.

Tom


----- Original Message -----
> From: "Tom St Denis" <tstdenis@elliptictech.com>
> To: linux-kernel@vger.kernel.org
> Cc: "daniel vetter" <daniel.vetter@ffwll.ch>, mjg59@srcf.ucam.org
> Sent: Saturday, 1 December, 2012 6:49:51 PM
> Subject: Brightness control fails between 3.6.8 and 3.7.0-rc7 (Intel 915/Dell Vostro 3560)
> 
> Hello all,
> 
> Somewhere between v3.6.8 [vanilla] and 3.7.0-rc7 the ability to
> control the LCD brightness was broken on this laptop [details
> below].  Basically it locks the brightness as full brightness and
> cannot be changed.  It works properly in v3.6.8 though [and
> below...].
> 
> Details:
> 
> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
> processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
> 	Subsystem: Dell Device 056e
> 	Flags: bus master, fast devsel, latency 0, IRQ 44
> 	Memory at c3000000 (64-bit, non-prefetchable) [size=4M]
> 	Memory at b0000000 (64-bit, prefetchable) [size=256M]
> 	I/O ports at 5000 [size=64]
> 	Expansion ROM at <unassigned> [disabled]
> 	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> 	Capabilities: [d0] Power Management version 2
> 	Capabilities: [a4] PCI Advanced Features
> 	Kernel driver in use: i915
> 
> This is on a Dell Vostro 3560/0C05GV
> 
> I have the discrete radeon turned off [via vgaswitcheroo].  I have
> dell_wmi and dell_laptop loaded.  I use the same kernel config
> between the two builds.
> 
> Tom
