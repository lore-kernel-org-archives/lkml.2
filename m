Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0KSSht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:37:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21385 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab0KSShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:37:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6172"; a="63575061"
Date: Fri, 19 Nov 2010 10:37:45 -0800 (PST)
From: Gregory Bean <gbean@codeaurora.org>
X-X-Sender: gbean@gbean-linux.qualcomm.com
To: Janakiram Sistla <janakiram.sistla@gmail.com>
cc: Gregory Bean <gbean@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] msm: gpio: Add irq support to v2 gpiolib.
In-Reply-To: <AANLkTiknYmWOmiFXGp6h2dT==aMuGs3BtXi82b6Vdq5i@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011191035210.10052@gbean-linux.qualcomm.com>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org> <1290109970-26752-2-git-send-email-gbean@codeaurora.org> <AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com> <alpine.DEB.2.00.1011181229380.26784@gbean-linux.qualcomm.com>
 <AANLkTi=p02P=-JQ9+FynFyM1yxrAh3utKTD2uzqhnLxK@mail.gmail.com> <alpine.DEB.2.00.1011181256470.29924@gbean-linux.qualcomm.com> <AANLkTiknYmWOmiFXGp6h2dT==aMuGs3BtXi82b6Vdq5i@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Janakiram Sistla wrote:

>> Targets with the v2 block define CONFIG_MSM_V2_TLMM.
>
> So in that case we can name  it as gpio-tlmm.c ??

No, not and have things be any clearer.

All MSM chips have a TLMM block.  The older chips have
version 1 (v1) of the TLMM block.  The newer chips have v2.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
