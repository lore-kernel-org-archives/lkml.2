Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1G0SKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:10:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4914 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1G0SKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:10:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6420"; a="106299763"
Date: Wed, 27 Jul 2011 11:10:00 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCHv3 2/2] ARM: P2V: Remove ARM_PATCH_PHYS_VIRT_16BIT
Message-ID: <20110727181000.GA10758@huya.qualcomm.com>
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

There's still a reference to CONFIG_ARM_PATCH_PHYS_VIRT_16BIT in
arch/arm/include/asm/modules.h that should probably be removed as
well.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
