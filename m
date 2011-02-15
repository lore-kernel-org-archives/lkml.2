Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1BOGbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:31:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51510 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1BOGbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:31:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6257"; a="74276232"
Message-ID: <4D5A1DAF.5050302@codeaurora.org>
Date: Mon, 14 Feb 2011 22:31:11 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>, Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, Paul Mundt <lethal@linux-sh.org>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 2/3] clk: Generic support for fixed-rate clocks
References: <1297233693.242725.820672531799.2.gpush@pororo>	<201102150941.00668.jeremy.kerr@canonical.com>	<4D5A063F.1010102@codeaurora.org> <201102151418.37780.jeremy.kerr@canonical.com>
In-Reply-To: <201102151418.37780.jeremy.kerr@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 10:18 PM, Jeremy Kerr wrote:

> Because the drivers using this clock don't know that it's a fixed clock.
>
> For example, a uart needs to know the rate of its clock source, so that it can
> set its internal divisors to get a valid baud rate. The uart driver will query
> the input rate using clk_get_rate(). The driver still needs to call
> clk_enable/clk_prepare/etc, because on some systems it may have a switchable
> clock.

Thanks. Makes sense.

-Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
