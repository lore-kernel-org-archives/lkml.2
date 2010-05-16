Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0EPHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:25:26 -0400
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:45343 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753318Ab0EPHZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:25:25 -0400
Date: Sun, 16 May 2010 15:25:23 +0800
From: "backyes" <backyes@mail.ustc.edu.cn>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: About HOW TO use "SCHED_FIFO"
Message-ID: <201005161525234066346@mail.ustc.edu.cn>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: yia_0ZCbA17ene9LAL0BBQ--.48188S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUUYxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUjGxYjxAI6xCIbckI1I0E57IF64kEYxAxM7k042IE4asKkaVY67At
	M7k0a2IF6F4UM7kC6x804xWl14x267AKxVWUJVW8JwAFxVCF77xC6IxKo4kEV4yl1I0Esc
	IYIxCEI4klw4CSwwAFIxvE14AKwVWUJVWUGwA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l
	84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s
	1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67kvxFCE548m6r1fGryUXwAqjxCE
	34x0Y48IcwAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx
	0Ex4A2jsIE14v26r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxCIbckI
	1I0E14v26r1Y6r17MxCIbVAxMI8E67AF67kF1VAFwI0_Jr0_JrylIxAIcVC2z280aVAFwI
	0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JwCqF7xvr2IY62kE34x0Y4UvcSsG
	vfC2KfnxnUUI43ZEXa7IU86OJ5UUUUU==
X-CM-SenderInfo: 5edfy51hv6zt1loo32lwfovvfxof0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
Anyone has the experience of using the linux real-schedule with SCHED_FIFO? Or any material about HOw to use it?
I have designed a scheme with 5 threads running in the 5 cores. I set the affinity of threads to enable one thread run in one core. All threads own SCHED_FIFO policy. 
All threas have no I/O operation. And I want to make these cores occupied by these threads only. 
So Any problem?
 I do not know wether it has some better method to take advantage of the SCHED_FIFO policy in linux? Or what function can SCHED_FIFO do ? What's the target for SCHED_FIFO?
That's all , Thanks .
--Peter Wang 


