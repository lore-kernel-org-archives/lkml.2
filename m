Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab2JDNVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:21:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:42840 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab2JDNVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:21:18 -0400
Subject: Re: [PATCH 3/3 v2] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1349351808-7156-4-git-send-email-b16395@freescale.com>
Date: Thu, 4 Oct 2012 08:20:25 -0500
Cc: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <91BA7E6D-4B29-4CCF-80EB-947EBBCF51F4@kernel.crashing.org>
References: <1349351808-7156-1-git-send-email-b16395@freescale.com> <1349351808-7156-4-git-send-email-b16395@freescale.com>
To: "<b16395@freescale.com>" <b16395@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 4, 2012, at 6:56 AM, <b16395@freescale.com> <b16395@freescale.com> wrote:

> From: Varun Sethi <Varun.Sethi@freescale.com>
> 
> Following is a brief description of the PAMU hardware:
> PAMU determines what action to take and whether to authorize the action on the basis
> of the memory address, a Logical IO Device Number (LIODN), and PAACT table (logically)
> indexed by LIODN and address. Hardware devices which need to access memory must provide
> an LIODN in addition to the memory address.
> 
> Peripheral Access Authorization and Control Tables (PAACTs) are the primary data structures
> used by PAMU. A PAACT is a table of peripheral access authorization and control entries (PAACE).
> Each PAACE defines the range of I/O bus address space that is accessible by the LIOD and the
> associated access capabilities.
> 
> There are two types of PAACTs: primary PAACT (PPAACT) and secondary PAACT (SPAACT). A given physical
> I/O device may be able to act as one or more independent logical I/O devices (LIODs). Each such
> logical I/O device is assigned an identifier called logical I/O device number (LIODN). A LIOD is
> allocated a contiguous portion of the I/O bus address space called the DSA window for performing
> DSA operations. The DSA window may optionally be divided into multiple sub-windows, each of which
> may be used to map to a region in system storage space. The first sub-window is referred to
> as the primary sub-window and the remaining are called secondary sub-windows.
> 
> This patch provides the PAMU driver (fsl_pamu.c) and the corresponding IOMMU API implementation
> (fsl_pamu_domain.c). The PAMU hardware driver (fsl_pamu.c) has been derived from the work done
> by Ashish Kalra and Timur Tabi (timur@freescale.com).
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---

I'm not seeing any of the comments I made addressed.

What changed in this version?

- k