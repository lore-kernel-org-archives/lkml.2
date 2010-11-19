Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0KSU11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:27:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44142 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab0KSU10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:27:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6172"; a="63406156"
Date: Fri, 19 Nov 2010 12:27:26 -0800 (PST)
From: Gregory Bean <gbean@codeaurora.org>
X-X-Sender: gbean@gbean-linux.qualcomm.com
To: Janakiram Sistla <janakiram.sistla@gmail.com>
cc: Gregory Bean <gbean@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] msm: gpio: Add irq support to v2 gpiolib.
In-Reply-To: <AANLkTi=VGx1xR3f7_8-cMQAmaz6PQ-t=Xubk_Jtp911V@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011191223570.10560@gbean-linux.qualcomm.com>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org> <1290109970-26752-2-git-send-email-gbean@codeaurora.org> <AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com> <alpine.DEB.2.00.1011181229380.26784@gbean-linux.qualcomm.com>
 <AANLkTi=p02P=-JQ9+FynFyM1yxrAh3utKTD2uzqhnLxK@mail.gmail.com> <alpine.DEB.2.00.1011181256470.29924@gbean-linux.qualcomm.com> <AANLkTiknYmWOmiFXGp6h2dT==aMuGs3BtXi82b6Vdq5i@mail.gmail.com> <alpine.DEB.2.00.1011191035210.10052@gbean-linux.qualcomm.com>
 <AANLkTiknSudbo_j+nqBqmds49CWyqXf0jpvz+DTYH-zg@mail.gmail.com> <alpine.DEB.2.00.1011191053040.10560@gbean-linux.qualcomm.com> <AANLkTi=VGx1xR3f7_8-cMQAmaz6PQ-t=Xubk_Jtp911V@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Since gpio.c is v1, we used gpio-v2.c for v2.
>
> Greg, i agree your point ,but i think v2 differs from v1 with a new
> features distinguished.Also there might be a intention behind going
> for v2 that might resolve some hardware erratas in v1.

V2 is not an extension to or erratas to v1, it is almost
completely different.  Any erratas to v1 would be released as v1.1 (I suspect).

> what if again a new generation comes then we will name it gpio-v3.c ??

I assume so.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
