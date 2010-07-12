Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0GLV5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:57:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073Ab0GLV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:57:18 -0400
Date: Mon, 12 Jul 2010 14:56:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] writeback: avoid unnecessary calculation of bdi
 dirty thresholds
Message-Id: <20100712145643.a944c495.akpm@linux-foundation.org>
In-Reply-To: <20100711021748.879183413@intel.com>
References: <20100711020656.340075560@intel.com>
	<20100711021748.879183413@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010 10:06:59 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> +void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
>
> ...
>
> +unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
> +			       unsigned long dirty)

It'd be nice to have some documentation for these things.  They're
non-static, non-obvious and are stuffed to the gills with secret magic
numbers.

