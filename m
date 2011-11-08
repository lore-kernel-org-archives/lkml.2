Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1KHRRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:17:36 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:34450 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1KHRRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:17:33 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zz1432N98dK4015Lzz1202hzz15d4Rz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUCQP2-02-9GO-02
X-M-MSG: 
Date: Tue, 8 Nov 2011 18:17:25 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH] pci: More PRI/PASID cleanup
Message-ID: <20111108171725.GE5182@amd.com>
References: <20111103034359.10286.19062.stgit@bling.home>
 <20111108162826.GD5182@amd.com>
 <1320770670.19116.23.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320770670.19116.23.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 09:44:30AM -0700, Alex Williamson wrote:

> bit 0 (PCI_PASID_ENABLE) is reserved in the CAP register...

Is it? Which spec are you using? In my version it is not reserved but
states if it is supported to set the enable-bit.

> Which means we need to check CTRL, not CAP to see if it was previously
> enabled... or maybe this check is entirely wrong and we're was trying to
> see if enable is supported.

I will check how this looks in my test environment.

> And nobody exposes PCI_PASID_ENABLE because it doesn't exist as a
> capability.
> 
> It's easy to see this if the bit definitions are named appropriately and
> specified per register instead of being lumped together as "close
> enough".  Thanks,

I don't object against your renames as long as it doesn't cause
merge-conflicts with what I plan to send upstream.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

