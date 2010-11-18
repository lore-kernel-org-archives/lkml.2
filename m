Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab0KRUa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:30:59 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5250 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab0KRUa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:30:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6171"; a="63250032"
Date: Thu, 18 Nov 2010 12:30:53 -0800 (PST)
From: Gregory Bean <gbean@codeaurora.org>
X-X-Sender: gbean@gbean-linux.qualcomm.com
To: Janakiram Sistla <janakiram.sistla@gmail.com>
cc: Gregory Bean <gbean@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] msm: gpio: Add irq support to v2 gpiolib.
In-Reply-To: <AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011181229380.26784@gbean-linux.qualcomm.com>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org> <1290109970-26752-2-git-send-email-gbean@codeaurora.org> <AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Janakiram Sistla wrote:

> Can you let me know how this naming convention gpio-v2??
>
> Do you mean to MSM have v1 and v2 gpio hardware ??? can not we
> have one file under mach-msm as gpio.c??

The MSM8x60 is the first MSM chip to carry the second-generation, or v2,
GPIO hardware block.  This block is not backward compatible with the
v1 block found on older MSMs, so the two drivers cannot be elegantly merged.

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
