Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1CBFoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:44:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:7202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1CBFoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:44:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,251,1297065600"; 
   d="scan'208";a="892860457"
Date: Wed, 2 Mar 2011 13:58:02 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Youquan Song <youquan.song@linux.intel.com>, davej@redhat.com,
        arjan@linux.intel.com, venki@google.com, youquan.song@intel.com,
        cpufreq-list@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Fix ondemand governor powersave_bias
	execution time misuse
Message-ID: <20110302185801.GA31349@linux-youquan.bj.intel.com>
References: <20101105151951.GA10743@linux-youquan.bj.intel.com> <20110301170740.2b4a8288.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301170740.2b4a8288.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Where are we with this patch?  Still needed in curent mainline?
Do need it by current mainline. Without the patch, the ondemand
power_bias feature is broken and does not work at all.
Please take it.

Thanks
-Youquan
 
