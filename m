Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1CQOBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:01:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:47371 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1CQOBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:01:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: build failure after merge of the final tree (block tree  related)
Date: Thu, 17 Mar 2011 15:01:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>
References: <20110311175830.29a387b2.sfr@canb.auug.org.au> <20110317103131.6c6be7a5.sfr@canb.auug.org.au> <4D81DFA4.7000204@kernel.dk>
In-Reply-To: <4D81DFA4.7000204@kernel.dk>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103171501.32703.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 17. März 2011, um 11:17:08 schrieb Jens Axboe:
> On 2011-03-17 00:31, Stephen Rothwell wrote:
> > Hi Jens,
> > 
> > On Fri, 11 Mar 2011 08:12:38 +0100 Jens Axboe <axboe@kernel.dk> wrote:
> >> On 2011-03-11 07:58, Stephen Rothwell wrote:
> >>> After merging the final tree, today's linux-next build (powerpc
> >>> allyesconfig) failed like this:
> >>> 
> >>> drivers/char/tpm/tpm_tis.c:96: warning: 'is_itpm' defined but not used
> >>> drivers/block/drbd/drbd_bitmap.c: In function '__bm_change_bits_to':
> >>> drivers/block/drbd/drbd_bitmap.c:1287: error: implicit declaration of
> >>> function 'generic___test_and_set_le_bit'
> >>> drivers/block/drbd/drbd_bitmap.c:1289: error: implicit declaration of
> >>> function 'generic___test_and_clear_le_bit'
> >>> drivers/block/drbd/drbd_bitmap.c: In function 'drbd_bm_test_bit':
> >>> drivers/block/drbd/drbd_bitmap.c:1438: error: implicit declaration of
> >>> function 'generic_test_le_bit'
> >>> 
> >>> Caused by commit 4b0715f09655 ("drbd: allow petabyte storage on 64bit
> >>> arch").
> >> 
> >>> I have applied this patch for today (surely there is a better way):
> >> Thanks for not dropping it, I'll let the drbd guys send in a proper fix
> >> and get it committed.
> > 
> > Ping?
> 
> Lars, please send me a fix for this ASAP. It's holding up the block
> merge.

Hi Jens,

Please use Stephen's patch for the merge. It is perfectly valid.

Lars is in the progress of preparing a suggestion for a much
broader cleanup/fix for the little-endian bitops topic.

But that should not delay the the block merge, nor is it necessary
for the drbd updates. He plans to have that ready by tomorrow.

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
