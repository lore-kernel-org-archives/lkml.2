Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab2IGBhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 21:37:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37910 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab2IGBhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 21:37:17 -0400
Message-ID: <50494FC6.3050502@kernel.dk>
Date: Thu, 06 Sep 2012 19:37:10 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v10 0/8] Block cleanups
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <20120906234805.GD9426@google.com>
In-Reply-To: <20120906234805.GD9426@google.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-06 17:48, Tejun Heo wrote:
> Hello, guys.
> 
> (cc'ing Jens, Alasdair and Neil)
> 
> On Thu, Sep 06, 2012 at 03:34:54PM -0700, Kent Overstreet wrote:
>> Screwed up the bio_reset() patch in the last patch series when I went to edit
>> the description, fixed that here.
>>
>> Only other change is the dm patch - made the front_pad conditional on
>> DM_TYPE_BIO_BASED.
>>
>> Kent Overstreet (8):
>>   block: Generalized bio pool freeing
>>   block: Ues bi_pool for bio_integrity_alloc()
>>   dm: Use bioset's front_pad for dm_rq_clone_bio_info
>>   block: Add bio_reset()
>>   pktcdvd: Switch to bio_kmalloc()
>>   block: Kill bi_destructor
>>   block: Consolidate bio_alloc_bioset(), bio_kmalloc()
>>   block: Add bio_clone_bioset(), bio_clone_kmalloc()
> 
> This series looks good to me now.  If someone can ack the dm patch, I
> think it's good to go.  Jens, what do you think?

Looks OK to me too. I'll run a quick perf test on this tomorrow, and get
it queued up for 3.7 if it looks fine.

Kent, are to resend 3+5 to me?

-- 
Jens Axboe

