Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1HVOjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:39:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:22507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab1HVOjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:39:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="40974051"
Date: Mon, 22 Aug 2011 16:41:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 0/2] MFD: MAX8997 Driver Update
Message-ID: <20110822144106.GU4607@sortiz-mobl>
References: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 18, 2011 at 04:37:34PM +0900, MyungJoo Ham wrote:
> This patchset does:
> 
> 1. Bugfix on IRQ handling
> 	The current version does not initialize IRQ handling part properly.
> 	This patch adds max8997-irq init and allows to handle interrupts
> 	correctly.
> 
> 2. Suspend-to-RAM Wakeup Source
> 	The current version is missing wakeup-source feature.
> 
> Changes from v1:
> - Removed a patch from the patchset.
> (v2 is basically a "resubmit" without the undesired part)
> 
> MyungJoo Ham (2):
>   MFD: MAX8997: IRQ Handling Bugfix
>   MFD: MAX8997: Support Wake-up from Suspend
Thanks, both patches (I took patch #2 second version) applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
