Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1KHRnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:43:33 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16867 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab1KHRnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:43:32 -0500
X-SpamScore: -26
X-BigFish: VPS-26(zz1b0bM1432N98dK4015Lzz1202hzz15d4R8275eh8275bha1495iz32i668h839h944h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LUCRVW-02-12T-02
X-M-MSG: 
Date: Tue, 8 Nov 2011 18:43:08 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Kevin Hilman <khilman@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: cpuidle34xx.c: Fix compile error
Message-ID: <20111108174308.GG5182@amd.com>
References: <1320768665-9759-1-git-send-email-joerg.roedel@amd.com>
 <87hb2eqzwv.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87hb2eqzwv.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 09:36:48AM -0800, Kevin Hilman wrote:
> Joerg Roedel <joerg.roedel@amd.com> writes:
> 
> > Add missing module.h include to provide THIS_MODULE.
> >
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> FYI...
> 
> Tony has already queued fix for this in his fixes branch.
> 
>      http://marc.info/?l=linux-arm-kernel&m=132071036621713&w=2

Great. I stumbled over it while compile-testing the iommu-tree for omap.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

