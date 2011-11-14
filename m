Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1KNN05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 08:26:57 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:3987
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112Ab1KNN0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 08:26:55 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zz936eK1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LUNK0Q-01-7DX-02
X-M-MSG: 
Date: Mon, 14 Nov 2011 14:26:47 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: David Airlie <airlied@linux.ie>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH] iommu/intel: Fix build failure with intel-gtt and
 !intel-iommu
Message-ID: <20111114132647.GD14704@amd.com>
References: <20111111134832.GI13213@amd.com>
 <1321019553.2027.47.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321019553.2027.47.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Okay, I change this to 0 in my patch.

> But I'm fairly sure this was already noticed and a patch is on its way
> upstream already.

It is not yet fixed upstream. I plan to send fixes to Linus soon. Any
objection against me including this if its not fixed until then?


	Joerg


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

