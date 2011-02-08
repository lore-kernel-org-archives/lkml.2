Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1BHIGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 03:06:17 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:55969 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1BHIGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 03:06:16 -0500
X-ASG-Debug-ID: 1297152375-03d6a50f0d30e30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D50F9B4.9040309@fusionio.com>
Date: Tue, 8 Feb 2011 09:07:16 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 2.6.38-rc3
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block fixes for 2.6.38-rc3
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1297152375
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.54716
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have been sitting on these for some weeks, time to
push it out. A few important bug fixes there, and a fix
for a CFQ regression that causes a slowdown on fast
devices.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Sergey Senozhatsky (1):
      loop: queue_lock NULL pointer derefence in blk_throtl_exit

Stephen M. Cameron (1):
      cciss: make cciss_revalidate not loop through CISS_MAX_LUNS volumes unnecessarily.

Tao Ma (1):
      blktrace: Don't output messages if NOTIFY isn't set.

Tracey Dent (2):
      drivers/block/Makefile: replace the use of <module>-objs with <module>-y
      drivers/block/aoe/Makefile: replace the use of <module>-objs with <module>-y

Vivek Goyal (2):
      cfq: rename a function to give it more appropriate name
      blkio-throttle: Avoid calling blkiocg_lookup_group() for root group

 block/blk-throttle.c       |   10 +++++++++-
 block/cfq-iosched.c        |    6 +++---
 drivers/block/Makefile     |    2 +-
 drivers/block/aoe/Makefile |    2 +-
 drivers/block/cciss.c      |    2 +-
 drivers/block/loop.c       |    3 +++
 kernel/trace/blktrace.c    |    7 +++++++
 7 files changed, 25 insertions(+), 7 deletions(-)

-- 
Jens Axboe

