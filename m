Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0KSTAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:00:36 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab0KSTAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:00:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6172"; a="63392724"
Date: Fri, 19 Nov 2010 11:00:32 -0800 (PST)
From: Gregory Bean <gbean@codeaurora.org>
X-X-Sender: gbean@gbean-linux.qualcomm.com
To: Janakiram Sistla <janakiram.sistla@gmail.com>
cc: Gregory Bean <gbean@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] msm: gpio: Add irq support to v2 gpiolib.
In-Reply-To: <AANLkTiknSudbo_j+nqBqmds49CWyqXf0jpvz+DTYH-zg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011191053040.10560@gbean-linux.qualcomm.com>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org> <1290109970-26752-2-git-send-email-gbean@codeaurora.org> <AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com> <alpine.DEB.2.00.1011181229380.26784@gbean-linux.qualcomm.com>
 <AANLkTi=p02P=-JQ9+FynFyM1yxrAh3utKTD2uzqhnLxK@mail.gmail.com> <alpine.DEB.2.00.1011181256470.29924@gbean-linux.qualcomm.com> <AANLkTiknYmWOmiFXGp6h2dT==aMuGs3BtXi82b6Vdq5i@mail.gmail.com> <alpine.DEB.2.00.1011191035210.10052@gbean-linux.qualcomm.com>
 <AANLkTiknSudbo_j+nqBqmds49CWyqXf0jpvz+DTYH-zg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="755636368-2025357044-1290193234=:10560"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--755636368-2025357044-1290193234=:10560
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

>>>> Targets with the v2 block define CONFIG_MSM_V2_TLMM.
>>>
>>> So in that case we can name  it as gpio-tlmm.c ??
>>
>> No, not and have things be any clearer.
>>
>> All MSM chips have a TLMM block.  The older chips have
>> version 1 (v1) of the TLMM block.  The newer chips have v2.
>
> I think that we should differentiate the new gpio infrastructure with
> appropriate naming that makes the diff between v1 and v2

What do you suggest?  All MSM SoCs have a TLMM block.  The block itself
carries no model or revision name, and is not tied specifically to any
particular SoC, except for the fact that the second generation of this block
happened to appear at the same time as the MSM8x60.

gpio.c is already in wide use for v1 systems, and is well-establised
in the android mainlines.  Changing without extremely good cause would not
go pleasantly.

Since gpio.c is v1, we used gpio-v2.c for v2.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
--755636368-2025357044-1290193234=:10560--
