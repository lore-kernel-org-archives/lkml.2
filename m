Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423127Ab2LFKcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:32:43 -0500
Received: from 8bytes.org ([85.214.48.195]:50644 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423041Ab2LFKcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:32:42 -0500
Date: Thu, 6 Dec 2012 11:32:38 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Steven Kinney <steven.kinney@amd.com>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Jiri Kosina <jkosina@suse.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] iommuv2/amd: Enable Performance Counters On Family
 15h Models 10h-1Fh
Message-ID: <20121206103238.GF1806@8bytes.org>
References: <1354659546-9700-1-git-send-email-steven.kinney@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354659546-9700-1-git-send-email-steven.kinney@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Dec  6 11:32:40 2012
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50c0744822971423638872
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 04:19:06PM -0600, Steven Kinney wrote:
>  drivers/iommu/Kconfig           |   10 +++++
>  drivers/iommu/amd_iommu_init.c  |   85 +++++++++++++++++++++++++++++++++++++++
>  drivers/iommu/amd_iommu_types.h |   13 +++++-
>  3 files changed, 107 insertions(+), 1 deletion(-)

So first of all, this patch alone doesn't make sense. You should submit
it in a patch-set that enabled IOMMUv2 performance counters for the
end-user. This means together with the PMU implementation and tools
support.

Further I don't see how this patch is specific to Family 15h Models
10h-1Fh as described in the subject-line.

Any comments on these two points?

Cheers,

	Joerg


