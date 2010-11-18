Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457Ab0KRU7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:59:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3603 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760407Ab0KRU7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:59:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6171"; a="63252469"
Date: Thu, 18 Nov 2010 12:59:07 -0800 (PST)
From: Gregory Bean <gbean@codeaurora.org>
X-X-Sender: gbean@gbean-linux.qualcomm.com
To: Janakiram Sistla <janakiram.sistla@gmail.com>
cc: Gregory Bean <gbean@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] msm: gpio: Add irq support to v2 gpiolib.
In-Reply-To: <AANLkTi=p02P=-JQ9+FynFyM1yxrAh3utKTD2uzqhnLxK@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011181256470.29924@gbean-linux.qualcomm.com>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org> <1290109970-26752-2-git-send-email-gbean@codeaurora.org> <AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com> <alpine.DEB.2.00.1011181229380.26784@gbean-linux.qualcomm.com>
 <AANLkTi=p02P=-JQ9+FynFyM1yxrAh3utKTD2uzqhnLxK@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="755636368-116745310-1290113953=:29924"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--755636368-116745310-1290113953=:29924
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

>>> Do you mean to MSM have v1 and v2 gpio hardware ??? can not we
>>> have one file under mach-msm as gpio.c??
>>
>> The MSM8x60 is the first MSM chip to carry the second-generation, or v2,
>> GPIO hardware block.  This block is not backward compatible with the
>> v1 block found on older MSMs, so the two drivers cannot be elegantly merged.
>
> so this is applicable to 8x60 and coming chip sets.I basically have a
> question,How come a a new person under stand the  chipset uses gpio-v1
> or gpiov2??

Targets with the v2 block define CONFIG_MSM_V2_TLMM.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
--755636368-116745310-1290113953=:29924--
