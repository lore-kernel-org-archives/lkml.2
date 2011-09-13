Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1IMPPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:15:34 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:11095
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab1IMPPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:15:33 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRGVPN-02-693-02
X-M-MSG: 
Date: Tue, 13 Sep 2011 17:15:24 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Greg KH <gregkh@suse.de>
CC: Joerg Roedel <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110913151524.GN11701@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de>
 <20110907191919.GA31674@8bytes.org>
 <20110907194445.GA2526@suse.de>
 <20110913145402.GM11701@amd.com>
 <20110913145855.GA4581@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110913145855.GA4581@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 10:58:55AM -0400, Greg KH wrote:
> On Tue, Sep 13, 2011 at 04:54:02PM +0200, Roedel, Joerg wrote:
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -22,6 +22,7 @@
> >  #include <linux/types.h>
> >  #include <linux/module.h>
> >  #include <linux/pm.h>
> > +#include <linux/iommu.h>
> 
> Ick, please don't add new #includes to device.h, it makes the whole
> build slower.  Just pre-declare the structure and all should be fine.

Okay, will do. Thanks.

> Don't you need to also redo the other patches in this series based on
> the other comments you received?

Unless I have missed something I am not aware of other comments that
need action by now.
Sethi pointed out that the KVM device assignment code needs rework to be
usable outside of PCI too. But that work is already underway with Alex
Williamson's VFIO framework and not scope of this patch-set.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

