Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab1EYNKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:10:09 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:59891 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab1EYNKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:10:08 -0400
X-ASG-Debug-ID: 1306329007-03d6a50f5325f40001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDCFFAC.5010901@fusionio.com>
Date: Wed, 25 May 2011 15:10:04 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Splice fix for 2.6.40
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Splice fix for 2.6.40
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306329007
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A code consolidation fix for splice, unifying the if-pipe-waiters,
wake-up logic.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.40/splice

Namhyung Kim (1):
      splice: add wakeup_pipe_readers()

 fs/splice.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

-- 
Jens Axboe

