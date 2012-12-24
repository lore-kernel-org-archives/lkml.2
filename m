Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2LXE2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 23:28:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2LXE15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 23:27:57 -0500
Message-ID: <1356323269.5656.43.camel@marge.simpson.net>
Subject: Re: dire state of rtl driver in 3.7
From: Mike Galbraith <bitbucket@online.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Norbert Preining <preining@logic.at>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Dec 2012 05:27:49 +0100
In-Reply-To: <50D7572E.8060908@lwfinger.net>
References: <20121222150909.GA3979@gamma.logic.tuwien.ac.at>
	 <1356241795.5620.47.camel@marge.simpson.net>
	 <50D7572E.8060908@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:jrSN/wx44FEDubzLYeu/B8ua4tZCJoC2px4VldtRDcI
 TwCUWi6ssLYZcsK5E7tr+eMLFnjn3PHr1VyJH5gIIgXq8x7yOV
 3Uv264durwvWPVPMyEvbiarHnMy+2K3FYHOIaTMsOXo5zEJENl
 lufRP4u2CImhEC3XSCFqrj9m7tLlOoiR5UwXAozuHSjGgQ8p5C
 SDBaHK+SJwYPcWuyeihIJozW/zjTvWUDeYVoQXBB9jW1nm8P7S
 dOMb/Qs5JLG9IMHzGiLLMitq6kDvvpDvkRY3B7FmNz8rjiWdIG
 YHiFD/cVXgvKaZl5QvKGhtaCe9oYjr4wnD4C9IARfN9icNaEDl
 sstbDk9ltrnmh0CiT0JOFFWXGonyzWV2pyF3zajCbAoKnhj2Mx
 pE9vl+Hu/Y2XA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-23 at 13:10 -0600, Larry Finger wrote:

> Note, the RTL8188CE uses rtl8192ce, while the RTL8191SE uses rtl8192se. They 
> share the underlying plumbing in driver rtlwifi, but the rest is completely 
> different.

Driver here is rtl8192se.

08:00.0 0280: 10ec:8172 (rev 10)
	Subsystem: 10ec:8181
	Flags: bus master, fast devsel, latency 0, IRQ 17
	I/O ports at 4000 [size=256]
	Memory at c0900000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192se

Point was, driver state may still be dire for some hardware, but here,
the same driver for very similar looking hardware went from useless to
works fine.

My desktop box has this thing in it, which also used to be completely
useless with the in kernel driver, but now works (it's still useless,
router sits on top of that box;).  Both devices now seem to work just
fine, whereas both used to be a PITA if I wanted to use them.

Bus 001 Device 004: ID 13d3:3247 IMC Networks 802.11 n/g/b Wireless LAN Adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x13d3 IMC Networks
  idProduct          0x3247 802.11 n/g/b Wireless LAN Adapter
  bcdDevice            8.01
  iManufacturer           1 Ralink
  iProduct                2 802.11 n WLAN
  iSerial                 3 1.0




