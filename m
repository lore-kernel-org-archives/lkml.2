Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1AYUGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:06:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11971 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab1AYUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:06:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71731110"
Subject: Re: [PATCH v2 01/11] msm: Add CPU queries
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <8yaei80epie.fsf@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-2-git-send-email-davidb@codeaurora.org>
	 <1295914163.29639.77.camel@c-dwalke-linux.qualcomm.com>
	 <8yak4htj0lb.fsf@huya.qualcomm.com>
	 <1295915034.29639.78.camel@c-dwalke-linux.qualcomm.com>
	 <8yay669hka5.fsf@huya.qualcomm.com>
	 <1295976910.25496.1.camel@c-dwalke-linux.qualcomm.com>
	 <8ya39ogg5dm.fsf@huya.qualcomm.com>
	 <1295983549.25496.33.camel@c-dwalke-linux.qualcomm.com>
	 <8yaei80epie.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 12:06:18 -0800
Message-ID: <1295985978.25496.35.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 11:45 -0800, David Brown wrote:
> On Tue, Jan 25 2011, Daniel Walker wrote:
> 
> > On Tue, 2011-01-25 at 11:17 -0800, David Brown wrote:
> 
> > I suggesting we do it across the board because consistency is a good
> > thing .. It also allows us to use 8x60 when 8660 and 8960 are actually
> > similar .. You can't deny that 8960 is similar to 8660 because your
> > patches show some duplication due to it.
> 
> You're completely missing the point of these tests.  If _anything_ is
> different, the macros need to be different.  I don't care if they're
> similar, I need to know when they are different.  That is the point of
> the macros.

I said you would have macros specifically for 8660 and 8960, so if you
need to know when they're different then you have macro's to do that. 

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

