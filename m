Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab0LTXj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:39:26 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42068 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306Ab0LTXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:39:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67417700"
Subject: Re: [PATCH 1/5] mmc: msm: consolidate ifdefs for BUSCLK_PWRSAVE
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101220233519.GA14582@huya.qualcomm.com>
References: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
	 <20101220233519.GA14582@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 15:39:10 -0800
Message-ID: <1292888350.27552.22.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 15:35 -0800, David Brown wrote:
> On Mon, Dec 20, 2010 at 03:16:47PM -0800, Daniel Walker wrote:
> 
> > It's cleaner to have ifdef's consolidated in one specific
> > area. This change pulls adds one ifdef which will swap
> > out of the function with a stub function if the ifdef is
> > false.
> 
> It also changes the define from #if checks to #ifdef which changes how
> it would be used.

True, but it's defined in the code. So you have to comment the line out
now instead of change it to "0" ..

> I this feature even used?  It looks like some kind debug feature.

Yeah it's used, it's default on..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


