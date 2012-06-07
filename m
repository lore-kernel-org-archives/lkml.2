Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2FGMoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:44:38 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:38975
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755024Ab2FGMog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:44:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -15
X-BigFish: VPS-15(zz179dN1432N98dKzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M58ZE5-01-2YK-02
X-M-MSG: 
Date: Thu, 7 Jun 2012 14:44:52 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Rob Herring <robherring2@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/2] edac: add support for Calxeda highbank memory
 controller
Message-ID: <20120607124452.GE11153@aftab.osrc.amd.com>
References: <1339020125-20198-1-git-send-email-robherring2@gmail.com>
 <1339020125-20198-2-git-send-email-robherring2@gmail.com>
 <4FCFDB12.3090403@redhat.com>
 <4FCFE028.10005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FCFE028.10005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 05:56:40PM -0500, Rob Herring wrote:
> > Hmm... I suspect that memories by DIMM chip select/channel at Calxeda,
> > as it is using just 1 cs/channel. It probably makes more sense to add new layer
> > type(s) to properly represent the way your memory controller addresses it, if
> > Calxeda doesn't work with DIMMs.
> 
> Not sure I follow. DIMMs are supported, but only a newer JEDEC form
> factor (DDR3 72-bit mini DIMM). The h/w pretty much fixed to a single
> 4GB DIMM. The controller is 1 72-bit channel.

Me too, why would this need a new define although those are more-or-less
normal DIMMs (modulo the form factor)?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

