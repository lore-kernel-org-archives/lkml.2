Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1G2OBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:01:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48905 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab1G2OBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:01:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6421"; a="106592209"
Date: Fri, 29 Jul 2011 07:01:27 -0700
From: David Brown <davidb@codeaurora.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: msm: Remove PLAT_PHYS_OFFSETS from MSM targets
Message-ID: <20110729140127.GA17137@huya.qualcomm.com>
References: <1311794355-26988-2-git-send-email-sboyd@codeaurora.org>
 <1311884291-5409-1-git-send-email-davidb@codeaurora.org>
 <1311884291-5409-2-git-send-email-davidb@codeaurora.org>
 <20110729103239.GC25640@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1107290841300.12766@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1107290841300.12766@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 08:42:15AM -0400, Nicolas Pitre wrote:
> On Fri, 29 Jul 2011, Russell King - ARM Linux wrote:
> 
> > On Thu, Jul 28, 2011 at 01:18:11PM -0700, David Brown wrote:
> > > Now that MSM can boot with the phys offset patching, eliminate the
> > > definitions of the phys offsets, and instead select
> > > ARM_PATCH_PHYS_VIRT.
> > 
> > I think it may be better to remove the EXPERIMENTAL status of
> > ARM_PATCH_PHYS_VIRT, and make the option default to 'y' now, so that
> > we start building all kernels with this enabled.  If people don't
> > want it (and know what they're doing) they can disable it manually
> > (maybe make the option only appear for EXPERT).
> 
> One of my jumbo patch series is doing that.
> 
> > Lets see about that after this merge window is over.

In that case, I'll resend just the second of my patches after this
series.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
