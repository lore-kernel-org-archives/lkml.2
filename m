Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1CQKRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:17:12 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45906 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1CQKRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:17:09 -0400
Message-ID: <4D81DFA4.7000204@kernel.dk>
Date: Thu, 17 Mar 2011 11:17:08 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: Re: linux-next: build failure after merge of the final tree (block
  tree  related)
References: <20110311175830.29a387b2.sfr@canb.auug.org.au>	<4D79CB66.2020302@kernel.dk> <20110317103131.6c6be7a5.sfr@canb.auug.org.au>
In-Reply-To: <20110317103131.6c6be7a5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-17 00:31, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Fri, 11 Mar 2011 08:12:38 +0100 Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2011-03-11 07:58, Stephen Rothwell wrote:
>>>
>>> After merging the final tree, today's linux-next build (powerpc
>>> allyesconfig) failed like this:
>>>
>>> drivers/char/tpm/tpm_tis.c:96: warning: 'is_itpm' defined but not used
>>> drivers/block/drbd/drbd_bitmap.c: In function '__bm_change_bits_to':
>>> drivers/block/drbd/drbd_bitmap.c:1287: error: implicit declaration of function 'generic___test_and_set_le_bit'
>>> drivers/block/drbd/drbd_bitmap.c:1289: error: implicit declaration of function 'generic___test_and_clear_le_bit'
>>> drivers/block/drbd/drbd_bitmap.c: In function 'drbd_bm_test_bit':
>>> drivers/block/drbd/drbd_bitmap.c:1438: error: implicit declaration of function 'generic_test_le_bit'
>>>
>>> Caused by commit 4b0715f09655 ("drbd: allow petabyte storage on 64bit
>>> arch").
>>>
>>> I have applied this patch for today (surely there is a better way):
>>
>> Thanks for not dropping it, I'll let the drbd guys send in a proper fix
>> and get it committed.
> 
> Ping?

Lars, please send me a fix for this ASAP. It's holding up the block
merge.

-- 
Jens Axboe

