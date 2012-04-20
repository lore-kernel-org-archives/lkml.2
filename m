Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2DTUBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:01:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25688 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2DTUBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:01:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6687"; a="183632767"
Message-ID: <4F91C09E.8070308@codeaurora.org>
Date: Fri, 20 Apr 2012 13:01:34 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Rajendra Nayak <rnayak@ti.com>,
        Olof Johansson <olof@lixom.net>, linaro-dev@lists.linaro.org,
        arnd.bergmann@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/13] clk: basic: improve parent_names & return errors
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-14-git-send-email-mturquette@linaro.org> <20120412064920.GH2445@S2101-09.ap.freescale.net> <CAJOA=zMPQK-W_nbRztXCNdLHoTJU73ZnrxAS8VvvmzgdaVS2mQ@mail.gmail.com> <CAAQ0ZWRg2jwNZ7Bx5j5NtCVveT_085VmFtPMhWW62-aO+kFfnw@mail.gmail.com> <CAJOA=zPnQhq_3O00F4dfUbnywW-Riov7N76F3wraE67yy2MMuA@mail.gmail.com> <CAAQ0ZWQ_haRN-WHNzTMcjFvryRqjM58QoseC8WejBiqcDfSuPA@mail.gmail.com>
In-Reply-To: <CAAQ0ZWQ_haRN-WHNzTMcjFvryRqjM58QoseC8WejBiqcDfSuPA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 12:17 AM, Shawn Guo wrote:
> On 17 April 2012 11:50, Turquette, Mike<mturquette@ti.com>  wrote:
>> That is a good question.  I think it is worth waiting on Saravana's
>> patch which exposes non-private members of struct clk via struct
>> clk_hw.  This will have an effect on both platform clock data and
>> code.
>
> Saravana,
>
> (*nudge*) (*nudge*) goes to you now :)
>
> Regards,
> Shawn

Sorry :) Will do soon.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
