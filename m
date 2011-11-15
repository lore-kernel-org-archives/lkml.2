Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1KOLKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:10:40 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16625 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab1KOLKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:10:39 -0500
X-SpamScore: -25
X-BigFish: VPS-25(zz9371K1432N98dK4015Lzz1202hzz15d4R8275bhz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LUP8CS-01-2W9-02
X-M-MSG: 
Date: Tue, 15 Nov 2011 12:10:01 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 0/5] OMAP groundwork for IOMMU-based DMA API
Message-ID: <20111115111001.GB5627@amd.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
 <20111115103926.GA5627@amd.com>
 <CAK=WgbZ=0HctjLREv1oXEa=5ryY7C_6srO1Nt5uMowH+FyaHJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbZ=0HctjLREv1oXEa=5ryY7C_6srO1Nt5uMowH+FyaHJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 12:45:33PM +0200, Ohad Ben-Cohen wrote:
> Hi Joerg,
> 
> On Tue, Nov 15, 2011 at 12:39 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > It doesn't apply cleanly, can you please rebase the code, collect the
> > Acked-by's and resend?
> 
> Sure. I planned on resending after the "hardware pgsize" patches are
> merged, but please tell me if you prefer it the other way around.

It is almost merged :) I just had to struggle with some compile errors
from upstream in my tests. But I think I will finish testing today and
push everything out.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

