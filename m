Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1BKWA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:00:26 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53483 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab1BKWAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:00:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="73907185"
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple
 targets
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Steve Muckle <smuckle@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <8yad3mykzks.fsf@huya.qualcomm.com>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	 <1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
	 <1297456934.4852.11.camel@m0nster> <4D55A16A.7030300@codeaurora.org>
	 <8yaipwql1wf.fsf@huya.qualcomm.com> <1297458889.4852.24.camel@m0nster>
	 <8yad3mykzks.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 14:00:22 -0800
Message-ID: <1297461622.4852.29.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 13:53 -0800, David Brown wrote:
> On Fri, Feb 11 2011, Daniel Walker wrote:
> 
> > On Fri, 2011-02-11 at 13:03 -0800, David Brown wrote:
> >> On Fri, Feb 11 2011, Steve Muckle wrote:
> 
> >> If they were used in more than one place, we could justify the
> >> definition, but in this case, the definition just obscures the code
> >> slightly.
> 
> Someone debugging it will look at the constant.  In fact, in general,
> the only person looking at this structure will want to know the value in
> the table.  Indirecting it through a pointer only serves to hide it from
> the person who wants to know the value.

Like I said in my example, people looking at the code won't always be
debugging.

> > A good example might be if all these constants are enumerated in a
> > header file, but aren't all used. In that case it would be fairly easy
> > to add a new resource without even know what the constant is just by
> > following the pattern.
> 
> This I definitely want to avoid.  I have seen header files with hundreds
> of thousands of register definitions, where only a few were used.

I think your thinking of stuff that's not properly grouped.

> > I think in general this series just makes this iommu code very much
> > 8660/8960 only code, but what about the potential next iteration of SoC
> > that uses very similar code to this with all new constants. So this
> > doesn't seem forward thinking to me.
> 
> The table would have the different addresses in it.  My point is that
> the resource table _is_ the definition of the addres.  Nothing is gained
> by inventing yet another name and putting that somewhere else.

In my example I showed you there is something to be gained by doing
this. As you said already there isn't must lost in doing it this way.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


