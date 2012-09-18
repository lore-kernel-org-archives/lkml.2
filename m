Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2IRKlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:41:42 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:13808
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581Ab2IRKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:41:40 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz8275bh15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAJKDA-01-7UX-02
X-M-MSG: 
Date: Tue, 18 Sep 2012 12:41:32 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] dma: tegra: move smmu.h into SMMU driver
Message-ID: <20120918104132.GH2505@amd.com>
References: <1346798175-28733-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346798175-28733-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 04:36:15PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> There's no need to place these defines into arch/arm/mach-tegra/include/.
> Move them into the SMMU driver to clean up mach-tegra, as a pre-requisite
> for single-zImage.

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

