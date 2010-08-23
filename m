Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab0HWLXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:23:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:41753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab0HWLXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:23:15 -0400
Message-Id: <89k77n$oo9clo@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,257,1280732400"; 
   d="scan'208";a="830780088"
Date: Mon, 23 Aug 2010 12:23:11 +0100
To: Meelis Roos <mroos@linux.ee>, Eric Anholt <eric@anholt.net>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] fix i915 compile in 2.6.36-rc2
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
References: <alpine.SOC.1.00.1008231332460.14284@math.ut.ee>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <alpine.SOC.1.00.1008231332460.14284@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 13:38:27 +0300 (EEST), Meelis Roos <mroos@linux.ee> wrote:
> Commit 6ef3d4278034982c13df87c4a51e0445f762d316 introduces seq_file 
> usage in intel_overlay.c but does not include the header and now 
> compilation fails on i386. Fix it by including the necessary header.
> 
> Signed-off-by: Meelis Roos <mroos@linux.ee>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>

I have a pending patch to compile out this code when DEBUG_FS is not used
which is the root cause of the compilation failure. That is a little more
invasive than this simple patch...

-- 
Chris Wilson, Intel Open Source Technology Centre
