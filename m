Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1LRVFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 16:05:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:34005 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1LRVFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 16:05:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="88822990"
Date: Sun, 18 Dec 2011 22:10:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: jhbird.choi@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, jhbird.choi@gmail.com
Subject: Re: [PATCH] mfd: max8998: Use standard device wakeup for handling
 wakeup device
Message-ID: <20111218211019.GT11800@sortiz-mobl>
References: <1322554671-16312-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322554671-16312-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwan,

On Tue, Nov 29, 2011 at 05:17:51PM +0900, jhbird.choi@samsung.com wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Use device_init_wakeup & device_may_wakeup to init wakeup
I applied this one, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
