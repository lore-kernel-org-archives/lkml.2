Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1AZWDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:03:37 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32982 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1AZWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:03:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="72101119"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] msm: clock: Add support for more proc_comm clocks
References: <1295927118-27591-1-git-send-email-sboyd@codeaurora.org>
	<1295927118-27591-5-git-send-email-sboyd@codeaurora.org>
	<1295992703.25496.72.camel@c-dwalke-linux.qualcomm.com>
X-Hashcash: 1:20:110126:dwalker@codeaurora.org::AUILnFtKS+ogi+Hf:0000000000000000000000000000000000000000G1o
X-Hashcash: 1:20:110126:skannan@codeaurora.org::D8Q+eVPM5PoLX+RH:0000000000000000000000000000000000000001RjY
X-Hashcash: 1:20:110126:linux-arm-kernel@lists.infradead.org::O9cJdS9uR0ltlAjs:00000000000000000000000000TsE
X-Hashcash: 1:20:110126:linux-arm-msm@vger.kernel.org::4Z9mabqafIkgS9y1:000000000000000000000000000000000dFQ
X-Hashcash: 1:20:110126:sboyd@codeaurora.org::goYvi0SWTeeLJRTs:0000000000000000000000000000000000000000052II
X-Hashcash: 1:20:110126:linux-kernel@vger.kernel.org::JRDr5WjZfhDXU78q:0000000000000000000000000000000007vCO
Date: Wed, 26 Jan 2011 14:03:35 -0800
In-Reply-To: <1295992703.25496.72.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Tue, 25 Jan 2011 13:58:23 -0800")
Message-ID: <8yawrlr726g.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25 2011, Daniel Walker wrote:

> On Mon, 2011-01-24 at 19:45 -0800, Stephen Boyd wrote:
>> Support the CE_CLK and CODEC_SSBI_CLK. Also add support for uart,
>> and i2c clocks on targets which support proc_comm clocks.
>
> Basically when you catch yourself writing "also" in the commit text you
> need to re-evaluate making two patches.. In this case it looks
> appropriate..

Or it is just an argument to not use the word also in the commit text.
I don't think it's really necessary to split up a patch that adds a few
clocks to the clock table.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
