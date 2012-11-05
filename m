Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab2KEOoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:44:01 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:58675 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab2KEOn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:43:59 -0500
X-ASG-Debug-ID: 1352126638-0421b554dd14ff0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <5097D090.1000208@fusionio.com>
Date: Mon, 5 Nov 2012 15:43:28 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Subject: Re: [GIT PULL] 4 fixes for drbd
References: <3728568.yDZLErye6B@fat-tyre> <20121101100658.GM27975@kernel.dk> <1433815.PN8uhmSntl@fat-tyre>
X-ASG-Orig-Subj: Re: [GIT PULL] 4 fixes for drbd
In-Reply-To: <1433815.PN8uhmSntl@fat-tyre>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1352126638
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.113356
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-05 15:35, Philipp Reisner wrote:
>>
>> Can you rebase this against for-3.8/drivers? Thanks.
> 
> Hi Jens,
> 
> One of these changes fixes a regression that was introduced in the last
> merge window. Please consider to pull this single commit.
> (I will rebase the other 3 commit on for-3.8/drivers)
> 
> 
> The following changes since commit a13c29ddf73d3be4fbb2b1bbced64014986cd87a:
>   Jens Axboe (1):
>         Merge branch 'for-jens' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block into for-3.7/drivers
> 
> are available in the git repository at:
> 
>   git://git.drbd.org/linux-drbd.git for-jens
> 
> Lars Ellenberg (1):
>       drbd: fix regression: potential NULL pointer dereference
> 
>  drivers/block/drbd/drbd_int.h  |    5 +++++
>  drivers/block/drbd/drbd_main.c |    8 ++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)

Sure, of course I'll take a regression fix. But the fix does not apply
to current tree:

axboe@nelson:/src/linux-block $ patch -p1 --dry-run < ~/1.txt 
patching file drivers/block/drbd/drbd_int.h
Hunk #1 FAILED at 2545.
1 out of 1 hunk FAILED -- saving rejects to file drivers/block/drbd/drbd_int.h.rej
patching file drivers/block/drbd/drbd_main.c
Hunk #1 FAILED at 4232.
1 out of 1 hunk FAILED -- saving rejects to file drivers/block/drbd/drbd_main

Regression fixes for the current tree should be based on the current
tree, looks like you used an outdated for-3.7/drivers branch and this
fix depends on other fixes.

-- 
Jens Axboe

