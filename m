Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2IQQ2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:28:13 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:6286 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab2IQQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:28:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zz98dId6f1izz1202h1d1ah1d2ahzzz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAI5QR-02-0EQ-02
X-M-MSG: 
Date: Mon, 17 Sep 2012 18:28:02 +0200
From: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 1/1] iommu/tegra: smmu: Use debugfs_create_dir for directory
Message-ID: <20120917162802.GA2505@amd.com>
References: <20120809155624.b781edae9efa7c51faf6c31c@nvidia.com>
 <1345009652-13408-1-git-send-email-hdoyu@nvidia.com>
 <502BCA9E.5090206@wwwdotorg.org>
 <20120904.095134.292349834288373260.hdoyu@nvidia.com>
 <504E3046.9080103@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <504E3046.9080103@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:24:06PM -0600, Stephen Warren wrote:

> Joerg, could you please apply this patch ASAP? Currently, Tegra won't
> boot in linux-next without it. Alternatively, would you like me to take
> the patch through the Tegra tree? Thanks.

Sorry, I had some vacation. But I am back now and will apply the patch
ASAP.


	Joerg


