Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1I1Xu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:50:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36305 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1I1XuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:50:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6483"; a="123111780"
Date: Wed, 28 Sep 2011 16:50:21 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] msm: Consolidate and move DEBUG_LL to generic ARM
 Kconfig
Message-ID: <20110928235021.GA10636@huya.qualcomm.com>
References: <1317243959-26383-1-git-send-email-sboyd@codeaurora.org>
 <1317243959-26383-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317243959-26383-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 02:05:58PM -0700, Stephen Boyd wrote:
> Now that DEBUG_LL is a choice, we can move MSM's homegrown choice
> menu to DEBUG_LL.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

This seems to make DEBUG_LL work again on MSM8250.  So:

Tested-by: David Brown <davidb@codeaurora.org>

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
