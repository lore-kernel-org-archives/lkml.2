Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1AYV6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:58:52 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64648 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AYV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:58:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71959699"
Subject: Re: [PATCH 4/4] msm: clock: Add support for more proc_comm clocks
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1295927118-27591-5-git-send-email-sboyd@codeaurora.org>
References: <1295927118-27591-1-git-send-email-sboyd@codeaurora.org>
	 <1295927118-27591-5-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 13:58:23 -0800
Message-ID: <1295992703.25496.72.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 19:45 -0800, Stephen Boyd wrote:
> Support the CE_CLK and CODEC_SSBI_CLK. Also add support for uart,
> and i2c clocks on targets which support proc_comm clocks.

Basically when you catch yourself writing "also" in the commit text you
need to re-evaluate making two patches.. In this case it looks
appropriate..

I'd do CE_CLK and CODEC_SSBI_CLK in one, with the increment for the
number of clocks, and adding those two clocks.

Then the rest of it I'm not sure. If it was me I'd break out uart and
i2c in different patches but that might be overkill.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

