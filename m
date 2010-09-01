Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0IAPa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:30:59 -0400
Received: from verein.lst.de ([213.95.11.210]:55225 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab0IAPa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:30:57 -0400
Date: Wed, 1 Sep 2010 17:30:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/5] block: make __blk_rq_prep_clone() copy most command flags
Message-ID: <20100901153027.GA2744@lst.de>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283162296-13650-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 11:58:12AM +0200, Tejun Heo wrote:
> Currently __blk_rq_prep_clone() copies only REQ_WRITE and REQ_DISCARD.
> There's no reason to omit other command flags and REQ_FUA needs to be
> copied to implement FUA support in request-based dm.
> 
> REQ_COMMON_MASK which specifies flags to be copied from bio to request
> already identifies all the command flags.  Define REQ_CLONE_MASK to be
> the same as REQ_COMMON_MASK for clarity and make __blk_rq_prep_clone()
> copy all flags in the mask.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

