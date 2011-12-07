Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1LGSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:16:26 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:32676
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855Ab1LGSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:16:25 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVUIR6-02-EV4-02
X-M-MSG: 
Date: Wed, 7 Dec 2011 19:12:56 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Brown <davidb@codeaurora.org>
CC: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu/msm: Fix compile error in mach-msm/devices-iommu.c
Message-ID: <20111207181256.GA2181@amd.com>
References: <20111206102527.GI25178@amd.com>
 <20111207170024.GA23621@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111207170024.GA23621@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 09:00:24AM -0800, David Brown wrote:
> On Tue, Dec 06, 2011 at 11:25:27AM +0100, Joerg Roedel wrote:
> 
> > I just added a patch to my iommu/fixes branch to fix a compile error
> > with IOMMU enabled. If there is another fix for this already somewhere
> > please let me know the commit-id so that I can add it to my out-of-tree
> > branch. If there is no other fix yet I will push this upstream soon with
> > the next round of iommu-fixes.
> 
> You can go ahead and push this fix through your tree.  I'll enable the
> iommu in my defconfigs so that I start catching things like this as
> well.

Great, Thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

