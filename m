Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2KQM0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:26:14 -0500
Received: from 8bytes.org ([85.214.48.195]:55083 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab2KQM0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:26:13 -0500
Date: Sat, 17 Nov 2012 13:26:10 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        joerg.roedel@amd.com, hdoyu@nvidia.com, swarren@nvidia.com
Subject: Re: [PATCH 2/3] iommu/tegra-smmu.c: fix dentry reference leak in
 smmu_debugfs_stats_show().
Message-ID: <20121117122610.GA11220@8bytes.org>
References: <1352666971-13551-1-git-send-email-tipecaml@gmail.com>
 <1352666971-13551-3-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352666971-13551-3-git-send-email-tipecaml@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Nov 17 13:26:12 2012
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50a7826422976549718400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 09:49:30PM +0100, Cyril Roelandt wrote:
> Call to d_find_alias() needs a corresponding dput().
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

Applied to iommu/fixes, thanks.

