Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2KYNV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 08:21:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:42478 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab2KYNVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 08:21:25 -0500
Subject: Re: [PATCH 2/4] iommu/fsl: Add PAMU bypass enable register to ccsr_guts structure.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1353419697-31269-3-git-send-email-Varun.Sethi@freescale.com>
Date: Sun, 25 Nov 2012 07:21:15 -0600
Cc: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <timur@freescale.com>
Content-Transfer-Encoding: 7bit
Message-Id: <44C37358-9372-42E1-830A-6F59B2403B31@kernel.crashing.org>
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com> <1353419697-31269-3-git-send-email-Varun.Sethi@freescale.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 20, 2012, at 7:54 AM, Varun Sethi wrote:

> PAMU bypass enable register added to the ccsr_guts structure.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> arch/powerpc/include/asm/fsl_guts.h |    4 +++-
> 1 files changed, 3 insertions(+), 1 deletions(-)

applied to next

- k
