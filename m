Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab0FURan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:30:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23454 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab0FURal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:30:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6020"; a="45073138"
Subject: Re: [PATCH 1/3 v2] msm: Add gpio register address mapping
 information.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1276964944-11063-2-git-send-email-gbean@codeaurora.org>
References: <1276964944-11063-1-git-send-email-gbean@codeaurora.org>
	 <1276964944-11063-2-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 10:30:34 -0700
Message-ID: <1277141434.17092.17.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-19 at 09:29 -0700, Gregory Bean wrote:
> +#if defined(CONFIG_ARCH_MSM7X30)
> +#define GPIO1_REG(off) (MSM_GPIO1_BASE + (off))
> +#define GPIO2_REG(off) (MSM_GPIO2_BASE + 0x400 + (off))
> +#else
> +#define GPIO1_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
> +#define GPIO2_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
> +#endif
> +
> +#if defined(CONFIG_ARCH_QSD8X50)
> +#include "gpio_hw-8x50.h"
> +#elif defined(CONFIG_ARCH_MSM7X30)
> +#include "gpio_hw-7x30.h"
> +#else
> +#include "gpio_hw-7xxx.h"
> +#endif 

I don't think this compiles for 7xxx , since your adding the ifdef block
but not the header.. It would be nice to also include that.

don't respin till the license thing is settled ..

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

