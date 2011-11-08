Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab1KHRyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:54:45 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:18542
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab1KHRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:54:41 -0500
X-SpamScore: -26
X-BigFish: VPS-26(zz936eK1432N98dK4015Lzz1202hzz15d4Rz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LUCSEJ-02-20K-02
X-M-MSG: 
Date: Tue, 8 Nov 2011 18:54:10 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH] pci: More PRI/PASID cleanup
Message-ID: <20111108175410.GH5182@amd.com>
References: <20111103034359.10286.19062.stgit@bling.home>
 <20111108162826.GD5182@amd.com>
 <1320770670.19116.23.camel@bling.home>
 <20111108171725.GE5182@amd.com>
 <1320773518.19116.30.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320773518.19116.30.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 10:31:58AM -0700, Alex Williamson wrote:
> On Tue, 2011-11-08 at 18:17 +0100, Roedel, Joerg wrote:
> > On Tue, Nov 08, 2011 at 09:44:30AM -0700, Alex Williamson wrote:
> > 
> > > bit 0 (PCI_PASID_ENABLE) is reserved in the CAP register...
> > 
> > Is it? Which spec are you using? In my version it is not reserved but
> > states if it is supported to set the enable-bit.
> 
> Latest I can find is the March 31, 2011 PASID ECN, which just lists that
> bit as reserved.

Okay, my one is older and there it is stated as I implemented it. I will
check with reality first before changing the code...

> I can drop it if need be, was just trying to do some cleanup on the
> consistency of pci_reg.h before adding a bunch more defines to help
> bounds checking and parsing for vfio-pci.  Unless my spec is outdated,
> it seems like there's more than an aesthetic change here though, so
> resolving the conflicts with your latest work might be warranted.

Fine with me. The best is probably when I carry this change forward
(when Jesse is ok with that) and put my changes on-top of that.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

