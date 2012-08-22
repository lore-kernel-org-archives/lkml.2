Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab2HVQRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:17:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:48826 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757776Ab2HVQRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:17:04 -0400
Subject: Re: [PATCH] DMA/RaidEngine: Enable FSL RaidEngine
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1345616661-8550-1-git-send-email-b29237@freescale.com>
Date: Wed, 22 Aug 2012 08:37:12 -0500
Cc: <dan.j.williams@gmail.com>, <vinod.koul@intel.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Harninder Rai <harninder.rai@freescale.com>, b01044@freescale.com,
        iws@ovro.caltech.edu, Naveen Burmi <naveenburmi@freescale.com>,
        b16502@freescale.com
Content-Transfer-Encoding: 8BIT
Message-Id: <D8BA9BE9-CC8A-41EE-B6A6-404682EF78D3@kernel.crashing.org>
References: <1345616661-8550-1-git-send-email-b29237@freescale.com>
To: "<b29237@freescale.com>" <b29237@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 22, 2012, at 1:24 AM, <b29237@freescale.com> <b29237@freescale.com> wrote:

> From: Xuelin Shi <b29237@freescale.com>
> 
> The RaidEngine is a new FSL hardware that used as hardware acceration
> for RAID5/6.
> 
> This patch enables the RaidEngine functionality and provides hardware
> offloading capability for memcpy, xor and raid6 pq computation. It works
> under dmaengine control with async_layer interface.
> 
> Signed-off-by: Harninder Rai <harninder.rai@freescale.com>
> Signed-off-by: Naveen Burmi <naveenburmi@freescale.com>
> Signed-off-by: Xuelin Shi <b29237@freescale.com>
> ---
> arch/powerpc/boot/dts/fsl/p5020si-post.dtsi    |    1 +
> arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi     |    6 +
> arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi |   85 ++
> drivers/dma/Kconfig                            |   14 +
> drivers/dma/Makefile                           |    1 +
> drivers/dma/fsl_raid.c                         | 1090 ++++++++++++++++++++++++
> drivers/dma/fsl_raid.h                         |  294 +++++++
> 7 files changed, 1491 insertions(+), 0 deletions(-)
> create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi
> create mode 100644 drivers/dma/fsl_raid.c
> create mode 100644 drivers/dma/fsl_raid.h

Where is the dts binding spec related to qoriq-raid1.0-0.dtsi ?

We should split the device tree parts into a separate patch as they can be reviewed & accepted separate from the driver code.

- k