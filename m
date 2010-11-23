Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0KWNSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:18:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42595 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab0KWNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:18:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ejX15wIS03y2yHFo2ZBmsI0A+lV6H027+s8aShSWg0t0Sr8tWgjMvmAxCkymFe9gYL
         brUAVfsg6pUuahqRerdkPxfeCHDTby+lkC1lD05zMfCqhb8zMW4bxIL1tJk4MFaGYq/a
         rqHIuCZ6XqUC9OcElULMHEX4R4cNLOmSVRbxQ=
Message-ID: <4CEBBF07.9090607@gmail.com>
Date: Tue, 23 Nov 2010 10:17:59 -0300
From: thiago <thsalex@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with usb card
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,
First, sorry for my poor english.
Second, i'm a beginner embedded system developer and i have a problem
with manage my sdcard (usb). Below my /var/log/dmesg with error mensage:

[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-custom #1
[    0.000000]  [<c0121207>] warn_on_slowpath+0x40/0x4f
[    0.000000]  [<c02b1dfd>] _spin_unlock_irqrestore+0xd/0x10
[    0.000000]  [<c0121897>] release_console_sem+0x186/0x19f
[    0.000000]  [<c0121cc0>] vprintk+0x2d0/0x2fe
[    0.000000]  [<c0372eb0>] mtrr_trim_uncached_memory+0x1a7/0x1ac
[    0.000000]  [<c0370f64>] setup_arch+0x23d/0x418
[    0.000000]  [<c036b5c6>] start_kernel+0x70/0x33a
[    0.000000]  =======================
[    0.000000] ---[ end trace ca143223eefdc828 ]---

After that message error, i lost the partition table of the my sdcard
and all work is lost too


-- 
Thiago Silveira Alexandre
LPI I Certified


