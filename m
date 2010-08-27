Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0H0UaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:30:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2925 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0H0UaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:30:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6087"; a="52365812"
Subject: Re: [PATCH 1/5 v3] msm: add gpiomux api for gpio multiplex &
 configuration.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1282925975-26367-1-git-send-email-gbean@codeaurora.org>
References: <1282925975-26367-1-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 13:30:08 -0700
Message-ID: <1282941008.5075.26.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 09:19 -0700, Gregory Bean wrote:
> +obj-y += gpiomux.o
> +obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-7x00.o
> +obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-7x00.o
> +obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o 

Is this right? I got a built failure before 7x00 isn't in the list..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


