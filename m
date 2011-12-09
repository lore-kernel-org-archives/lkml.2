Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1LIOnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:43:16 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:19791
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab1LIOnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:43:14 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVXY7V-02-07X-02
X-M-MSG: 
Date: Fri, 9 Dec 2011 15:43:04 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jerome Glisse <j.glisse@gmail.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/22] Initial AMD IOMMUv2 support
Message-ID: <20111209144304.GH3952@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
 <20111208204739.GC3179@homer.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111208204739.GC3179@homer.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 03:47:39PM -0500, Jerome Glisse wrote:
> On Mon, Dec 05, 2011 at 02:34:15PM +0100, Joerg Roedel wrote:
> > Hi,
> > 
> > here is a patch-set that adds initial support for the AMD IOMMU version
> > 2 to the Linux kernel. The main feature of the new IOMMU version is
> > support for DMA demand-paging and multiple DMA address spaces per
> > device.
> > The patch-set consists of 2 parts. Patches 1-16 implement the hardware
> > access functions to setup and manage the IOMMUv2 functionality of the
> > hardware. Patches 17-22 implement a seperate module which makes use
> > these functions to implement a page-fault handler for devices which can
> > be used by real device drivers.
> 
> What hw/chipset/CPU support this functionality ?

This functionality will be supported in our Trinity APUs and South
Islands GPUs, which will be shipping early next year. Official product
names for these APUs and GPUs have not yet been announced.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

