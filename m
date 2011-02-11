Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab1BKUpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:45:53 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7232 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab1BKUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:45:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="74107312"
Subject: Re: [PATCH 1/3] msm: iommu: Create a Kconfig item for the IOMMU
 driver
From: Daniel Walker <dwalker@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 12:38:49 -0800
Message-ID: <1297456729.4852.9.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 12:28 -0800, Stepan Moskovchenko wrote:
> +config MSM_IOMMU
> +       bool "MSM IOMMU Support"
> +       depends on ARCH_MSM8X60
> +       select IOMMU_API
> +       default n
> +       help
> +         Support for the IOMMUs found on certain Qualcomm SOCs.
> +         These IOMMUs allow virtualization of the address space used by most
> +         cores within the multimedia subsystem.
> +
> +         If unsure, say N here. 

I think you should just make this a hidden option, unless there is a
good reason why any given users might want to turn this off.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


