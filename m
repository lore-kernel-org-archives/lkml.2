Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2FFLG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:06:59 -0400
Received: from [213.199.154.142] ([213.199.154.142]:54353 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755899Ab2FFLG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:06:57 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: VPS-14(zz98dK4015Izz1202hzz15d4Rz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M5704Q-01-2LT-02
X-M-MSG: 
Date: Wed, 6 Jun 2012 13:05:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <bhelgaas@google.com>, <benh@kernel.crashing.org>, <aik@ozlabs.ru>,
        <david@gibson.dropbear.id.au>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <ddutile@redhat.com>, <liuj97@gmail.com>
Subject: Re: [PATCH v2 0/7] IOMMU: Groups support
Message-ID: <20120606110514.GG757@amd.com>
References: <20120530201424.31527.33142.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120530201424.31527.33142.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 02:18:29PM -0600, Alex Williamson wrote:
> v2:
>  - Trickle down changes from pci_get_dma_source() to better handle
>    PCI device reference counting in IOMMU driver patches

Okay, I looked again over the code and looks good for merging to me. The
IOMMU Groups code depends on changes in the PCI code. We need to work
out how to merge this.

Bjorn,

I need the PCI changes before I can merge the IOMMU Groups code. There
are two ways that would work for me:

	a) You Ack the PCI patch-set from Alex and I put it into my tree
	   and merge the IOMMU Group code on-top, or
	b) You merge the PCI related patch-set into a seperate branch
	   which you can merge into your next-branch and which I can
	   pull in to merge IOMMU Groups on-top.

Please let me know what works best for you.

What I would also appreciate are a few more Acks from other IOMMU
maintainers (David W.?) and from the Power side.


Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

