Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1HPUEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:04:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:64909 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1HPUEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:04:05 -0400
Message-Id: <f80fcd$183avu@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,235,1312182000"; 
   d="scan'208";a="42052606"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] Drivers: i915: Fix all space related issues.
To: Akshay Joshi <me@akshayjoshi.com>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Akshay Joshi <me@akshayjoshi.com>
In-Reply-To: <1313523255-13629-1-git-send-email-me@akshayjoshi.com>
References: <1313523255-13629-1-git-send-email-me@akshayjoshi.com>
Date: Tue, 16 Aug 2011 21:03:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011 15:34:10 -0400, Akshay Joshi <me@akshayjoshi.com> wrote:
> Various issues involved with the space character were generating
> warnings in the checkpatch.pl file. This patch removes most of those
> warnings.
> @@ -622,7 +622,7 @@
>  
>  #define ILK_DISPLAY_CHICKEN1	0x42000
>  #define   ILK_FBCQ_DIS		(1<<22)
> -#define   ILK_PABSTRETCH_DIS 	(1<<21)
> +#define	  ILK_PABSTRETCH_DIS	(1<<21)

The others are space indented so the replacement tab looks wrong.

And that was the oddity I could spot in the patch.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
