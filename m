Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1AZWFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:05:09 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63613 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1AZWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:05:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71884075"
Subject: Re: [PATCH 4/4] msm: clock: Add support for more proc_comm clocks
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <8yawrlr726g.fsf@huya.qualcomm.com>
References: <1295927118-27591-1-git-send-email-sboyd@codeaurora.org>
	 <1295927118-27591-5-git-send-email-sboyd@codeaurora.org>
	 <1295992703.25496.72.camel@c-dwalke-linux.qualcomm.com>
	 <8yawrlr726g.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 14:04:39 -0800
Message-ID: <1296079479.29801.46.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 14:03 -0800, David Brown wrote:
> On Tue, Jan 25 2011, Daniel Walker wrote:
> 
> > On Mon, 2011-01-24 at 19:45 -0800, Stephen Boyd wrote:
> >> Support the CE_CLK and CODEC_SSBI_CLK. Also add support for uart,
> >> and i2c clocks on targets which support proc_comm clocks.
> >
> > Basically when you catch yourself writing "also" in the commit text you
> > need to re-evaluate making two patches.. In this case it looks
> > appropriate..
> 
> Or it is just an argument to not use the word also in the commit text.
> I don't think it's really necessary to split up a patch that adds a few
> clocks to the clock table.

This one it actually makes a lot of sense to break it up. He's doing
some very different things here all in the same patch ..

Daniel


-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

