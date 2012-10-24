Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956Ab2JXPIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:08:49 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:6464 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934915Ab2JXPIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:08:47 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz8275bh15d4Iz2dh668h839h944hd25he5bhf0ah107ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14afh1504h1537h153bh1155h)
X-WSS-ID: 0MCEKQD-02-4PV-02
X-M-MSG: 
Date: Wed, 24 Oct 2012 17:08:36 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuah.khan@hp.com>
CC: <konrad.wilk@oracle.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <rob@landley.net>, <akpm@linux-foundation.org>,
        <stern@rowland.harvard.edu>, <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devel@linuxdriverproject.org>, <x86@kernel.org>,
        <shuahkhan@gmail.com>
Subject: Re: [PATCH v5] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20121024150836.GB2764@amd.com>
References: <1349716086.2674.20.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1349716086.2674.20.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:08:06AM -0600, Shuah Khan wrote:
> Add dma-debug interface debug_dma_mapping_error() to debug drivers that fail
> to check dma mapping errors on addresses returned by dma_map_single() and
> dma_map_page() interfaces. This interface clears a flag set by
> debug_dma_map_page() to indicate that dma_mapping_error() has been called by
> the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
> this flag is still set, prints warning message that includes call trace that
> leads up to the unmap. This interface can be called from dma_mapping_error()
> routines to enable dma mapping error check debugging.
> 
> Tested: Intel iommu and swiotlb (iommu=soft) on x86-64 with
>         CONFIG_DMA_API_DEBUG enabled and disabled.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

