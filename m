Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0G2JGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:06:45 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20181 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab0G2JGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:06:41 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz15d4Rz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6BAHP-01-6P0-02
X-M-MSG: 
Date: Thu, 29 Jul 2010 11:06:08 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100729090607.GN26098@amd.com>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
 <201007291026.55928.arnd@arndb.de>
 <20100729084018.GM26098@amd.com>
 <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 04:46:59AM -0400, FUJITA Tomonori wrote:
> On Thu, 29 Jul 2010 10:40:19 +0200
> "Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:
> 
> > The IOMMU-API is not about SR-IOV.
> 
> That's true. However, the point is that include/iommu.h is far from
> the IOMMU-API.
> 
> You could still insist that include/iommu.h is designed for the
> generic IOMMU-API. But the fact is that it's designed for very
> specific purposes. No intention to make it for generic purposes.

I have no clue about the ARM iommus on the omap-platform. From a quick
look into the header file I see some similarities to the IOMMU-API. I am
also very open for discussions about how the IOMMU-API could be extended
to fit the needs of other platforms. Only because nobody has tried to
discuss about such an effort is no reason to push the IOMMU-API back.

> 
> Since you added it two years ago, nobody has tried to extend
> it. Instead, we have something like
> arch/arm/plat-omap/include/plat/iommu.h.

And I think we should try to merge this platform-specific functionality
into the IOMMU-API.

	Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

