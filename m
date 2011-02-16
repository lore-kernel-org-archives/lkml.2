Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1BPAgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:36:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53498 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab1BPAgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:36:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6258"; a="74421638"
Subject: Re: [PATCH 1/3] msm: iommu: Create a Kconfig item for the IOMMU
 driver
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <8yar5b9850l.fsf@huya.qualcomm.com>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	 <1297456729.4852.9.camel@m0nster>  <8yar5b9850l.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 16:36:03 -0800
Message-ID: <1297816563.7088.23.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 11:35 -0800, David Brown wrote:
> On Fri, Feb 11 2011, Daniel Walker wrote:
> 
> > On Fri, 2011-02-11 at 12:28 -0800, Stepan Moskovchenko wrote:
> >> +config MSM_IOMMU
> >> +       bool "MSM IOMMU Support"
> >> +       depends on ARCH_MSM8X60
> >> +       select IOMMU_API
> >> +       default n
> >> +       help
> >> +         Support for the IOMMUs found on certain Qualcomm SOCs.
> >> +         These IOMMUs allow virtualization of the address space used by most
> >> +         cores within the multimedia subsystem.
> >> +
> >> +         If unsure, say N here. 
> >
> > I think you should just make this a hidden option, unless there is a
> > good reason why any given users might want to turn this off.
> 
> In this particular case, the driver is optional, even devices that use
> it will be able to work both with and without it.  It makes sense to be
> able to decide whether to have it or not.

This driver doesn't belong under mach-msm.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

