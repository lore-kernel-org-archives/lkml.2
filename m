Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0G2Vny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 17:43:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50261 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0G2Vnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 17:43:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6058"; a="49255830"
Subject: Re: [PATCH v2] cpuidle: extend cpuidle and menu governor to handle
 dynamic states
From: Daniel Walker <dwalker@codeaurora.org>
To: Ai Li <aili@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
        mingo@elte.hu, shemminger@vyatta.com, czoccolo@gmail.com,
        len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <1280430929.22142.51.camel@ali-lnx.qualcomm.com>
References: <1280352443-28044-1-git-send-email-aili@codeaurora.org>
	 <20100728145545.35caf67a.akpm@linux-foundation.org>
	 <1280426600.22142.27.camel@ali-lnx.qualcomm.com>
	 <20100729114306.093cc58c.akpm@linux-foundation.org>
	 <1280430929.22142.51.camel@ali-lnx.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 12:25:27 -0700
Message-ID: <1280431527.27035.9.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 13:15 -0600, Ai Li wrote:
> On Thu, 2010-07-29 at 11:43 -0700, Andrew Morton wrote:
> 
> > I'd be reluctant to merge this code without also having code which uses
> > it.  As it is the change is useless and untestable.
> 
> We have local code in the arch/arm/mach-msm branch that uses the new
> cpuidle code.  We are still developing and testing the MSM patches, and
> hope to upstream them in a few weeks.

We can just re-submit this patch with our msm cpuidle code when that is
finished.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

