Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0IAXsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:48:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17597 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab0IAXsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:48:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6092"; a="52943858"
Subject: Re: [PATCH 1/2 v2] msm: Install the Google-Android gpio driver.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1283384380-24997-1-git-send-email-gbean@codeaurora.org>
References: <1283384380-24997-1-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 16:48:06 -0700
Message-ID: <1283384886.21049.28.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 16:39 -0700, Gregory Bean wrote:
> +void msm_gpio_enter_sleep(int from_idle)
> +{
> +       int i;
> +       struct tramp_gpio_smem *smem_gpio;
> +
> +       smem_gpio = smem_alloc(SMEM_GPIO_INT, sizeof(*smem_gpio));
> +
> +       if (smem_gpio) {
> +               for (i = 0; i < ARRAY_SIZE(smem_gpio->enabled); i++) {
> +                       smem_gpio->enabled[i] = 0;
> +                       smem_gpio->detection[i] = 0;
> +                       smem_gpio->polarity[i] = 0;
> +               }
> +       }
> + 

Can you not drop these for some reason ?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

