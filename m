Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2KLHjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:39:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13649 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2KLHjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:39:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 11 Nov 2012 23:39:44 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "tipecaml@gmail.com" <tipecaml@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "joro@8bytes.org" <joro@8bytes.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Date: Mon, 12 Nov 2012 08:39:35 +0100
Subject: Re: [PATCH 2/3] iommu/tegra-smmu.c: fix dentry reference leak in
 smmu_debugfs_stats_show().
Thread-Topic: [PATCH 2/3] iommu/tegra-smmu.c: fix dentry reference leak in
 smmu_debugfs_stats_show().
Thread-Index: Ac3AqN9OagVdFXTQS3CqQXLQ5xcZMw==
Message-ID: <20121112.093935.1354253140075405263.hdoyu@nvidia.com>
References: <1352666971-13551-1-git-send-email-tipecaml@gmail.com><1352666971-13551-3-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1352666971-13551-3-git-send-email-tipecaml@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril Roelandt <tipecaml@gmail.com> wrote @ Sun, 11 Nov 2012 21:49:30 +0100:

> Call to d_find_alias() needs a corresponding dput().
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---

Thanks. Looks ok for me. Acked-by Hiroshi Doyu <hdoyu@nvidia.com>
