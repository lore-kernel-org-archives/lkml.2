Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1AYT0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:26:19 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1AYT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:26:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71725713"
Subject: Re: [PATCH v2 01/11] msm: Add CPU queries
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <8ya39ogg5dm.fsf@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-2-git-send-email-davidb@codeaurora.org>
	 <1295914163.29639.77.camel@c-dwalke-linux.qualcomm.com>
	 <8yak4htj0lb.fsf@huya.qualcomm.com>
	 <1295915034.29639.78.camel@c-dwalke-linux.qualcomm.com>
	 <8yay669hka5.fsf@huya.qualcomm.com>
	 <1295976910.25496.1.camel@c-dwalke-linux.qualcomm.com>
	 <8ya39ogg5dm.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 11:25:49 -0800
Message-ID: <1295983549.25496.33.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 11:17 -0800, David Brown wrote:
> On Tue, Jan 25 2011, Daniel Walker wrote:
> 
> > On Mon, 2011-01-24 at 16:57 -0800, David Brown wrote:
> >> MSM7201 and MSM7601 are identical as far as Linux is concerned.  Same
> >> goes for MSM8250 and MSM8650.  Our dev boards are a somewhat random mix
> >> of the two, and it doesn't matter which one you use.
> >> 
> >> MSM8960 is a completely different chip, it just shares a similar name,
> >> to other chips.
> >
> > If you break it down without the "x" then you can recreate the "x"
> > variant with the actual numerical identifier .. For 8660/8960 you just
> > would do as much of a unification as with the others.. You could still
> > use 8x60 to identify those two, you just wouldn't use it as often.
> 
> There isn't any unification to do here.  There are two issues.  We make
> some chips in groups where we have _identical_ silicon on the Linux
> side, but happen to have different numbers.  That's what the X is
> about.  There are other cases where we have completely different silicon
> that happen to have similar numbers.
> 
> The whole point of the cpu_is tests is to tell us exactly which chip we
> are on.  If there is _anything_ different between two chips, that query
> needs to be different.  If there is any kind of unification, it can be
> done at a higher level.  Otherwise, you have no way of making the
> distinction that needs to be made.

I suggesting we do it across the board because consistency is a good
thing .. It also allows us to use 8x60 when 8660 and 8960 are actually
similar .. You can't deny that 8960 is similar to 8660 because your
patches show some duplication due to it.

Daniel


-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

