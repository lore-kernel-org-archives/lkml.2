Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0KWNvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:51:38 -0500
Received: from mail.intechne.com.br ([200.253.157.14]:52486 "EHLO
	smtp.intechne.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0KWNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:51:37 -0500
X-Greylist: delayed 2055 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2010 08:51:37 EST
Message-ID: <4CEBBEDD.9070809@intechne.com.br>
Date: Tue, 23 Nov 2010 10:17:17 -0300
From: thiago <silveira@intechne.com.br>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with usb
X-Enigmail-Version: 0.95.7
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
Security Enginner


