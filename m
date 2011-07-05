Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1GETPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:15:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40642 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1GETPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:15:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6398"; a="101927606"
Message-ID: <4E1362DD.7030001@codeaurora.org>
Date: Tue, 05 Jul 2011 12:15:41 -0700
From: Jeff Ohlstein <johlstei@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>, stable@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable] [PATCH v2] msm: timer: compensate for timer shift in
 msm_read_timer_count
References: <1308344138-2862-1-git-send-email-johlstei@codeaurora.org>	<20110620215922.GA21909@kroah.com>	<8ya7h8gozhn.fsf@huya.qualcomm.com> <20110621162427.GA28836@kroah.com>
In-Reply-To: <20110621162427.GA28836@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jun 20, 2011 at 04:27:16PM -0700, David Brown wrote:
>> I don't think this patch was intended for stable in the first place.
>> Jeff, this is a fix for 3.0-rcx, right?
> 
> Then why was it sent to stable@kernel.org?
> 
> confused,
> 
> greg k-h
> 

Sorry, this was indeed intended for stable. I will include the Cc: tag
in future patches stable. However, since this was already picked up in
Linus's tree, how should I proceed to get it into stable?

Jeff

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
