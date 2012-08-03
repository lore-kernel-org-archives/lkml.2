Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2HCOIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:08:07 -0400
Received: from [216.32.180.189] ([216.32.180.189]:51889 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab2HCOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:08:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202hzz15d4Iz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M86N6P-02-17M-02
X-M-MSG: 
Date: Fri, 3 Aug 2012 16:06:29 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: David Woodhouse <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers/iommu/intel-iommu.c: add missing
 free_domain_mem
Message-ID: <20120803140628.GD1996@amd.com>
References: <1343139494-26998-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1343139494-26998-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 04:18:14PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Add missing free_domain_mem on failure path after alloc_domain.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied to iommu/fixes, thanks Julia.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

