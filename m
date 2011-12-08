Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1LHUnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:43:39 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65342 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1LHUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:43:36 -0500
Date: Thu, 8 Dec 2011 15:47:39 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/22] Initial AMD IOMMUv2 support
Message-ID: <20111208204739.GC3179@homer.localdomain>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 
> Any feedback appreciated.
> 
> Thanks,
> 
> 	Joerg
> 

What hw/chipset/CPU support this functionality ?

Cheers,
Jerome
