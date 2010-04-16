Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0DPKh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 06:37:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2017 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772Ab0DPKh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 06:37:56 -0400
X-Greylist: delayed 1712 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2010 06:37:56 EDT
Message-ID: <000b01cadd4c$e2f94380$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Intel OTC" <joel.clark@intel.com>, <andrew.chih.howe.khor@intel.com>
Subject: [PATCH]Add device drivers (GbE, Packet Hub) for Topcliff
Date: Fri, 16 Apr 2010 19:09:04 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I developed the device drivers for Linux kernel 2.6.33-1.
This time, I added the following drivers
  - GbE device
  - Packet HUB device

Would you check them?

The patch is uploaded to our WEB site in Sourceforge.net,
Because the patch size was large.

[Our WEB site in Sourceforge.net.]
http://sourceforge.net/projects/generalembedded/files/
"All Files" -> "Downloads" -> "Dev" -> "kernel 2.6.33-1"
  - pch_gbe.patch  (for GbE device)
  - pch_phub.patch (for Packet HUB device)


[About our development product]
Topcliff is a chip that has many peripherals.
The chip has UART, I2C, SPI, IEEE1588, CAN, Packet HUB, SATA, USB host, USB
device, SDIO, Gigabit Ethernet, GPIO and DMA.

Best regards,
