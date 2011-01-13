Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1AMNxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:53:51 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:49288 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab1AMNxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:53:50 -0500
X-ASG-Debug-ID: 1294926829-17892b610001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D2F03F2.4000707@fusionio.com>
Date: Thu, 13 Jan 2011 14:53:54 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block driver updates for 2.6.38
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block driver updates for 2.6.38
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294926829
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.3823 1.0000 -0.0481
X-Barracuda-Spam-Score: -0.05
X-Barracuda-Spam-Status: No, SCORE=-0.05 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.52262
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Block driver updates for 2.6.38. Not a lot.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.38/drivers

Jens Axboe (1):
      cciss: reinstate proper FIFO order of command queue list

Pekka Enberg (1):
      floppy: replace NO_GEOM macro with a function

 drivers/block/cciss.c     |   23 +++++++++++------------
 drivers/block/cciss.h     |    4 ++--
 drivers/block/cciss_cmd.h |    2 +-
 drivers/block/floppy.c    |   15 ++++++++++-----
 4 files changed, 24 insertions(+), 20 deletions(-)

-- 
Jens Axboe

