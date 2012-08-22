Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab2HVSc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:32:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37136 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab2HVSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:32:57 -0400
Date: Wed, 22 Aug 2012 11:32:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v6 02/13] dm: Use bioset's front_pad for
 dm_rq_clone_bio_info
Message-ID: <20120822183252.GC19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-3-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-3-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:03:59AM -0700, Kent Overstreet wrote:
> Previously, dm_rq_clone_bio_info needed to be freed by the bio's
> destructor to avoid a memory leak in the blk_rq_prep_clone() error path.
> This gets rid of a memory allocation and means we can kill
> dm_rq_bio_destructor.
> 
> v6: Fix comment on struct dm_rq_clone_bio_info, per Tejun
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Alasdair Kergon <agk@redhat.com>

 Acked-by: Tejun Heo <tj@kernel.org>

It would be nice if dm people can review these patches tho.

Thanks.

-- 
tejun
