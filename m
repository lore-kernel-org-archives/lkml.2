Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2GQKol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:44:41 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:17162
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425Ab2GQKoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:44:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz98dI1432Izz1202hzz15d4R8275bhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M7AWHO-01-6Q9-02
X-M-MSG: 
Date: Tue, 17 Jul 2012 12:44:24 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/27] iommu/amd: Fix sparse warnings
Message-ID: <20120717104424.GJ4213@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
 <1342013952-10174-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1342013952-10174-4-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 03:38:48PM +0200, Joerg Roedel wrote:
> A few sparse warnings fire in drivers/iommu/amd_iommu_init.c.
> Fix most of them with this patch. Also fix the sparse
> warnings in drivers/iommu/irq_remapping.c while at it.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

To reduce the size of this patch-set I queued the patches 3-11 for 3.6.
These patches rework IOMMU initialization and prepare for interrupt
remapping support.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

