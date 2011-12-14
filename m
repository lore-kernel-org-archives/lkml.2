Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1LNO0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:26:35 -0500
Received: from 8bytes.org ([88.198.83.132]:57970 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab1LNO0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:26:34 -0500
Date: Wed, 14 Dec 2011 15:26:32 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/22] Initial AMD IOMMUv2 support
Message-ID: <20111214142632.GA4475@8bytes.org>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 02:34:15PM +0100, Joerg Roedel wrote:
> Hi,
> 
> here is a patch-set that adds initial support for the AMD IOMMU version
> 2 to the Linux kernel. The main feature of the new IOMMU version is
> support for DMA demand-paging and multiple DMA address spaces per
> device.
> The patch-set consists of 2 parts. Patches 1-16 implement the hardware
> access functions to setup and manage the IOMMUv2 functionality of the
> hardware. Patches 17-22 implement a seperate module which makes use
> these functions to implement a page-fault handler for devices which can
> be used by real device drivers.

Removed patch 2 because it is unnecessary. Applied the rest to x86/amd.

