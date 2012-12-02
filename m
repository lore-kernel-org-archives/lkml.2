Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2LBVzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 16:55:18 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:42000
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909Ab2LBVzQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 16:55:16 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371Id6eah542I1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1155h)
X-WSS-ID: 0MEFBJY-01-L8R-02
X-M-MSG: 
From: "Kinney, Steven" <Steven.Kinney@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <bhelgaas@google.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>
Subject: RE: [PATCH 1/1] iommuv2/amd: Enable Performance Counters On Family
 15h Models 10h-1Fh
Thread-Topic: [PATCH 1/1] iommuv2/amd: Enable Performance Counters On Family
 15h Models 10h-1Fh
Thread-Index: AQHNzCFxJzN8N1lD3UiS0yp4j155nZgF7rIAgAAlTbA=
Date: Sun, 2 Dec 2012 21:55:09 +0000
Message-ID: <57D41218901B4442B4AFF404D215911636ABC6@sausexdag02.amd.com>
References: <1353967225-18742-1-git-send-email-steven.kinney@amd.com>
 <20121202133026.GN30633@8bytes.org>
In-Reply-To: <20121202133026.GN30633@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.226.128.3]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

                  I didn't want to expose the internals of the IOMMU, so I decided to export the function(s) so that the perf IOMMUv2 PMU can make call(s) into the IOMMU core to request PC resources.  The perf_event_amd_iommuv2.h defines the prototype for the added PC functionality.  I have the perf IOMMUv2 PMU working and counting IOMMUv2 PC events using this interface, but if  you have a suggestion to make this implementation more robust, I will accommodate the suggestion.  Also, if it would be helpful, I can submit the perf IOMMUv2 PMU patches.  

BTW, I am resubmitting this patch since I caught a function signature error; was changing the code based on Boris's suggestion(s) and forgot to add the variable type (bool) concerning the 'is_write' parameter.

Hope all is well with you and the team; we miss you guys!

Regards,

Steve

-----Original Message-----
From: Joerg Roedel [mailto:joro@8bytes.org] 
Sent: Sunday, December 02, 2012 7:30 AM
To: Kinney, Steven
Cc: Joerg Roedel; Kukjin Kim; Stephen Warren; Jiri Kosina; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] iommuv2/amd: Enable Performance Counters On Family 15h Models 10h-1Fh

On Mon, Nov 26, 2012 at 04:00:25PM -0600, Steven Kinney wrote:
> From: "Steven L. Kinney" <steven.kinney@amd.com>
> 
> Add Kernel configuration selection for AMD IOMMUv2 performance 
> counters.

How can the counters be used?


	Joerg




