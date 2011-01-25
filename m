Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1AYRfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:35:43 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4269 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1AYRfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:35:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71711438"
Subject: Re: [PATCH v2 01/11] msm: Add CPU queries
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <8yay669hka5.fsf@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-2-git-send-email-davidb@codeaurora.org>
	 <1295914163.29639.77.camel@c-dwalke-linux.qualcomm.com>
	 <8yak4htj0lb.fsf@huya.qualcomm.com>
	 <1295915034.29639.78.camel@c-dwalke-linux.qualcomm.com>
	 <8yay669hka5.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 09:35:10 -0800
Message-ID: <1295976910.25496.1.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 16:57 -0800, David Brown wrote:
> On Mon, Jan 24 2011, Daniel Walker wrote:
> 
> > On Mon, 2011-01-24 at 16:20 -0800, David Brown wrote:
> >> On Mon, Jan 24 2011, Daniel Walker wrote:
> >> 
> >> > On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
> >> >> +#define cpu_is_msm7x01()       0
> >> >> +#define cpu_is_msm7x30()       0
> >> >> +#define cpu_is_qsd8x50()       0
> >> >> +#define cpu_is_msm8x60()       0
> >> >
> >> > Now that I look at this again, why not drop the "x" all together ?
> >> 
> >> That might be better for the 8x60.  The complexity is that most of the
> >> MSM chips have some variants, where the CPU running Linux isn't changed,
> >> but the modem CPU is different (think CDMA/UMTS).  Until 8960, that was
> >> distinguished by the second letter.
> >> 
> >> Either way doesn't quite match reality, unfortunately.  There are
> >> devices using a MSM7201 and others using a MSM7601.  As far as Linux is
> >> concerned, there isn't any difference between them.  If someone wanted
> >> to try and identify the device they have with the code, it could be
> >> confusing for either name chosen.
> >> 
> >> I was planning on turning msm8x60 into msm8660, since that seems to be
> >> the most common one.  Perhaps the decoder ring should be put into the
> >> help text for the options so people can at least figure out which is
> >> which.
> >
> > Are there any of those which do , right now, have Linux support for more
> > than one variant ?
> 
> All of them, in fact.
> 
> MSM7201 and MSM7601 are identical as far as Linux is concerned.  Same
> goes for MSM8250 and MSM8650.  Our dev boards are a somewhat random mix
> of the two, and it doesn't matter which one you use.
> 
> MSM8960 is a completely different chip, it just shares a similar name,
> to other chips.

If you break it down without the "x" then you can recreate the "x"
variant with the actual numerical identifier .. For 8660/8960 you just
would do as much of a unification as with the others.. You could still
use 8x60 to identify those two, you just wouldn't use it as often.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

