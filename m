Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1JaIdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 04:33:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:28247 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab1JaIdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 04:33:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,429,1315206000"; 
   d="scan'208";a="68730803"
Date: Mon, 31 Oct 2011 16:33:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux 3.1 issue: bdi dirty threshold goes mad
Message-ID: <20111031083313.GA12754@localhost>
References: <20111027225822.GA31990@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027225822.GA31990@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 06:58:22AM +0800, Wu Fengguang wrote:
> Hi,
> 
> FYI, I find bdi dirty threshold madness in the newly released v3.1
> according to the gray lines in the attached graphs, which are for
> these test cases:
> 
> 3G-UKEY-HDD/ext4-1dd-4k-8p-2948M-20:10-3.1.0-vanilla+
> 3G-UKEY-HDD/xfs-10dd-4k-8p-2948M-20:10-3.1.0-vanilla+
> 3G-UKEY-HDD/xfs-1dd-4k-8p-2948M-20:10-3.1.0-vanilla+
> 
> It's basically doing concurrent dd's to a USB key and a hard disk.
> 
> Don't know what's going wrong, but at least should be bisectable..

It seems to depend on kernel builds: the problem disappears in the
newly compiled kernels. This makes it pretty hard to catch the root
cause...

Thanks,
Fengguang
