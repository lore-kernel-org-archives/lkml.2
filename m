Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab1GDPxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:53:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:28944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902Ab1GDPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:53:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,473,1304319600"; 
   d="scan'208";a="26131249"
Date: Mon, 4 Jul 2011 17:54:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jin Park <jinyoungp@nvidia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: aat2870: Add AAT2870 mfd driver
Message-ID: <20110704155406.GO3021@sortiz-mobl>
References: <1309356412-23881-1-git-send-email-jinyoungp@nvidia.com>
 <1309356412-23881-2-git-send-email-jinyoungp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309356412-23881-2-git-send-email-jinyoungp@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,

On Wed, Jun 29, 2011 at 11:06:50PM +0900, Jin Park wrote:
> Add mfd core driver for AnalogicTech AAT2870.
> The AAT2870 is communication through I2C and contains backlight and
> regulator components.
At first glance, the patch looks good now. I'll wait for your regulator fixes
according to Mark's comments and apply the serie.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
