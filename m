Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1JLWSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:18:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51897 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1JLWSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:18:32 -0400
Date: Wed, 12 Oct 2011 15:18:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, christophe@saout.de,
        dm-devel@redhat.com, msnitzer@redhat.com
Subject: Re: [PATCH 2/2] blk-flush: fix invalid BUG_ON in blk_insert_flush
Message-ID: <20111012221828.GI6281@google.com>
References: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
 <1318454562-25291-3-git-send-email-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318454562-25291-3-git-send-email-jmoyer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 05:22:42PM -0400, Jeff Moyer wrote:
> A user reported a regression due to commit
> 4853abaae7e4a2af938115ce9071ef8684fb7af4 (block: fix flush
> machinery for stacking drivers with differring flush flags).
> Part of the problem is that blk_insert_flush required a
> single bio be attached to the request.  In reality, having
> no attached bio is also a valid case, as can be observed with
> an empty flush.
> 
> [1] http://www.redhat.com/archives/dm-devel/2011-September/msg00154.html
> 
> Reported-by: Christophe Saout <christophe@saout.de>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Duplicate SOB's and missing space after '/*' in the comment.  Other
than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
