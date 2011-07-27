Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1G0Oxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:53:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55656 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1G0Oxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:53:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6419"; a="106039809"
Date: Wed, 27 Jul 2011 07:53:30 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCHv3 2/2] ARM: P2V: Remove ARM_PATCH_PHYS_VIRT_16BIT
Message-ID: <20110727145330.GA32004@huya.qualcomm.com>
References: <1311733255-25207-1-git-send-email-sboyd@codeaurora.org>
 <1311733255-25207-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311733255-25207-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 07:20:55PM -0700, Stephen Boyd wrote:
> From: Nicolas Pitre <nicolas.pitre@linaro.org>
> 
> Now that MSM targets no longer need the 16-bit offsets for P2V, this
> code can be removed.
> 
> Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

I've tested this on MSM, but without an actual offset.  It'd be good
to test this on a target with an actual adjustment being used, to make
sure nothing breaks.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
