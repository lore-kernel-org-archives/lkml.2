Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2I1PES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:04:18 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:5770
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758364Ab2I1PER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:04:17 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI1432I179dNzz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB2F6Y-02-8XE-02
X-M-MSG: 
Date: Fri, 28 Sep 2012 17:04:13 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] iommu/amd: Implement MSI routines for interrupt
 remapping
Message-ID: <20120928150413.GI4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-11-git-send-email-joerg.roedel@amd.com>
 <20120928144933.GH7483@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120928144933.GH7483@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:49:34AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 28, 2012 at 02:24:00PM +0200, Joerg Roedel wrote:
> > +	if (index >= MAX_IRQS_PER_TABLE)
> > +		return 0;
> 
> Hmm? Not an error code?

No, when this case happens it just means that the interrupt is not
remapped (because the device itself is not handled by the IOMMU). This
is not an error code and only tells the code which composes the msi-msg
to use the default routine instead of the one for interrupt remapping.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

