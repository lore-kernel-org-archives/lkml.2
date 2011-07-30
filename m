Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab1G3EOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:14:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55807 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1G3EOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:14:33 -0400
Message-ID: <4E33851C.2000806@lwfinger.net>
Date: Fri, 29 Jul 2011 23:14:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: "linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Problem with ide-cs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 3.0, my external hard drive attached to a PCMCIA card reports "irq 
11: nobody cared (try booting with the "irqpoll" option)". The driver in 
question is ide-cs. When I try irqpoll, the device works correctly. Naturally, 
the interrupt is shared with yenta, the PCMCIA adapter driver. In addition, that 
same interrupt is used by a BCM4318 Cardbus device.

I plan on preparing a Bugzilla entry for this problem, but I'm not quite ready. 
What I would like to know if there is any documentation on what kinds of changes 
are needed to fix the problem.

Thanks,

Larry
