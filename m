Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946144Ab2LFRH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:07:58 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:50757 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1424341Ab2LFRH4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:07:56 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371Id6eah542Izz1de0h1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1155h)
X-WSS-ID: 0MEMCX3-01-C78-02
X-M-MSG: 
From: "Kinney, Steven" <Steven.Kinney@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Hiroshi DOYU <hdoyu@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Jiri Kosina <jkosina@suse.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH 1/1] iommuv2/amd: Enable Performance Counters On Family
 15h Models 10h-1Fh
Thread-Topic: [PATCH 1/1] iommuv2/amd: Enable Performance Counters On Family
 15h Models 10h-1Fh
Thread-Index: AQHN0m1gXsaBYG37VECoS39fp5EsGZgL+cAAgAAIb/A=
Date: Thu, 6 Dec 2012 17:07:49 +0000
Message-ID: <57D41218901B4442B4AFF404D215911636E15F@sausexdag02.amd.com>
References: <1354659546-9700-1-git-send-email-steven.kinney@amd.com>
 <20121206103238.GF1806@8bytes.org>
In-Reply-To: <20121206103238.GF1806@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.236.70.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

                       I see your point(s).  First, to the second point, I should (and will) add a check to the AMD Family/Model coupled to this change.  Also, I will append the patch(es) to include the perf IOMMU PMU so that this change is put into context.

Thanks for your time and advise.

Best Regards,

Steve

-----Original Message-----
From: Joerg Roedel [mailto:joro@8bytes.org] 
Sent: Thursday, December 06, 2012 4:33 AM
To: Kinney, Steven
Cc: Hiroshi DOYU; Stephen Warren; Jiri Kosina; Kukjin Kim; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] iommuv2/amd: Enable Performance Counters On Family 15h Models 10h-1Fh

On Tue, Dec 04, 2012 at 04:19:06PM -0600, Steven Kinney wrote:
>  drivers/iommu/Kconfig           |   10 +++++
>  drivers/iommu/amd_iommu_init.c  |   85 +++++++++++++++++++++++++++++++++++++++
>  drivers/iommu/amd_iommu_types.h |   13 +++++-
>  3 files changed, 107 insertions(+), 1 deletion(-)

So first of all, this patch alone doesn't make sense. You should submit it in a patch-set that enabled IOMMUv2 performance counters for the end-user. This means together with the PMU implementation and tools support.

Further I don't see how this patch is specific to Family 15h Models 10h-1Fh as described in the subject-line.

Any comments on these two points?

Cheers,

	Joerg




