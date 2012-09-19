Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2ISNt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:49:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:59778 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab2ISNt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:49:26 -0400
Subject: Re: [RFC][PATCH 0/3] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1348060632-12997-1-git-send-email-b16395@freescale.com>
Date: Wed, 19 Sep 2012 08:49:14 -0500
Cc: <iommu@lists.linux-foundation.org>, <joerg.roedel@amd.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A6B66C5D-71EA-4E9F-8347-7413479BD3FC@kernel.crashing.org>
References: <1348060632-12997-1-git-send-email-b16395@freescale.com>
To: "<b16395@freescale.com>" <b16395@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 19, 2012, at 8:17 AM, <b16395@freescale.com> <b16395@freescale.com> wrote:

> From: Varun Sethi <Varun.Sethi@freescale.com>
> 
> This patchset provides the Freescale PAMU (Peripheral Access Management Unit) driver
> and the corresponding IOMMU API implementation. PAMU is the IOMMU present on Freescale
> QorIQ platforms. PAMU can authorize memory access, remap the memory address, and remap 
> the I/O transaction type.
> 
> This set consists of the following patches:
> 1. Addition of new field in the device (powerpc) archdata structure for storing iommu domain information
>   pointer. This pointer is stored when the device is attached to a particular iommu domain.
> 2. Addition of domain attributes required by the PAMU driver IOMMU API.
> 3. PAMU driver and IOMMU API implementation.
> 
> Varun Sethi (3):
>  Store iommu domain information pointer in archdata.
>  Add iommu domain attributes required by fsl PAMU driver.
>  FSL PAMU driver and IOMMU API implementation.
> 
> arch/powerpc/include/asm/device.h |    4 +
> drivers/iommu/Kconfig             |    7 +
> drivers/iommu/Makefile            |    1 +
> drivers/iommu/fsl_pamu.c          | 1033 +++++++++++++++++++++++++++++++++++++
> drivers/iommu/fsl_pamu.h          |  377 ++++++++++++++
> drivers/iommu/fsl_pamu_domain.c   |  990 +++++++++++++++++++++++++++++++++++
> drivers/iommu/fsl_pamu_domain.h   |   94 ++++
> drivers/iommu/fsl_pamu_proto.h    |   49 ++
> include/linux/iommu.h             |   30 ++
> 9 files changed, 2585 insertions(+), 0 deletions(-)
> create mode 100644 drivers/iommu/fsl_pamu.c
> create mode 100644 drivers/iommu/fsl_pamu.h
> create mode 100644 drivers/iommu/fsl_pamu_domain.c
> create mode 100644 drivers/iommu/fsl_pamu_domain.h
> create mode 100644 drivers/iommu/fsl_pamu_proto.h

I assume that another patch series will add device tree binding spec and update device trees for SoCs with PAMU?

- k

