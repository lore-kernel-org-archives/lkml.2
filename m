Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0KPUpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:45:31 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44946 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab0KPUpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:45:30 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6169"; a="62904492"
Subject: Re: [PATCH 14/14] msm: iommu: Miscellaneous code cleanup
From: Daniel Walker <dwalker@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CE1DB7F.1020408@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
	 <1289619000-13167-15-git-send-email-stepanm@codeaurora.org>
	 <1289867105.4050.29.camel@c-dwalke-linux.qualcomm.com>
	 <4CE1DB7F.1020408@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 12:45:23 -0800
Message-ID: <1289940323.9950.15.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 17:16 -0800, Stepan Moskovchenko wrote:
> On 11/15/2010 4:25 PM, Daniel Walker wrote:
> > On Fri, 2010-11-12 at 19:30 -0800, Stepan Moskovchenko wrote:
> >> Remove some unneeded assignments and messages, restructure
> >> a failure path in iova_to_phys, and make __flush_iotlb
> >> return int in preparation for adding IOMMU clock control.
> > Why restructure the failure path ?
> >
> > Daniel
> 
> It is a trivial change of replacing a goto with an assignment and moving 
> it a few lines down. It reduces "jumpiness" within that function and is 
> a cleaner version. On the more practical side, it was done in 
> preparation for some other changes I have coming up, which touch that 
> function and work a lot better with the cleaned-up failure path. The 
> next patch was delayed (due to a dependency) but as long as I was doing 
> code cleanup, I saw no reason not to also clean up the failure path as 
> part of this series.

Some of what your have said above really needs to be in your commit
text. I've noticed that your commit text in general is not verbose
enough. You need to explain what doing better.

Also generally you want to organize similar sets of changes. So if you
doing a cleanup in preparation for another change then the cleanup
should go with the other change. In this case it's not clear that this
is actually a cleanup, so it would be much nicer to get that change
along with the one you've delayed .. Also the two Kconfig changes you've
sent indicate that your not organizing your changes properly, so I think
you need to take more time considering how to the organize patches.

Just so we're clear on this, any changes that you send me will go into
_permanent_ public history. This history will not disappear at some set
date, and we will not be rebasing out changes or squashing changes.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

