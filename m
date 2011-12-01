Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1LAOCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:02:10 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:41334
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab1LAOCJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:02:09 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz1432Nzz1202hzzz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Chris Wright <chrisw@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Gibson <dwg@au1.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
Thread-Topic: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
Thread-Index: AQHMrxREhtMwThCA10C5HWgeixjU75XFPcoAgAAJroCAAThNgIAADZ0AgAABa4CAAAHhAIAADNmAgAAENACAAGKMYA==
Date: Thu, 1 Dec 2011 14:02:06 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15032808E0@039-SN1MPN1-003.039d.mgd.msft.net>
References: <20111021195412.8438.9951.stgit@s20.home>
 <20111021195605.8438.81609.stgit@s20.home>
 <20111130024205.GF5435@truffala.fritz.box>
 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
 <20111201000337.GA5427@truffala.fritz.box>
 <20111201005220.GG29071@x200.localdomain>
 <20111201005725.GE5427@truffala.fritz.box>
 <20111201010408.GH29071@x200.localdomain> <1322704207.3729.10.camel@pasglop>
 <20111201020510.GJ29071@x200.localdomain>
In-Reply-To: <20111201020510.GJ29071@x200.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.83.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > That way the domain information is available generically (can be match
> > with pci_domain_nr() for example), and sysfs can then be layed out as
> >
> > /sys/bus/pci/groups/<domain>/<id>
> >
> > Which is nicer than having enormous id's
> 
> Seems fine to me (although I missed /sys/bus/pci/groups/ introduction), except that I think
> the freescale folks aren't interested in PCI which is one reason why the thing is just an
> opaque id.

We are interested in PCI, but non-PCI as well.  All DMA devices,
have a globally unique "logical I/O device number" (LIODN) which
will map to a group # for us.

Stuart

