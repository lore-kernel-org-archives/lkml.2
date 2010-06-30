Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0F3KKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:10:04 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:56349 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754755Ab0F3KKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:10:00 -0400
Date: Wed, 30 Jun 2010 20:09:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 51/52] fs: per-zone dentry and inode LRU
Message-ID: <20100630100937.GJ24712@dastard>
References: <20100624030212.676457061@suse.de>
 <20100624030733.869946613@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030733.869946613@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:03:03PM +1000, npiggin@suse.de wrote:
> Per-zone LRUs and shrinkers for dentry and inode caches.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

This destroys any notion we have of global LRU-ness of inode and
dentry caches, doesn't it? Can you outline in more detail what sort
of reclaim pattern this results in. e.g. is a workload running on
a single node now effectively limited to a dentry/icache size within
the local node because of local node slab allocation and per-zone
reclaim?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
