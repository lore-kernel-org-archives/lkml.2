Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab2IMQPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:15:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51035 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2IMQPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:15:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6834"; a="236286706"
Date: Thu, 13 Sep 2012 09:15:48 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: SoC: convert MSM SMP to SoC descriptor
Message-ID: <20120913161548.GA11395@codeaurora.org>
References: <1347461906-13527-7-git-send-email-arnd@arndb.de>
 <1347490900-8409-1-git-send-email-davidb@codeaurora.org>
 <201209130847.20087.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209130847.20087.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 08:47:19AM +0000, Arnd Bergmann wrote:
> On Wednesday 12 September 2012, David Brown wrote:
> > 
> > From: Marc Zyngier <marc.zyngier@arm.com>
> > 
> > Convert MSM SMP platforms to use the SoC descriptor to provide
> > their SMP and CPU hotplug operations.
> > 
> > Cc: David Brown <davidb@codeaurora.org>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > This is an adaptation of this change on top of the msm-for-3.7 tree I
> > recently sent out a pull request for.  The only real change is to
> > resolve the conflicts with the simplified board files.
> 
> Not sure what I'm supposed to do with this patch, it doesn't apply
> unless I rebase all of the SMP patches on top of your msm-for-3.7 branch,
> which would be rather odd.
> 
> I'll make sure the branches merge fine and then apply your patch 2/2
> on top of the merge, ok?

Yeah, it shouldn't hurt anything to just wait until both get merged
in.  The patch was mostly a heads up that your series was going to
conflict with msm changes coming in.

Olof wanted me to try and split the msm-for-3.7 into a few branches,
so I'm going to work on that this morning.  I'm not quite sure how
well it will work, since, for example, most of the cleanups are
preparing the tree for the devicetree changes.

David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
