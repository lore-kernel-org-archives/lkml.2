Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab1JGKmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:42:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23183 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759712Ab1JGKmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:42:24 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-bd-4e8ed78ee115
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        younglak1004.kim@samsung.com
References: <01e001cc84d7$5e0b84b0$1a228e10$%kim@samsung.com>
 <20111007102754.GF21464@n2100.arm.linux.org.uk>
In-reply-to: <20111007102754.GF21464@n2100.arm.linux.org.uk>
Subject: RE: [PATCH v3 1/2] ARM: EXYNOS4: Change System MMU device	definition
Date: Fri, 07 Oct 2011 19:42:22 +0900
Message-id: <01eb01cc84dd$cb740940$625c1bc0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyE280QBlFl/eZJS3i7aFUGo0tKbwAAd02g
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> 
> On Fri, Oct 07, 2011 at 06:56:21PM +0900, Kukjin Kim wrote:
> > +#define SYSMMU_RESOURCE(ipname, base, irq) \
> > +static struct resource sysmmu_resource_##ipname[] =\
> > +{\
> > +	{\
> > +		.start	= EXYNOS4_PA_SYSMMU_##base,\
> > +		.end	= EXYNOS4_PA_SYSMMU_##base + SZ_4K - 1,\
> > +		.flags	= IORESOURCE_MEM,\
> > +	}, {\
> > +		.start	= IRQ_SYSMMU_##irq##_0,\
> > +		.end	= IRQ_SYSMMU_##irq##_0,\
> > +		.flags	= IORESOURCE_IRQ,\
> > +	},\
> >  }
> 
> #define SYSMMU_RESOURCE(ipname, base, irq) \
> static struct resource sysmmu_resource_##ipname[] = \
> { \
> 	DEFINE_RES_MEM(EXYNOS4_PA_SYSMMU_##base, SZ_4K), \
> 	DEFINE_RES_IRQ(IRQ_SYSMMU_##irq##_0), \
> }

Oops, I missed that.
OK, let him change it.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

