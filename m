Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2IDGvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 02:51:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1532 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2IDGvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 02:51:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 03 Sep 2012 23:51:17 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 4 Sep 2012 08:51:34 +0200
Subject: Re: [v2 1/1] iommu/tegra: smmu: Use debugfs_create_dir for directory
Thread-Topic: [v2 1/1] iommu/tegra: smmu: Use debugfs_create_dir for
 directory
Thread-Index: Ac2KabpZ5Uzj32slQ5mSGdqvkSvSdw==
Message-ID: <20120904.095134.292349834288373260.hdoyu@nvidia.com>
References: <20120809155624.b781edae9efa7c51faf6c31c@nvidia.com><1345009652-13408-1-git-send-email-hdoyu@nvidia.com><502BCA9E.5090206@wwwdotorg.org>
In-Reply-To: <502BCA9E.5090206@wwwdotorg.org>
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

Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 15 Aug 2012 18:13:18 +0200:

> On 08/14/2012 11:47 PM, Hiroshi Doyu wrote:
> > The commit c3b1a35 "debugfs: make sure that debugfs_create_file() gets
> > used only for regulars" doesn't allow to use debugfs_create_file() for
> > dir. Keep debugfs data in smmu_device instead of directory's i_private.
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> 
> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> Since this fixes a BUG during kernel boot, it'd be great if this could
> be applied ASAP unless there are significant issues with it.

Joerg, any chance to get this in?
