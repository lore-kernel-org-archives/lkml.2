Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1BNGKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 01:10:55 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49785 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1BNGKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 01:10:53 -0500
Date: Mon, 14 Feb 2011 11:40:47 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 06/26] x86-64, NUMA: Move *_numa_init() invocations into
 initmem_init()
Message-ID: <20110214061047.GA7065@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297530663-26234-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 12, 2011 at 06:10:43PM +0100, Tejun Heo wrote:
> There's no reason for these to live in setup_arch().  Move them inside
> initmem_init().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Shaohui Zheng <shaohui.zheng@intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/include/asm/page_types.h |    2 +-
>  arch/x86/kernel/setup.c           |   16 +---------------
>  arch/x86/mm/init_64.c             |    2 +-
>  arch/x86/mm/numa_64.c             |   16 +++++++++++++++-
>  4 files changed, 18 insertions(+), 18 deletions(-)
>

This will break 32bits.
 
-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
