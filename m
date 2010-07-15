Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0GOG1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:27:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15263 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0GOG1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:27:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6043"; a="47538577"
Message-ID: <4C3EAA44.7040607@codeaurora.org>
Date: Wed, 14 Jul 2010 23:27:16 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: Meaning of clk_round_rate()?
References: <4C3DFC7A.8020002@codeaurora.org> <20100714200324.GA18138@n2100.arm.linux.org.uk>
In-Reply-To: <20100714200324.GA18138@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Wed, Jul 14, 2010 at 11:05:46AM -0700, Stephen Boyd wrote:
> clk_round_rate() returns the clock rate which will be set if you ask
> clk_set_rate() to set that rate.  It provides a way to query from
> the implementation exactly what rate you'll get if you use clk_set_rate()
> with that same argument.

Fair enough explanation for clk_round_rate(). I guess I should take it 
as "it's up to the specific clock implementation on what it wants to do".

But what about the problem of a clock consumer trying to find a suitable 
frequency amongst the ones provided by a particular clock?

What are your thoughts on adding the following two APIs to linux/clk.h?
clk_round_rate_down/floor()
clk_round_rate_up/ceil()

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
