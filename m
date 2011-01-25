Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab1AYTR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:17:27 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1AYTRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:17:25 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71939859"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/11] msm: Add CPU queries
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-2-git-send-email-davidb@codeaurora.org>
	<1295914163.29639.77.camel@c-dwalke-linux.qualcomm.com>
	<8yak4htj0lb.fsf@huya.qualcomm.com>
	<1295915034.29639.78.camel@c-dwalke-linux.qualcomm.com>
	<8yay669hka5.fsf@huya.qualcomm.com>
	<1295976910.25496.1.camel@c-dwalke-linux.qualcomm.com>
X-Hashcash: 1:20:110125:linux-arm-kernel@lists.infradead.org::phYhjtB8IMD7LPAl:00000000000000000000000000kqT
X-Hashcash: 1:20:110125:dwalker@codeaurora.org::R7xgVkxarOqel990:00000000000000000000000000000000000000026UE
X-Hashcash: 1:20:110125:linux-arm-msm@vger.kernel.org::3spVvcC8YG7drn5T:000000000000000000000000000000003gia
X-Hashcash: 1:20:110125:linux-kernel@vger.kernel.org::EasPB5L4wStsRSNo:0000000000000000000000000000000004blV
Date: Tue, 25 Jan 2011 11:17:25 -0800
In-Reply-To: <1295976910.25496.1.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Tue, 25 Jan 2011 09:35:10 -0800")
Message-ID: <8ya39ogg5dm.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25 2011, Daniel Walker wrote:

> On Mon, 2011-01-24 at 16:57 -0800, David Brown wrote:
>> MSM7201 and MSM7601 are identical as far as Linux is concerned.  Same
>> goes for MSM8250 and MSM8650.  Our dev boards are a somewhat random mix
>> of the two, and it doesn't matter which one you use.
>> 
>> MSM8960 is a completely different chip, it just shares a similar name,
>> to other chips.
>
> If you break it down without the "x" then you can recreate the "x"
> variant with the actual numerical identifier .. For 8660/8960 you just
> would do as much of a unification as with the others.. You could still
> use 8x60 to identify those two, you just wouldn't use it as often.

There isn't any unification to do here.  There are two issues.  We make
some chips in groups where we have _identical_ silicon on the Linux
side, but happen to have different numbers.  That's what the X is
about.  There are other cases where we have completely different silicon
that happen to have similar numbers.

The whole point of the cpu_is tests is to tell us exactly which chip we
are on.  If there is _anything_ different between two chips, that query
needs to be different.  If there is any kind of unification, it can be
done at a higher level.  Otherwise, you have no way of making the
distinction that needs to be made.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
