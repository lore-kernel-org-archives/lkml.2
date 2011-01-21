Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1AUX2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:28:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9985 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1AUX2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:28:22 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6233"; a="71447258"
Message-ID: <4D3A1695.7020707@codeaurora.org>
Date: Fri, 21 Jan 2011 15:28:21 -0800
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<20110111031552.GJ3760@linux-sh.org> <4D3862DB.5000708@fluff.org>	<20110120185617.GI6335@n2100.arm.linux.org.uk>	<alpine.LFD.2.00.1101201623480.8580@xanadu.home>	<AANLkTimwBruVgGQWs5NQG7U3PcF6RQHZ6Pd1hjxyGpcA@mail.gmail.com>	<4D3907BD.4040900@codeaurora.org>	<AANLkTik53zyXytvuAd5zK0_zExfQT3FmOgTr8BexmGeT@mail.gmail.com> <alpine.LFD.2.00.1101211618170.8580@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1101211618170.8580@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 01:53 PM, Nicolas Pitre wrote:
...
> And... is there really some advantage to turn the clock off in between 
> frames when you're otherwise busy generating them anyway?

For aggressive power management where supported by HW, yes.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
