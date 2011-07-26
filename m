Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab1GZRki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:40:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6295 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1GZRkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:40:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6419"; a="106030558"
Message-ID: <4E2EFC0E.8020805@codeaurora.org>
Date: Tue, 26 Jul 2011 10:40:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: ARM_PATCH_PHYS_VIRT_16BIT no longer depends
 on MSM
References: <1311614362-9011-1-git-send-email-sboyd@codeaurora.org> <1311614362-9011-2-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1107251624560.12766@xanadu.home> <20110725203114.GF14955@n2100.arm.linux.org.uk>
In-Reply-To: <20110725203114.GF14955@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 01:31 PM, Russell King - ARM Linux wrote:
> On Mon, Jul 25, 2011 at 04:25:26PM -0400, Nicolas Pitre wrote:
>> On Mon, 25 Jul 2011, Stephen Boyd wrote:
>>
>>> MSM no longer requires the 16bit version of dynamic P2V. Drop the
>>> dependency.
>>>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
>>> Cc: David Brown <davidb@codeaurora.org>
>> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> As it's now unused, we can kill the additional code which makes things
> needlessly more complex...

Ok. I'll remove the extra code in v3.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

