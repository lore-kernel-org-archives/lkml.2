Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0HaQqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:46:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2925 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0HaQqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:46:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6091"; a="52757081"
Subject: Re: [PATCH 1/2] msm: Install the Google-Android gpio driver.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
References: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 09:46:30 -0700
Message-ID: <1283273190.11790.1.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 17:18 -0700, Gregory Bean wrote:
> struct msm_gpio_chip msm_gpio_chips[] = {
> +       {
> +               .regs = {
> +                       .out =         GPIO_OUT_0,
> +                       .in =          GPIO_IN_0,
> +                       .int_status =  GPIO_INT_STATUS_0,
> +                       .int_clear =   GPIO_INT_CLEAR_0,
> +                       .int_en =      GPIO_INT_EN_0,
> +                       .int_edge =    GPIO_INT_EDGE_0,
> +                       .int_pos =     GPIO_INT_POS_0,
> +                       .oe =          GPIO_OE_0,
> +               }, 

Macro please.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

