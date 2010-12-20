Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab0LTXpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:45:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31217 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab0LTXpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:45:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67628023"
Subject: Re: [PATCH 1/5] mmc: msm: consolidate ifdefs for BUSCLK_PWRSAVE
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101220234206.GA15270@huya.qualcomm.com>
References: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
	 <20101220233519.GA14582@huya.qualcomm.com>
	 <1292888350.27552.22.camel@m0nster>
	 <20101220234206.GA15270@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 15:45:23 -0800
Message-ID: <1292888723.27552.24.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 15:42 -0800, David Brown wrote:
> On Mon, Dec 20, 2010 at 03:39:10PM -0800, Daniel Walker wrote:
> > > I this feature even used?  It looks like some kind debug feature.
> > 
> > Yeah it's used, it's default on..
> 
> What I meant was "is there any reason to be able to turn this off."
> It looks like something that would be used during development, and
> doesn't need to be disabled once the driver works.

I have no idea. I'm just doing a clean up here .. It's on, it's got a
config to turn it off, as far as I know it's used and useful.

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


