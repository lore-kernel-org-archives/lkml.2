Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab1GYISu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:18:50 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33408 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1GYISp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:18:45 -0400
X-ASG-Debug-ID: 1311581922-01de280c1eec9a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E2D26DF.4050105@fusionio.com>
Date: Mon, 25 Jul 2011 10:18:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block drivers for 3.1
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block drivers for 3.1
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311581922
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.69905
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Small round as well, at least nobody has yelled up with anything big.
Suits me well, as this is vacation time!

Please pull.

  git://git.kernel.dk/linux-block.git for-3.1/drivers

Bastian Blank (1):
      xen/blkback: Add module alias for autoloading

Daniel Stodden (1):
      xen/blkback: Don't let in-flight requests defer pending ones.

Namhyung Kim (3):
      bsg: fix bsg_poll() to return POLLOUT properly
      bsg: remove unnecessary conditional expressions
      bsg: fix address space warning from sparse

Stephen M. Cameron (1):
      cciss: do not attempt to read from a write-only register

 block/bsg.c                         |   18 ++++++++--------
 drivers/block/cciss.h               |    2 +-
 drivers/block/xen-blkback/blkback.c |   37 ++++++++++++++++++----------------
 3 files changed, 30 insertions(+), 27 deletions(-)

-- 
Jens Axboe

