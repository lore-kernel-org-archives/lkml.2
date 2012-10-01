Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2JAQdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:33:41 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:47553
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071Ab2JAQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:33:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB83BX-01-2W5-02
X-M-MSG: 
Date: Mon, 1 Oct 2012 18:33:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/16] iommu/amd: Add IOAPIC remapping routines
Message-ID: <20121001163338.GP4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-10-git-send-email-joerg.roedel@amd.com>
 <6d716497-bcf6-4d71-88a3-6ec772a4d396@sausexedgep01.amd.com>
 <20121001084051.GO4009@amd.com>
 <20121001134753.GF4099@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121001134753.GF4099@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 09:47:53AM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 01, 2012 at 10:40:51AM +0200, Joerg Roedel wrote:

> > Don't understand this. What is not set?
> 
> the IRQ_DELAYED_DISABLE. But I could not even find that enum anymore?
> Has that been obsoleted?

You are right, its was removed. Ok, I will remove that line of the
comment too.

> I was thinking the other way around. You recover the old affinity. Should
> you print out a warning mentioning to the system admin that you could not
> set the new affinity but reverted to the old one? Or will that not serve
> anything except spam the kernel logs?

Well, I don't think it makes sense to print an additional error at this
point. The error will be propagated upwards in the call-chain and in the
end it is up to the initiator how to handle this situation (for example
just return a failure to user-space).


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

