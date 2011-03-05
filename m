Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab1CEIne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:43:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13928 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1CEInd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:43:33 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6275"; a="77978842"
Message-ID: <4D71F7A0.5010101@codeaurora.org>
Date: Sat, 05 Mar 2011 14:13:12 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        dwalker@fifo99.com, bryanh@codeaurora.org, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] msm: Add support for Scorpion and ScorpionMP PMU
References: <1299276583-12542-1-git-send-email-sheetals@codeaurora.org>
In-Reply-To: <1299276583-12542-1-git-send-email-sheetals@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sheetal,

> +static int __init scorpion_pmu_init(void)
> +{
> +	platform_device_register(&pmu_device);

platform_device_register can fail. Better do it like

"return platform_device_register(&pmu_device);

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
