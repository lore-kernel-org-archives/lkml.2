Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1AYTSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:18:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54539 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1AYTSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:18:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71724841"
From: David Brown <davidb@codeaurora.org>
To: Carl Vanderlip <carlv@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/11] msm: Generalize timer register mappings
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-3-git-send-email-davidb@codeaurora.org>
	<1295979136.16668.4.camel@carlv-linux.qualcomm.com>
X-Hashcash: 1:20:110125:linux-arm-kernel@lists.infradead.org::7Fo9v3WGoDXRLo0/:00000000000000000000000000C69
X-Hashcash: 1:20:110125:linux-arm-msm@vger.kernel.org::zCZRrljiVf68VXpD:000000000000000000000000000000000KAi
X-Hashcash: 1:20:110125:carlv@codeaurora.org::7+8rJbht0AEODELL:000000000000000000000000000000000000000000PEV
X-Hashcash: 1:20:110125:linux-kernel@vger.kernel.org::wlYBw8WnLj0qnWcQ:0000000000000000000000000000000006Gq6
Date: Tue, 25 Jan 2011 11:18:39 -0800
In-Reply-To: <1295979136.16668.4.camel@carlv-linux.qualcomm.com> (Carl
	Vanderlip's message of "Tue, 25 Jan 2011 10:12:16 -0800")
Message-ID: <8yay668eqr4.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25 2011, Carl Vanderlip wrote:

>>  #if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27) \
>>  	|| defined(CONFIG_ARCH_MSM7X25)
>>  static struct map_desc msm_io_desc[] __initdata = {
>>  	MSM_DEVICE(VIC),
>> -	MSM_DEVICE(CSR),
>> +	MSM_CHIP_DEVICE(CSR, MSM7X00),
>>  	MSM_DEVICE(GPT),
>>  	MSM_DEVICE(DMOV),
>>  	MSM_DEVICE(GPIO1),
>
> MSM_DEVICE(GPT) still references MSM_GPT_PHYS, MSM_GPT_SIZE and
> MSM_GPT_BASE on the 7x00a though they are being removed.

Shouldn't be too hard to fix.  I'll look at it later today.  It mostly
points out that I haven't been building against 7x00A.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
