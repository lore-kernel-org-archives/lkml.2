Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab0FNKIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:08:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:40808 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0FNKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:08:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the drbd tree with the block trees
Date: Mon, 14 Jun 2010 12:08:33 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, drbd-dev@lists.linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100610135203.4649453a.sfr@canb.auug.org.au> <201006141143.42783.philipp.reisner@linbit.com> <4C15FA1C.1080901@kernel.dk>
In-Reply-To: <4C15FA1C.1080901@kernel.dk>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141208.37222.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Juni 2010, um 11:45:00 schrieb Jens Axboe:
> On 2010-06-14 11:43, Philipp Reisner wrote:
> > Am Montag, 14. Juni 2010, um 11:08:28 schrieb Jens Axboe:
> >> On 2010-06-14 03:26, Stephen Rothwell wrote:
> >>> Hi Jens, Philipp,
> >>> 
> >>> On Thu, 10 Jun 2010 08:01:35 +0200 Jens Axboe <axboe@kernel.dk> wrote:
> >>>> I'm starting to think that it would be a little easier if you did not
> >>>> pull the drbd tree, I really should be pulling that into my -next
> >>>> branch instead.
> >>> 
> >>> Given that the drbd tree has not been updated to match the increasingly
> >>> different block tree, I have dropped it for today.
> >>> 
> >>> There a a few possibilities here:
> >>> 	- I just drop the drbd tree completely and it only gets merged
> >>> 
> >>> into the block tree.
> >>> 
> >>> 	- if the drbd tree doesn't actually depend on any of the features
> >>> 
> >>> in the block tree then it could be rebased onto Linus tree (and I would
> >>> cope with any merge fixups - as I do with many other trees).
> >>> 
> >>> 	- if it does depend on things in the block tree, those particular
> >>> 
> >>> features in the block tree could be put in a separate branch that is
> >>> never rebased and then that branch could be merged into both the block
> >>> and drbd trees (this has been done before e.g. stuff in the vfs tree.
> >>> 
> >>> 	- the drbd tree could be rebased on tom of the current block tree
> >>> 
> >>> (but then it must be kept up to date if the block tree is rebased).
> >> 
> >> The thing with the dependencies is that sometimes they are true,
> >> sometimes they are not. What I suggested to the drbd team is that they
> >> always just base off Linus and then ask me to pull their changes, then I
> >> will resolve any potential conflicts when that happens. The consequence
> >> would be that you stop pulling the drbd tree separately.
> > 
> > Ok, from now on I will use Linus most recent -rc as base and put DRBD
> > patches on top of that. -- I will do this today (CEST timezone).
> 
> You want to continue to use for-2.6.xx for your next version updates, as
> that has a larger risk of containing things you need to adapt to. But
> for current version patches, Linus' branch is fine.

Ok, so I will have a for-jens and a for-jens-next branch. Where for-jens
is based on Linus' branch, and for-jens-next is based on your for-2.6.xx.

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
