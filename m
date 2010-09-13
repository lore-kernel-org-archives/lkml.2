Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0IMOuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:50:10 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:43470 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0IMOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:50:08 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 10:50:08 EDT
Date: Mon, 13 Sep 2010 16:27:05 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: Linux Kernel-Liste <linux-kernel@vger.kernel.org>
Subject: INFO: task uptime daemon blocked for more than 120 seconds
Message-ID: <20100913142705.GH25129@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Sorry, failed to get hold of kernel version on this one.

Feb 22 14:26:24 localhost kernel: [980040.359122] INFO: task ud:29897 blocked for more than 120 seconds.
Feb 22 14:26:24 localhost kernel: [980040.359129] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 22 14:26:24 localhost kernel: [980040.359135] ud            D 00037b34     0 29897      1 0x00000000
Feb 22 14:26:24 localhost kernel: [980040.359146]  00000000 00200082 c10353da 00037b34 7cddc0d3 a1348355 0000dee9 a18096c5
Feb 22 14:26:24 localhost kernel: [980040.359162]  0000dee9 c1acdbe4 de74a030 de74a2e4 c4408400 00000000 00000000 7cddce0e
Feb 22 14:26:24 localhost kernel: [980040.359177]  00037b34 7cddc0d3 f6b6ee40 de74a2e4 00f19c7b 01c9c380 d0826adc 000037d0
Feb 22 14:26:24 localhost kernel: [980040.359193] Call Trace:
Feb 22 14:26:24 localhost kernel: [980040.359209]  [<c10353da>] ? select_task_rq_fair+0x34a/0x990
Feb 22 14:26:24 localhost kernel: [980040.359223]  [<c1746759>] ? _spin_lock_irqsave+0x19/0x40
Feb 22 14:26:24 localhost kernel: [980040.359235]  [<c11092f5>] ? bdi_sched_wait+0x5/0x10
Feb 22 14:26:24 localhost kernel: [980040.359243]  [<c17451e7>] ? __wait_on_bit+0x47/0x70
Feb 22 14:26:24 localhost kernel: [980040.359251]  [<c11092f0>] ? bdi_sched_wait+0x0/0x10
Feb 22 14:26:24 localhost kernel: [980040.359284]  [<c11092f0>] ? bdi_sched_wait+0x0/0x10
Feb 22 14:26:24 localhost kernel: [980040.359292]  [<c17452c3>] ? out_of_line_wait_on_bit+0xb3/0xd0
Feb 22 14:26:24 localhost kernel: [980040.359304]  [<c1062620>] ? wake_bit_function+0x0/0x70
Feb 22 14:26:24 localhost kernel: [980040.359313]  [<c110936a>] ? sync_inodes_sb+0x6a/0x130
Feb 22 14:26:24 localhost kernel: [980040.359322]  [<c110d653>] ? __sync_filesystem+0x63/0x70
Feb 22 14:26:24 localhost kernel: [980040.359330]  [<c110d727>] ? sync_filesystems+0xc7/0x100
Feb 22 14:26:24 localhost kernel: [980040.359338]  [<c110d7a8>] ? sys_sync+0x18/0x40
Feb 22 14:26:24 localhost kernel: [980040.359346]  [<c1002ef0>] ? sysenter_do_call+0x12/0x22

                Cheers,

                      Nils

