Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab0H0R5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:57:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0H0R5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:57:31 -0400
Date: Fri, 27 Aug 2010 13:57:11 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] block: make __blk_rq_prep_clone() copy most command
 flags
Message-ID: <20100827175711.GB23680@redhat.com>
References: <1282929060-23663-1-git-send-email-tj@kernel.org>
 <1282929060-23663-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282929060-23663-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27 2010 at  1:10pm -0400,
Tejun Heo <tj@kernel.org> wrote:

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

Looks great.

Acked-by: Mike Snitzer <snitzer@redhat.com>
