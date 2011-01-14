Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1ANVV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:21:59 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:59421 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1ANVV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:21:58 -0500
X-ASG-Debug-ID: 1295040117-1789a9600001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D30BE71.3050801@fusionio.com>
Date: Fri, 14 Jan 2011 22:21:53 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Follow up block pull request for 2.6.38-rc1
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Follow up block pull request for 2.6.38-rc1
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1295040117
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4741 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.52386
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Mainly pushing this now to get Tejuns tested fix out the door. Also
included are two CFQ optimizations.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Shaohua Li (2):
      block cfq: make queue preempt work for queues from different workload
      block cfq: compensate preempted queue even if it has no slice assigned

Tejun Heo (1):
      block: restore multiple bd_link_disk_holder() support

 block/cfq-iosched.c   |   28 +++++++++++++--
 drivers/md/dm-table.c |    1 +
 drivers/md/md.c       |    1 +
 fs/block_dev.c        |   93 +++++++++++++++++++++++++++++++++++++++---------
 include/linux/fs.h    |    8 ++++-
 5 files changed, 108 insertions(+), 23 deletions(-)

-- 
Jens Axboe

