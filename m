Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2IRKhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:37:25 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:2141
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195Ab2IRKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:37:23 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz8275bh15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAJK65-02-D21-02
X-M-MSG: 
Date: Tue, 18 Sep 2012 12:37:15 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH REPOST] iommu/tegra: smmu: Use debugfs_create_dir for
 directory
Message-ID: <20120918103715.GG2505@amd.com>
References: <1347639720-2991-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347639720-2991-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:22:00AM -0600, Stephen Warren wrote:
> From: Hiroshi Doyu <hdoyu@nvidia.com>
> 
> The commit c3b1a35 "debugfs: make sure that debugfs_create_file() gets
> used only for regulars" doesn't allow to use debugfs_create_file() for
> dir. Keep debugfs data in smmu_device instead of directory's i_private.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

