Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2KEWFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:05:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:31477 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab2KEWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:05:45 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z551biz98dId799hzz1de0h1202h1d1ah1d2ahzz8275chz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
Message-ID: <50983834.30403@freescale.com>
Date: Mon, 5 Nov 2012 16:05:40 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Firefox/16.0 SeaMonkey/2.13.1
MIME-Version: 1.0
To: Varun Sethi <Varun.Sethi@freescale.com>
CC: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>
Subject: Re: [PATCH 0/4] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
References: <1352114361-25192-1-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1352114361-25192-1-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Varun Sethi wrote:
> This patchset provides the Freescale PAMU (Peripheral Access Management Unit) driver
> and the corresponding IOMMU API implementation. PAMU is the IOMMU present on Freescale
> QorIQ platforms. PAMU can authorize memory access, remap the memory address, and remap 
> the I/O transaction type.

You forgot to send post these patches to
linuxppc-release@linux.freescale.net.  May I suggest the following

git-send-email ... --bcc linuxppc-release@linux.freescale.net ...

whenever you post a patch upstream?

> This set consists of the following patches:
> 1. Addition of new field in the device (powerpc) archdata structure for storing iommu domain information
>    pointer. This pointer is stored when the device is attached to a particular iommu domain.
> 2. Add PAMU bypass enable register to the ccsr_guts structure.

I don't see patch 2/4 posted anywhere.

-- 
Timur Tabi
Linux kernel developer at Freescale

