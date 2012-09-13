Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab2IMKTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:19:06 -0400
Received: from mailrelayi.jaist.ac.jp ([150.65.19.7]:6528 "EHLO
	mailrelayi.jaist.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2IMKTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:19:03 -0400
X-IronPort-AV: E=Sophos;i="4.80,416,1344178800"; 
   d="scan'208";a="122817509"
Date: Thu, 13 Sep 2012 19:18:42 +0900
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: rtl8192se: ping router gives mdev of 25387.102???
Message-ID: <20120913101828.GA3309@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please cc)

see $subject ...

No warning, nothing in the logs, but pinging my router I get
things like:
--- 192.168.0.1 ping statistics ---
376 packets transmitted, 315 received, +33 errors, 16% packet loss, time 405164ms
rtt min/avg/max/mdev = 0.873/10077.793/95935.698/25387.102 ms, pipe 68

or
--- 192.168.0.1 ping statistics ---
1252 packets transmitted, 1225 received, 2% packet loss, time 1252976ms
rtt min/avg/max/mdev = 0.941/764.171/19929.265/2758.225 ms, pipe 20


Has anyone *ever* seen a mdev of 25387.102 ms ???

At the same time I am pinging the same router from an iphone with a 
steady stream of 40ms or so, no problem whatsoever ...

$ lspci -v -s 03:00.0
03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. Device e020
	Flags: bus master, fast devsel, latency 0, IRQ 17
 	I/O ports at 2000 [size=256]
 	Memory at f0500000 (32-bit, non-prefetchable) [size=16K]
 	Capabilities: [40] Power Management version 3
 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
 	Capabilities: [70] Express Legacy Endpoint, MSI 00
 	Capabilities: [100] Advanced Error Reporting
 	Capabilities: [140] Virtual Channel
 	Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
 	Kernel driver in use: rtl8192se

That is with git from yesterday or so.

Best wishes

Norbert

----------------------------------------------------------------------------
Norbert Preining                preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                   TeX Live and Debian Developer
gpg DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
----------------------------------------------------------------------------
`Ford, you're turning into a penguin. Stop it.'
                 --- Arthur experiences the improbability drive at work.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
