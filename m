Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1G0SXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:23:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62868 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1G0SXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:23:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6420"; a="106094419"
Message-ID: <4E3057A3.80509@codeaurora.org>
Date: Wed, 27 Jul 2011 11:23:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 2/2] ARM: P2V: Remove ARM_PATCH_PHYS_VIRT_16BIT
References: <1311733255-25207-1-git-send-email-sboyd@codeaurora.org> <1311733255-25207-2-git-send-email-sboyd@codeaurora.org> <20110727181000.GA10758@huya.qualcomm.com>
In-Reply-To: <20110727181000.GA10758@huya.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 11:10 AM, David Brown wrote:
> On Tue, Jul 26, 2011 at 07:20:55PM -0700, Stephen Boyd wrote:
>> From: Nicolas Pitre <nicolas.pitre@linaro.org>
>>
>> Now that MSM targets no longer need the 16-bit offsets for P2V, this
>> code can be removed.
> There's still a reference to CONFIG_ARM_PATCH_PHYS_VIRT_16BIT in
> arch/arm/include/asm/modules.h that should probably be removed as
> well.
>
>

Ah ok. I'll fix that up too. V3 shortly.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

