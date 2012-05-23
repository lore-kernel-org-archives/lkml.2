Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab2EWKEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:04:55 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37795 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab2EWKEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:04:52 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M4H000-01-5DK-02
X-M-MSG: 
Date: Wed, 23 May 2012 12:04:54 +0200
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <iommu@lists.linux-foundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [PATCH] iommu/core: pass a user-provided token to fault handlers
Message-ID: <20120523100454.GI2604@amd.com>
References: <1337620805-30217-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337620805-30217-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 08:20:05PM +0300, Ohad Ben-Cohen wrote:
> Sometimes a single IOMMU user may have to deal with several
> different IOMMU devices (e.g. remoteproc).
> 
> When an IOMMU fault happens, such users have to regain their
> context in order to deal with the fault.
> 
> Users can't use the private fields of neither the iommu_domain nor
> the IOMMU device, because those are already used by the IOMMU core
> and low level driver (respectively).
> 
> This patch just simply allows users to pass a private token (most
> notably their own context pointer) to iommu_set_fault_handler(),
> and then makes sure it is provided back to the users whenever
> an IOMMU fault happens.
> 
> The patch also adopts remoteproc to the new fault handling
> interface, but the real functionality using this (recovery of
> remote processors) will only be added later in a subsequent patch
> set.
> 
> Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Applied, thanks.


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

