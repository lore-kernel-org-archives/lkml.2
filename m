Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1AZWDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:03:42 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56379 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1AZWDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:03:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71883920"
Subject: Re: [PATCH 1/4] msm: clock: Remove unused code and definitions
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <8ya1v3z8gu6.fsf@huya.qualcomm.com>
References: <1295927118-27591-1-git-send-email-sboyd@codeaurora.org>
	 <1295927118-27591-2-git-send-email-sboyd@codeaurora.org>
	 <1295991537.25496.49.camel@c-dwalke-linux.qualcomm.com>
	 <4D3F4609.3000808@codeaurora.org>
	 <1295992937.25496.75.camel@c-dwalke-linux.qualcomm.com>
	 <8ya1v3z8gu6.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 14:03:02 -0800
Message-ID: <1296079382.29801.45.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 14:01 -0800, David Brown wrote:
> On Tue, Jan 25 2011, Daniel Walker wrote:
> 
> > On Tue, 2011-01-25 at 13:52 -0800, Saravana Kannan wrote:
> >> On 01/25/2011 01:38 PM, Daniel Walker wrote:
> >> > On Mon, 2011-01-24 at 19:45 -0800, Stephen Boyd wrote:
> >> >> Remove dead code and push out clock-7x30.h and clock-pcom.h to
> >> >> where they are actually used.
> >> >>
> >> >
> >> > I'd do two patches for this. The stuff your doing is too disconnected.
> >> >
> >> > Daniel
> >> >
> >> There is a whole bunch of unused code in the clock files and it's being 
> >> deleted. I don't see a point of splitting it up per file.
> >
> > It's easier to review when changes aren't merged that don't related to
> > each other.
> 
> In this particular case, the patch is a bunch of removal of dead code,
> and kind of makes sense to keep it together.  I'm fine with it as is.

He's adding stuff too .. So it's not _just_ removal which is what I was
getting at.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

