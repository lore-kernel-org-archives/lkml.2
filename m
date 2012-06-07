Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2FGJcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:32:43 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:3907
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760433Ab2FGJcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:32:41 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -20
X-BigFish: VPS-20(zz1432N98dK4015Izz1202hzz15d4R8275bhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M58QI9-02-8B1-02
X-M-MSG: 
Date: Thu, 7 Jun 2012 11:32:35 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuah.khan@hp.com>
CC: <iommu@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] iommu/amd: Fix missing iommu_shutdown initialization
 in passthrough mode
Message-ID: <20120607093235.GK757@amd.com>
References: <1339001406.2763.49.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339001406.2763.49.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:50:06AM -0600, Shuah Khan wrote:
> Change AMD iommu driver to call disable iommus in pass-through mode. AMD
> iommu driver's amd_iommu_init() routine doesn't initialize iommu_shutdown
> in pass-through mode. As a result iommu disable via a call to disable_iommus()
> doesn't happen at shutdown. Enable and disable of iommus is inconsistent in
> pass-through mode. IOMMU is enabled, but not disabled. IOMMU disable is called
> from error legs in amd_iommu_init() in pass-through mode.
> 
> Requesting for comments as I don't have access to AMD system that supports
> IOMMU. I tested the change on AMD platforms with GART IOMMU which is not
> sufficient.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

The patch is fine. Thanks, applied to iommu/fixes.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

