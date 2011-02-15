Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1BOEvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 23:51:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11762 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1BOEvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 23:51:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6257"; a="74267270"
Message-ID: <4D5A063F.1010102@codeaurora.org>
Date: Mon, 14 Feb 2011 20:51:11 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, Dima Zavin <dmitriyz@google.com>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 2/3] clk: Generic support for fixed-rate clocks
References: <1297233693.242725.820672531799.2.gpush@pororo>	<4D54738C.80900@bluewatersys.com> <201102150941.00668.jeremy.kerr@canonical.com>
In-Reply-To: <201102150941.00668.jeremy.kerr@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 05:41 PM, Jeremy Kerr wrote:
> Hi Ryan,
>
>> A fixed clock may still have other operations such as enable/disable.
>
> Then it's not a fixed clock; I'd prefer this to be a separate type, as it's
> now hardware dependent.
>

I'm confused. If a clock's rate can't be changed and it can't be enabled 
or disabled, then what's the point of representing that clock 
signal/line as a clock in the driver. Seems like a "nothing to see here, 
move along" type of clock. To express it differently, I find this 
similar to "if (1) { ... }". Obviously I'm missing something here. What 
is it?

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
