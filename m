Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2CXLzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 07:55:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62255 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2CXLzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 07:55:43 -0400
MIME-Version: 1.0
Date: Sat, 24 Mar 2012 17:25:41 +0530
Message-ID: <CAP=ejEsGRF2i0Rr_W8cNZgJ8W+PHzHNpVRsBtMTmfEiVro+Kjw@mail.gmail.com>
Subject: Query on Linux process sheduling
From: "B.Vinai Kumar" <vinaibangala2001@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I have embedded box running 2.6.28.9 linux kernel and running 6 Real
time task threads (With SCHED_RR as scheduling policy).
Together all the 6 threads running is consuming around 85% of CPU,
which is expected.

All the threads have a 10ms of cycle.

The issue is for every second I have observed that for 50ms these Real
time task threads are not scheduling at all. During this 50ms
the process swapper/idle task is being scheduled(pid 0).

Is this the behaviour is due to these values?

# cat /proc/sys/kernel/sched_rt_period_us
1000000
# cat /proc/sys/kernel/sched_rt_runtime_us
950000

What changes can be done to the kernel so that the Real time task
threads get scheduled in that 50ms interval too?

Thanks,
Vinai.
