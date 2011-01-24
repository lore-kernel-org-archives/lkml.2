Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1AXUqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:46:45 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6836 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AXUqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:46:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71587000"
Subject: Re: [PATCH v2 07/11] msm: Add MSM 8960 cpu_is check
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1295468747-22796-8-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-8-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 12:46:16 -0800
Message-ID: <1295901976.29639.53.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
> diff --git a/arch/arm/mach-msm/include/mach/cpu.h
> b/arch/arm/mach-msm/include/mach/cpu.h
> index e1ba9db..a9481b0 100644
> --- a/arch/arm/mach-msm/include/mach/cpu.h
> +++ b/arch/arm/mach-msm/include/mach/cpu.h
> @@ -24,6 +24,7 @@
>  #define cpu_is_msm7x30()       0
>  #define cpu_is_qsd8x50()       0
>  #define cpu_is_msm8x60()       0
> +#define cpu_is_msm8960()       0

The naming is just perverted even more here..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

