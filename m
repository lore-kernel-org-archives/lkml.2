Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2KDQcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 11:32:14 -0500
Received: from smtp.getmail.no ([84.208.15.66]:40797 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab2KDQcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 11:32:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Sun, 04 Nov 2012 17:32:10 +0100
Subject: re: sched: SCHED_DEADLINE v6
To: juri.lelli@gmail.com, linux-kernel@vger.kernel.org
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wm9b7wnn6426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. I am trying the Sched_deadline patch.

I am getting an error compiling:

kernel/sched/dl.c: In function ‘dl_runtime_exceeded’:
kernel/sched/dl.c:551:7: warning: unused variable ‘damount’  
[-Wunused-variable]
kernel/sched/dl.c:558:7: warning: unused variable ‘ramount’  
[-Wunused-variable]
kernel/sched/dl.c: In function ‘init_sched_dl_class’:
kernel/sched/dl.c:1521:6: error: ‘GFP_KERNEL’ undeclared (first use in  
this function)
kernel/sched/dl.c:1521:6: note: each undeclared identifier is reported  
only once for each function it appears in
kernel/sched/dl.c: At top level:
kernel/sched/dl.c:965:13: warning: ‘start_hrtick_dl’ defined but not used  
[-Wunused-function]
make[2]: *** [kernel/sched/dl.o] Error 1
make[1]: *** [kernel/sched] Error 2
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....

Peace Be With You.
