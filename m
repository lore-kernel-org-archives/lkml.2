Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1I0LAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:00:38 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16693 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1I0LAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:00:36 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LS6H8E-01-74C-02
X-M-MSG: 
Date: Tue, 27 Sep 2011 13:00:12 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] iommu/omap: Use bus_set_iommu instead of
 register_iommu
Message-ID: <20110927110012.GJ2138@amd.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-9-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbbZKa2orya_ijJ3vBeyERN2FYCKaSyn8gs=qsqJRC=kbQ@mail.gmail.com>
 <20110926122213.GC2138@amd.com>
 <CAK=WgbYvACc4U58WTxdndKtHgA0TxV-wFmO8bQLD65yuz_Hk0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbYvACc4U58WTxdndKtHgA0TxV-wFmO8bQLD65yuz_Hk0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 08:29:04AM -0400, Ohad Ben-Cohen wrote:
> On Mon, Sep 26, 2011 at 3:22 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > That is interesting. What bus do these IOMMU users you talk about belong
> > to?
> 
> E.g., virtio devices (which today originates from a platform device)
> or even rpmsg users (which originates from the former virtio devices).
> 
> > Is it a seperate bus that originates from a platform device?
> 
> Yes.
> 
> > in that
> > case the situation sounds a little bit like with USB on x86. The usb
> > controlers are PCI devices and DMA handles are allocated using the
> > pci_dev of the controler and not the usb_device.
> 
> Yeah, sounds very similar.

The question is, of course, if the IOMMU on the platform device can
identify single devices on the bus that originates from it? That would
be an important difference to the PCI->USB case.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

