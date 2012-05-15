Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965177Ab2EOPZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:25:45 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40170 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757459Ab2EOPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:25:43 -0400
Message-ID: <4FB275EB.5050904@linaro.org>
Date: Tue, 15 May 2012 19:27:39 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Perf record format portability
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

are there any thoughts on how much of the perf.data is portable and how much it should be?
I'm interesting in recording scheduler activity on one machine and then replaying on
another. As I can see, replaying x86 perf.data on ARM doesn't work. At least, should it
work with a small subset of recorded events (for example, sched:sched_switch,
sched:sched_process_exit, sched:sched_process_fork, sched:sched_wakeup
and sched:sched_migrate_task) on the same architecture?

Thanks in advance,
Dmitry
