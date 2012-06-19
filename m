Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab2FSJt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:49:28 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:39924
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082Ab2FSJt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:49:26 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VPS-13(zz98dI1432I4015Izz1202hzz15d4R8275dhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M5UZA8-01-1X4-02
X-M-MSG: 
Date: Tue, 19 Jun 2012 11:49:18 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <bhelgaas@google.com>,
        <david@gibson.dropbear.id.au>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <ddutile@redhat.com>, <liuj97@gmail.com>
Subject: Re: [PATCH v2 0/7] IOMMU: Groups support
Message-ID: <20120619094918.GH2624@amd.com>
References: <20120530201424.31527.33142.stgit@bling.home>
 <20120606110514.GG757@amd.com>
 <1339429021.24037.8.camel@bling.home>
 <1340040703.17272.2.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340040703.17272.2.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 18, 2012 at 11:31:43AM -0600, Alex Williamson wrote:
> Anyone?  Alexey & BenH, I know you're familiar with IOMMU groups, please
> give Joerg some kind of indication that you approve of this for POWER.
> David Woodhouse, these patches touch intel-iommu, please ack or comment:
> 
> https://lkml.org/lkml/2012/5/30/445
> https://lkml.org/lkml/2012/5/30/450
> 
> Joerg, maybe we can just add CC: to the commit log?  Thanks,

Well, we can't hold up things forever. Given that the POWER guys had
long discussions with you about previous versions but not about this one
counts as a silent Ack for me ;)

So I already applied the patches into my local tree yesterday and gave
them some additional testing. All looks good so far. I think I will push
the result soon to get this into linux-next.

I'll probably rebase to add the Cc's to the commits before pushing it
out.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

