Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0CWPXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:23:08 -0400
Received: from smtp.getmail.no ([84.208.15.66]:45379 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab0CWPXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:23:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
X-PMX-Version: 5.5.3.366731, Antispam-Engine: 2.7.0.366912,
 Antispam-Data: 2010.3.23.151224
To: linux-kernel@vger.kernel.org
Date: Tue, 23 Mar 2010 16:22:27 +0100
Subject: Optimal refresh rate for minimal psychovisual noise,
 and tuning the kernel for it.
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.u900zpso6426ze@pxu>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peace Be With You.

I have earlier done some work with audio, and made a limiter, which can be  
downloaded at http://www.sourceforge.com/projects/pxu, along with some  
other plugins.

I extended the philosophy to video, and particulary the UI, and refresh  
rate.

I found that a refresh rate of approximately 72.586hz is optimal, and  
contains the least psychovisual noise.
Things become more lifelike, and much more information is registered by  
the human perception.

I would like to share this information with you, and a modesetting for x,  
for 1280x1024, so you can test for yourself.

I would also like to know, if there is any tunables in the linux kernel,  
that I can tweak, to further enhance it, for 72.586hz refresh rates. I  
have already enabled preemptive RCU, and full desktop preemption.

I would also like to extend the philosophy, to the HZ setting of the  
kernel, or other settings, and ask if anyone can make, or know patches,  
that makes these tunables, accesible in realtime, with a cat.

Peace Be With You.

NB: Here is also a modeline for X, which contains the 72.586hz screenmode,  
in 1280x1024 resolution.

"1280x1024" 130.612 1280 1296 1440 1688 1024 1025 1028 1066 +hsync +vsync


