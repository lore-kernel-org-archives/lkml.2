Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0HBHpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:45:21 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16190
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213Ab0HBHpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:45:18 -0400
X-SpamScore: -36
X-BigFish: VS-36(zz1432N98dN936eM1447Rzz1202hzz15d4Rz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6ILJ6-02-0Y3-02
X-M-MSG: 
Date: Mon, 2 Aug 2010 09:48:12 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100802074812.GM24084@amd.com>
References: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
 <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org>
 <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
 <201007291026.55928.arnd@arndb.de>
 <1280546124.1902.30.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1280546124.1902.30.camel@pasglop>
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

On Fri, Jul 30, 2010 at 11:15:24PM -0400, Benjamin Herrenschmidt wrote:
> On Thu, 2010-07-29 at 10:26 +0200, Arnd Bergmann wrote:
> > Exactly, thanks for the clarification. I also didn't realize that
> > there
> > is now an include/linux/iommu.h file that only describes the PCI
> > SR-IOV
> > interfaces, unlike the generic IOMMU support that we have in your
> > include/linux/dma-mapping.h file.
> > 
> > Maybe we should rename linux/iommu.h to something more specific so we
> > can reduce this confusion in the future.
> 
> Hrm, indeed I just noticed that. Pretty gross... it should definitly be
> renamed, is will caused endless confusion with unrelated iommu.h and
> iommu_* interfaces which represent something different.

The first direction to go should be trying to unify all the different
iommu* interfaces into the iommu-api. The generic api will definitly
need to be extended for that, but since it is an in-kernel interface
thats no problem.

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

