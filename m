Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2HCOKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:10:40 -0400
Received: from [216.32.181.185] ([216.32.181.185]:30435 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752921Ab2HCOKi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:10:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh1432Izz1202hzz8275dh15d4Iz2dh668h839h93fhd25he5bhf0ah)
X-WSS-ID: 0M86NCE-02-1FK-02
X-M-MSG: 
Date: Fri, 3 Aug 2012 16:09:55 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <kgene.kim@samsung.com>,
        <pullip.cho@samsung.com>, <patches@linaro.org>
Subject: Re: [PATCH] iommu/exynos: Fix build error
Message-ID: <20120803140955.GH1996@amd.com>
References: <1343811917-24054-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1343811917-24054-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 02:35:17PM +0530, Sachin Kamat wrote:
> Fixes the following build error introduced by commit 3177bb76a8
> ("iommu/exynos: Implement DOMAIN_ATTR_GEOMETRY attribute"):
> 
> drivers/iommu/exynos-iommu.c: In function ‘exynos_iommu_domain_init’:
> drivers/iommu/exynos-iommu.c:735:2: error: ‘dom’ undeclared
> (first use in this function)
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Applied to iommu/fixes, thanks Sachin.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

