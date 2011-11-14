Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1KNO3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:29:19 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:25528 "EHLO
	AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753525Ab1KNO3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:29:18 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LUNMWM-02-CCL-02
X-M-MSG: 
Date: Mon, 14 Nov 2011 15:29:09 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Dave Airlie <airlied@linux.ie>
CC: David Woodhouse <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH] iommu/intel: Fix build failure with intel-gtt and
 !intel-iommu
Message-ID: <20111114142909.GF14704@amd.com>
References: <20111111134832.GI13213@amd.com>
 <1321019553.2027.47.camel@shinybook.infradead.org>
 <20111114132647.GD14704@amd.com>
 <alpine.DEB.2.00.1111141334340.8973@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111141334340.8973@skynet.skynet.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 01:35:13PM +0000, Dave Airlie wrote:
> 
> 
> > 
> > > But I'm fairly sure this was already noticed and a patch is on its way
> > > upstream already.
> > 
> > It is not yet fixed upstream. I plan to send fixes to Linus soon. Any
> > objection against me including this if its not fixed until then?
> 
> Does a08185a3eb658854b29c05bcbfac0f85038ffe9f in Linus tree not fix it?

Oops, tested the wrong tree. It is fixed indeed. Sorry for the noise :)


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

