Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1IDDEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 23:04:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:58556 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1IDDEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 23:04:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45382697"
Date: Sun, 4 Sep 2011 11:04:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jaxboe@fusionio.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: Cleanup clearing of BDI_pending bit in
 bdi_forker_thread()
Message-ID: <20110904030442.GA16361@localhost>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
 <1315004059-9844-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315004059-9844-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 03, 2011 at 06:54:18AM +0800, Jan Kara wrote:
> bdi_forker_thread() clears BDI_pending bit at the end of the main loop.
> However clearing of this bit must not be done in some cases which is handled by
> calling 'continue' from switch statement. That's kind of unusual construct and
> without a good reason so change the function into more intuitive code flow.
> 
> CC: Wu Fengguang <fengguang.wu@intel.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Jan Kara <jack@suse.cz>

It's pure code refactor.

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang
