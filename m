Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1JJKMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:12:02 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:17904
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab1JJKMA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:12:00 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzc89bh1432N98dKzz1202hzz15d4Rz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LSUHNU-01-HYL-02
X-M-MSG: 
Date: Mon, 10 Oct 2011 12:11:53 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Borislav Petkov <bp@amd64.org>
CC: Andreas Hartmann <andihartmann@01019freenet.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: AMD 970 chipset support in Linux?
Message-ID: <20111010101153.GY2138@amd.com>
References: <j6ehat$2qd$1@ID-44327.news.uni-berlin.de>
 <20111004105633.GA2985@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20111004105633.GA2985@gere.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 06:56:33AM -0400, Borislav Petkov wrote:
> On Tue, Oct 04, 2011 at 10:50:32AM +0200, Andreas Hartmann wrote:
> > Hello!
> > 
> > I'm wondering, if the new AMD 900 chipsets (970, 990X and 990FX) are
> > already supported in Linux (since which kernel version?).
> > 
> > I'm interested because these boards ship with a IOMMU, which I plan to use.
> 
> Let's ask Jörg.

If any, only 990FX supports IOMMU (like 890FX does). Note that the BIOS
also needs to support IOMMU.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

