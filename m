Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0HMX2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:28:41 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:44952 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754313Ab0HMX2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:28:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=upr2i2+X9a1zgOfNuT7PhtiIshMSLDRL1opyP+6Jjj65JCN2sdLC2pCZTTIpMuNfpipABfBw6lJ6qN/gRAOpRHWMHyHNrlr+QvxEwB4K4hGLPeR+kUGW3Lr2gn9B6t0r;
Date: Fri, 13 Aug 2010 16:28:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        alex.williamson@redhat.com, Alex Nixon <alex.nixon@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Wilcox <willy@linux.intel.com>, Qing He <qing.he@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH 17/20] xen/x86/PCI: Add support for the Xen PCI
 subsystem
Message-ID: <20100813162835.12ec7286@virtuousgeek.org>
In-Reply-To: <1280945955-14229-18-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
	<1280945955-14229-18-git-send-email-konrad.wilk@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Aug 2010 14:19:12 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> From: Alex Nixon <alex.nixon@citrix.com>
> 
> The frontend stub lives in arch/x86/pci/xen.c, alongside other
> sub-arch PCI init code (e.g. olpc.c).
> 
> It provides a mechanism for Xen PCI frontend to setup/destroy
> legacy interrupts, MSI/MSI-X, and PCI configuration operations.
> 
> [ Impact: add core of Xen PCI support ]
> [ v2: Removed the IOMMU code and only focusing on PCI. Dropping:
> drivers/pci/Makefile, drivers/pci/xen-iommu.c, arch/x86/kernel/pci-dma.c
> and arch/x86/include/asm/xen/iommu.h]
> [ v3: removed usage of pci_scan_all_fns as that does not exist]
> [ v4: introduced pci_xen value to fix compile warnings]
> [ v5: squished fixes+features in one patch, changed Reviewed-by to Ccs]
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: Qing He <qing.he@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---

Fine with me if this stuff goes in with the rest of the Xen bits,
presumably through the x86 tree.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
