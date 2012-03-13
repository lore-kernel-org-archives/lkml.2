Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301Ab2CMKAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:00:38 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:47427
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965083Ab2CMKAe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:00:34 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0TIGQ-01-0NI-02
X-M-MSG: 
Date: Tue, 13 Mar 2012 11:00:24 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: KyongHo Cho <pullip.cho@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        <iommu@lists.linux-foundation.org>,
        <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v11 3/3] iommu/exynos: Add iommu driver for Exynos
 Platforms
Message-ID: <20120313100024.GG18973@amd.com>
References: <017a01ccfdee$4e5e7a00$eb1b6e00$%cho@samsung.com>
 <20120312150156.GF18973@amd.com>
 <CAHQjnOOCQb4G1aeFB0FQVBstXpaXmahnQO8+FoinPcQNZEieGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAHQjnOOCQb4G1aeFB0FQVBstXpaXmahnQO8+FoinPcQNZEieGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 05:50:16PM +0900, KyongHo Cho wrote:
> >> +struct sysmmu_drvdata {
> >> +     struct device *sysmmu;
> >> +     char *dbgname;
> >> +     int nsfrs;
> >> +     void __iomem **sfrbases;
> >> +     struct clk *clk[2];
> >> +     int activations;
> >> +     rwlock_t lock;
> >> +     struct iommu_domain *domain;
> >> +     sysmmu_fault_handler_t fault_handler;
> >> +     unsigned long pgtable;
> >> +     struct iommu_client client;
> >> +};
> >
> > Is there any reason why 'struct iommu_client' is a seperate data
> > structure? Otherwise it can be merged with 'truct sysmmu_drvdata'.

Of course this doesn't need to be changed immediatly. I just asked if
there was a specific reason for this seperation.

> The problems will be soon fixed and I will post next patch tomorrow.

Fine. Please also get the Acked-bys from the Exynos maintainer on
patches 1 and 2 at least. I'll merge it then.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

