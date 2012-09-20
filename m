Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2ITAOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 20:14:10 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:54193
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162Ab2ITAOI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 20:14:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551bizbb2dI98dI9371I1432Id6f1izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd2bhf0ah107ah1288h12a5h12a9h12bdh1155h)
Date: Wed, 19 Sep 2012 19:14:02 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [RFC][PATCH 0/3] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
To: Kumar Gala <galak@kernel.crashing.org>
CC: "<b16395@freescale.com>" <b16395@freescale.com>, <joerg.roedel@amd.com>,
        <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Varun Sethi <Varun.Sethi@freescale.com>
In-Reply-To: <A6B66C5D-71EA-4E9F-8347-7413479BD3FC@kernel.crashing.org>
	(from galak@kernel.crashing.org on Wed Sep 19 08:49:14 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1348100042.22800.22@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 08:49:14 AM, Kumar Gala wrote:
> 
> On Sep 19, 2012, at 8:17 AM, <b16395@freescale.com>  
> <b16395@freescale.com> wrote:
> 
> > From: Varun Sethi <Varun.Sethi@freescale.com>
> >
> > This patchset provides the Freescale PAMU (Peripheral Access  
> Management Unit) driver
> > and the corresponding IOMMU API implementation. PAMU is the IOMMU  
> present on Freescale
> > QorIQ platforms. PAMU can authorize memory access, remap the memory  
> address, and remap
> > the I/O transaction type.
> >
> > This set consists of the following patches:
> > 1. Addition of new field in the device (powerpc) archdata structure  
> for storing iommu domain information
> >   pointer. This pointer is stored when the device is attached to a  
> particular iommu domain.
> > 2. Addition of domain attributes required by the PAMU driver IOMMU  
> API.
> > 3. PAMU driver and IOMMU API implementation.
> >
> > Varun Sethi (3):
> >  Store iommu domain information pointer in archdata.
> >  Add iommu domain attributes required by fsl PAMU driver.
> >  FSL PAMU driver and IOMMU API implementation.
> >
> > arch/powerpc/include/asm/device.h |    4 +
> > drivers/iommu/Kconfig             |    7 +
> > drivers/iommu/Makefile            |    1 +
> > drivers/iommu/fsl_pamu.c          | 1033  
> +++++++++++++++++++++++++++++++++++++
> > drivers/iommu/fsl_pamu.h          |  377 ++++++++++++++
> > drivers/iommu/fsl_pamu_domain.c   |  990  
> +++++++++++++++++++++++++++++++++++
> > drivers/iommu/fsl_pamu_domain.h   |   94 ++++
> > drivers/iommu/fsl_pamu_proto.h    |   49 ++
> > include/linux/iommu.h             |   30 ++
> > 9 files changed, 2585 insertions(+), 0 deletions(-)
> > create mode 100644 drivers/iommu/fsl_pamu.c
> > create mode 100644 drivers/iommu/fsl_pamu.h
> > create mode 100644 drivers/iommu/fsl_pamu_domain.c
> > create mode 100644 drivers/iommu/fsl_pamu_domain.h
> > create mode 100644 drivers/iommu/fsl_pamu_proto.h
> 
> I assume that another patch series will add device tree binding spec  
> and update device trees for SoCs with PAMU?

The device trees already have PAMU in them.  A binding would be nice,  
though.

-Scott
