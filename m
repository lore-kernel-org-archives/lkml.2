Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab1KKOY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:24:29 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:45820
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab1KKOY2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:24:28 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zzc89bh936eK1432N98dKzz1202hzz15d4Rz32i668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LUI2OG-01-6OJ-02
X-M-MSG: 
Date: Fri, 11 Nov 2011 15:24:16 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: David Airlie <airlied@linux.ie>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH] iommu/intel: Fix build failure with intel-gtt and
 !intel-iommu
Message-ID: <20111111142416.GK13213@amd.com>
References: <20111111134832.GI13213@amd.com>
 <1321019553.2027.47.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1321019553.2027.47.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 01:52:33PM +0000, David Woodhouse wrote:
> On Fri, 2011-11-11 at 14:48 +0100, Joerg Roedel wrote:
> > +#define intel_iommu_gfx_mapped 1 
> 
> That ought to be zero; if the IOMMU code isn't present, it's
> *definitely* not mapped through the IOMMU :)
> 
> But I'm fairly sure this was already noticed and a patch is on its way
> upstream already.
> 
> It's my fault — my original testing patches to expose this information
> from the IOMMU code did put it into a header file, but when I sent it
> upstream I missed that part of the patch, thus leading to the horrid
> 'extern int intel_iommu_gfx_mapped;' in intel-gtt.c that your patch
> removes.

No problem, it was easy to fix :) I'll keep that patch in my out-of-tree
branch until it is fixed upstream.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

