Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1JZEtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:49:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62596 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1JZEtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:49:02 -0400
MIME-Version: 1.0
Date: Wed, 26 Oct 2011 00:49:02 -0400
X-Google-Sender-Auth: V16CGPT4zShL-uC_tOwrKd-IBgI
Message-ID: <CABDyM6T5_rwkEUu6133Xmgbyfo5naPNLEBrtyMiwrX3vHNdtdQ@mail.gmail.com>
Subject: Random I/O lags on Lenovo T520: exception Emask 0x10 SAct 0x0 SErr
 0x4040000 action 0xe frozen
From: Richard Yao <ryao@cs.stonybrook.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Everyone,

I am seeing the following my system log on my 5 month old Lenovo T520,
which has an OCZ Vertex 3 with the 2.15 firmware from OCZ:

[38985.474597] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[38985.474606] ata4: irq_stat 0x00000040, connection status changed
[38985.474621] ata4: hard resetting link
[38986.196436] ata4: SATA link down (SStatus 0 SControl 300)
[38986.207412] ata4: EH complete
[39109.561841] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[39109.561851] ata4: irq_stat 0x00000040, connection status changed
[39109.561865] ata4: hard resetting link
[39110.283738] ata4: SATA link down (SStatus 0 SControl 300)
[39110.294765] ata4: EH complete
[41874.348949] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[41874.348958] ata4: irq_stat 0x00000040, connection status changed
[41874.348973] ata4: hard resetting link
[41875.070896] ata4: SATA link down (SStatus 0 SControl 300)
[41875.081871] ata4: EH complete
[42038.632726] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[42038.632736] ata4: irq_stat 0x00000040, connection status changed
[42038.632750] ata4: hard resetting link
[42039.354452] ata4: SATA link down (SStatus 0 SControl 300)
[42039.365441] ata4: EH complete
[45924.973330] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[45924.973339] ata4: irq_stat 0x00000040, connection status changed
[45924.973353] ata4: hard resetting link
[45925.694644] ata4: SATA link down (SStatus 0 SControl 300)
[45925.705593] ata4: EH complete
[47147.406966] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[47147.406975] ata4: irq_stat 0x00000040, connection status changed
[47147.406989] ata4: hard resetting link
[47148.128733] ata4: SATA link down (SStatus 0 SControl 300)
[47148.139655] ata4: EH complete
[49175.880115] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[49175.880124] ata4: irq_stat 0x00000040, connection status changed
[49175.880137] ata4: hard resetting link
[49176.601441] ata4: SATA link down (SStatus 0 SControl 300)
[49176.612382] ata4: EH complete
[61159.032750] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[61159.032759] ata4: irq_stat 0x00000040, connection status changed
[61159.032773] ata4: hard resetting link
[61159.753832] ata4: SATA link down (SStatus 0 SControl 300)
[61159.764804] ata4: EH complete
[67797.682487] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[67797.682496] ata4: irq_stat 0x00000040, connection status changed
[67797.682510] ata4: hard resetting link
[67798.403637] ata4: SATA link down (SStatus 0 SControl 300)
[67798.414643] ata4: EH complete
[73680.166448] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[73680.166453] ata4: irq_stat 0x00000040, connection status changed
[73680.166461] ata4: hard resetting link
[73680.887669] ata4: SATA link down (SStatus 0 SControl 300)
[73680.898649] ata4: EH complete

Whenever this happens, KDE becomes semi-unresponsive. My first thought
was that this might be an indicator that the Intel Cougar Point
chipset in my laptop is dying, but I did a quick google search and
people seemed to think it was a kernel bug. The last time I called
Lenovo about an issue I had encountered, they told me that unless they
can reproduce it on Windows, they would not do anything.  Does it look
like a hardware problem or a kernel bug? I want the opinion of someone
here before I call Lenovo about it.

Yours truly,
Richard Yao
