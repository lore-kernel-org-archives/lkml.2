Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1CEVTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 16:19:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33937 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1CEVTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 16:19:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6276"; a="78041426"
Message-ID: <abd1b409d545d4a3c24e4f0dedf56c6f.squirrel@www.codeaurora.org>
In-Reply-To: <4D71F7A0.5010101@codeaurora.org>
References: <1299276583-12542-1-git-send-email-sheetals@codeaurora.org>
    <4D71F7A0.5010101@codeaurora.org>
Date: Sat, 5 Mar 2011 13:18:50 -0800 (PST)
Subject: Re: [PATCH 1/3] msm: Add support for Scorpion and ScorpionMP PMU
From: "Sheetal Sahasrabudhe" <sheetals@codeaurora.org>
To: "Trilok Soni" <tsoni@codeaurora.org>
Cc: "Sheetal Sahasrabudhe" <sheetals@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        dwalker@fifo99.com, bryanh@codeaurora.org, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trilok,

>> +static int __init scorpion_pmu_init(void)
>> +{
>> +	platform_device_register(&pmu_device);
>
> platform_device_register can fail. Better do it like
>
> "return platform_device_register(&pmu_device);

Good catch, I will update it.

Thanks,
Sheetal

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


