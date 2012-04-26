Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2DZGA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:00:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50833 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2DZGA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:00:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="182785720"
Message-ID: <293d03fc4c269b5359c0826b982cc4be.squirrel@www.codeaurora.org>
In-Reply-To: <CAAQ0ZWQ_haRN-WHNzTMcjFvryRqjM58QoseC8WejBiqcDfSuPA@mail.gmail.com>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
    <1334192572-12499-14-git-send-email-mturquette@linaro.org>
    <20120412064920.GH2445@S2101-09.ap.freescale.net>
    <CAJOA=zMPQK-W_nbRztXCNdLHoTJU73ZnrxAS8VvvmzgdaVS2mQ@mail.gmail.com>
    <CAAQ0ZWRg2jwNZ7Bx5j5NtCVveT_085VmFtPMhWW62-aO+kFfnw@mail.gmail.com>
    <CAJOA=zPnQhq_3O00F4dfUbnywW-Riov7N76F3wraE67yy2MMuA@mail.gmail.com>
    <CAAQ0ZWQ_haRN-WHNzTMcjFvryRqjM58QoseC8WejBiqcDfSuPA@mail.gmail.com>
Date: Wed, 25 Apr 2012 23:00:26 -0700 (PDT)
Subject: Re: [PATCH 13/13] clk: basic: improve parent_names & return errors
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Shawn Guo" <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, "Saravana Kannan" <skannan@codeaurora.org>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Russell King" <linux@arm.linux.org.uk>, patches@linaro.org,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Rajendra Nayak" <rnayak@ti.com>, "Olof Johansson" <olof@lixom.net>,
        linaro-dev@lists.linaro.org, arnd.bergmann@linaro.org,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, April 17, 2012 12:17 am, Shawn Guo wrote:
> On 17 April 2012 11:50, Turquette, Mike <mturquette@ti.com> wrote:
>> That is a good question.  I think it is worth waiting on Saravana's
>> patch which exposes non-private members of struct clk via struct
>> clk_hw.  This will have an effect on both platform clock data and
>> code.
>
> Saravana,
>
> (*nudge*) (*nudge*) goes to you now :)
>

Done! I especially like how it turned out.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


