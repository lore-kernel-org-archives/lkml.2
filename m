Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2I1Ohc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:37:32 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:11678
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721Ab2I1Oha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:37:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB2DYD-01-6V2-02
X-M-MSG: 
Date: Fri, 28 Sep 2012 16:37:24 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/16] iommu/amd: Check if IOAPIC information is correct
Message-ID: <20120928143724.GF4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-5-git-send-email-joerg.roedel@amd.com>
 <20120928141644.GC7483@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120928141644.GC7483@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:16:45AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 28, 2012 at 02:23:54PM +0200, Joerg Roedel wrote:
> +static bool __init check_ioapic_information(void)
> > +{
> > +	int idx;
> > +
> > +	for (idx = 0; idx < nr_ioapics; ++idx) {
> 
> That ++idx looks odd - and it looks like the file has a combination of
> i++ and ++i. Any particular reason for using this particular one instead
> of the more common: "idx++" ? Or just habit?

Well, it's just a habbit from my time with C++ :)

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

