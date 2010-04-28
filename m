Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0D1SRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:17:46 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33197 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab0D1SRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:17:45 -0400
Date: Wed, 28 Apr 2010 20:17:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 0/4] blkdev: blkdev_issue_fn cleanups v3
Message-ID: <20100428181743.GW27497@kernel.dk>
References: <20100426172651.GT27497@kernel.dk> <1272462909-12942-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272462909-12942-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28 2010, Dmitry Monakhov wrote:
> - Convert all blkdev_issue_xxx function to common set of flags
> - move common helper functions to block/blk-lib.c
> - Add generic zeroout helper
> 
> Tested configuration: ext4 w -odiscard over raw_bdisk and dm-linear
> changes from V2
> Fix flag names, and rearange patches according to Christoph's comments.

Thanks, I've applied the series.

-- 
Jens Axboe

