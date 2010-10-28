Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0J1Ncn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:32:43 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:44977 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab0J1Nck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:32:40 -0400
X-ASG-Debug-ID: 1288272758-085b8ec10001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC97B74.3000808@fusionio.com>
Date: Thu, 28 Oct 2010 07:32:36 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] fix for loop warning
References: <4CC7A809.1070607@fusionio.com> <AANLkTink4hKJk_-Pb-rPxQcBH5WcBKqf=9ybZ7thL1O6@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] fix for loop warning
In-Reply-To: <AANLkTink4hKJk_-Pb-rPxQcBH5WcBKqf=9ybZ7thL1O6@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1288272758
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4251 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44984
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-27 19:47, Linus Torvalds wrote:
> On Tue, Oct 26, 2010 at 9:18 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>>  git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> "Already up-to-date."
> 
> Forgot to push?

Must have... The branch has now been updated with a few other pending
patches. All pretty trivial and straight forward changes.

Please pull (again :-).


  git://git.kernel.dk/linux-2.6-block.git for-linus

Andrew Morton (1):
      drivers/block/aoe/aoeblk.c: ratelimit a warning printk

Geert Uytterhoeven (1):
      drivers/block/z2ram.c: correct printing of sector_t

Mike Miller (1):
      cciss: remove overlapping PCI IDs

Milan Broz (1):
      loop: Properly clear sysfs in autoclear mode

Nicolas Kaiser (1):
      drivers/block/drbd/drbd_main.c: fix error path

Tejun Heo (1):
      aoe: don't use flush_scheduled_work()

Vasiliy Kulikov (1):
      block: cciss: fix information leak to userland

 drivers/block/aoe/aoeblk.c     |    4 +++-
 drivers/block/aoe/aoedev.c     |    4 +---
 drivers/block/cciss.c          |   37 +------------------------------------
 drivers/block/drbd/drbd_main.c |    2 +-
 drivers/block/loop.c           |    2 +-
 drivers/block/z2ram.c          |    6 ++++--
 6 files changed, 11 insertions(+), 44 deletions(-)


-- 
Jens Axboe

