Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3ADSWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 13:22:16 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50531 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3ADSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 13:22:14 -0500
From: Sadasivan Shaiju <sshaiju@mvista.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac3qqEdXtctrIiP/QRaaF7J1igGZcg==
Date: Fri, 4 Jan 2013 10:22:12 -0800
Message-ID: <aba006370d1e788a3ff0612afca6d3e7@mail.gmail.com>
Subject: Incorrect accounting of irq into the running task
To: linux-kernel@vger.kernel.org
Cc: venki@google.com, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Venkatesh,

I  have  applied   the  following   patches   for  the  incorrect
accounting   of   irq  into  the  running  task .


[PATCH] x86: Add IRQ_TIME_ACCOUNTING
[e82b8e4ea4f3dffe6e7939f90e78da675fcc450e]
[PATCH] sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time
[b52bfee445d315549d41eacf2fa7c156e7d153d5]

[PATCH] sched: Do not account irq time to current task
[305e6835e05513406fa12820e40e4a8ecb63743c]
[PATCH] sched: Export ns irqtimes through /proc/stat
[abb74cefa9c682fb38ba86c17ca3c86fed6cc464]



But   still  the      stime   and  utime    of   the   process  in
/proc/pid/stat     is    high  .    I  think   the  above  patches  does
not   update
The  stime  and  utime  values     in    /proc/pid/stat  .


Or  am  I  missing   anything  ?


Regards,
Shaiju.
