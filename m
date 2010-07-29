Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab0G2TPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:15:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22967 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab0G2TPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:15:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6058"; a="49102689"
Subject: Re: [PATCH v2] cpuidle: extend cpuidle and menu governor to handle
 dynamic states
From: Ai Li <aili@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dwalker@codeaurora.org, arjan@linux.intel.com, mingo@elte.hu,
        shemminger@vyatta.com, czoccolo@gmail.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
In-Reply-To: <20100729114306.093cc58c.akpm@linux-foundation.org>
References: <1280352443-28044-1-git-send-email-aili@codeaurora.org>
	 <20100728145545.35caf67a.akpm@linux-foundation.org>
	 <1280426600.22142.27.camel@ali-lnx.qualcomm.com>
	 <20100729114306.093cc58c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 29 Jul 2010 13:15:29 -0600
Message-Id: <1280430929.22142.51.camel@ali-lnx.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 11:43 -0700, Andrew Morton wrote:

> I'd be reluctant to merge this code without also having code which uses
> it.  As it is the change is useless and untestable.

We have local code in the arch/arm/mach-msm branch that uses the new
cpuidle code.  We are still developing and testing the MSM patches, and
hope to upstream them in a few weeks.

~Ai
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

