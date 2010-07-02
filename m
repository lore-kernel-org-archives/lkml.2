Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab0GBHxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:53:38 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37153 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab0GBHxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:53:37 -0400
Message-ID: <4C2D9AFF.7010401@kernel.dk>
Date: Fri, 02 Jul 2010 09:53:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de,
       hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of 
 q->prepare_flush_fn()
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20100702075248.GB21266@infradead.org>
In-Reply-To: <20100702075248.GB21266@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-02 09:52, Christoph Hellwig wrote:
> On Fri, Jul 02, 2010 at 04:33:23PM +0900, FUJITA Tomonori wrote:
>> We could kill q->prepare_flush_fn(). Except for ide, all the users
>> just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
>> do like SCSI.
> 
> Yes, and I think you should go all the way to kill it instead of
> keeping both APIs around.  Otherwise the patchset looks good to me.

Fully agree, lets get rid of ->prepare_flush_fn().


-- 
Jens Axboe

