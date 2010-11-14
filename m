Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0KNURd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:17:33 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63217 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab0KNURc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:17:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6167"; a="62832039"
Subject: Re: [PATCH 09/14] msm: iommu: Kconfig option for cacheable page
 tables
From: Daniel Walker <dwalker@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1289619000-13167-10-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
	 <1289619000-13167-10-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 12:17:38 -0800
Message-ID: <1289765858.24270.240.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 19:29 -0800, Stepan Moskovchenko wrote:
>  
> +config IOMMU_PGTABLES_L2
> +	depends on ARCH_MSM8X60
> +	depends on MMU
> +	depends on CPU_DCACHE_DISABLE=n
> +	depends on SMP
> +	bool "Cacheable IOMMU page tables"
> +	default y
> +	help
> +	  Allows the IOMMU page tables to be brought into the L2 cache. This
> +	  improves the TLB miss latency at the expense of potential pollution
> +	  of the L2 cache. This option has been shown to improve multimedia
> +	  performance in some cases.
> +
> +	  If unsure, say Y here.

Why would someone want this off?

The other thing is that you usually want this included with the code
that uses the option.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


