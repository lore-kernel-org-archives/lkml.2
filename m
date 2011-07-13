Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407Ab1GMRtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:49:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26159 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab1GMRtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:49:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6406"; a="103538006"
From: David Brown <davidb@codeaurora.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers/video/msm/mdp.c: adjust error handling code
References: <1309788705-22278-5-git-send-email-julia@diku.dk>
	<20110713081318.GB13701@linux-sh.org>
Date: Wed, 13 Jul 2011 10:49:46 -0700
In-Reply-To: <20110713081318.GB13701@linux-sh.org> (Paul Mundt's message of
	"Wed, 13 Jul 2011 17:13:19 +0900")
Message-ID: <8ya4o2q2hqd.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13 2011, Paul Mundt wrote:

>> I wonder if the error handling code at the end of the function should be
>> calling clk_put as well?  In that case, having a separate label for this
>> case would be useful.  Otherwise, one of error_request_irq and error_get_clk
>> can be deleted
>> 
> The MSM implementation for it is simply a nop, so it's not going to
> really matter one way or the other. In terms of general consistency it
> might be worth implementing.

Today, at least.  Hopefully this will get better, since we can turn off
our clocks.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
