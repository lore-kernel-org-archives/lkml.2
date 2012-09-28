Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2I1O1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:27:30 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:43118 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757365Ab2I1O13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:27:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz8275bh15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB2DHO-01-679-02
X-M-MSG: 
Date: Fri, 28 Sep 2012 16:27:26 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Borislav Petkov <bp@amd64.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] AMD, iommu: Fix features reporting
Message-ID: <20120928142726.GD4009@amd.com>
References: <1348842146-8707-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1348842146-8707-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 04:22:26PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> When the AMD IOMMU doesn't have extended features, an empty line
> gets issued in dmesg like so:
> 
> [    3.061417] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
> [    3.066757] 							<---
> [    3.068294] pci 0000:00:00.2: irq 72 for MSI/MSI-X
> [    3.081213] AMD-Vi: Lazy IO/TLB flushing enabled
> 
> Fix it.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Applied, thanks :)

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

