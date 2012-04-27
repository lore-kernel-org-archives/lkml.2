Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815Ab2D0IWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:22:18 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:48162
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759418Ab2D0IWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:22:15 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M34PWY-01-0P3-02
X-M-MSG: 
Date: Fri, 27 Apr 2012 10:22:03 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Clemens Ladisch <clemens@ladisch.de>
CC: <andymatei@gmail.com>, "Huang, Shane" <Shane.Huang@amd.com>,
        Borislav Petkov <bp@amd64.org>, <linux-kernel@vger.kernel.org>,
        Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
Message-ID: <20120427082203.GB9233@aftab.osrc.amd.com>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no>
 <fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>
 <14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
 <4F97BA60.4080505@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F97BA60.4080505@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:48:32AM +0200, Clemens Ladisch wrote:
> andymatei@gmail.com wrote:
> > I have bought the Asus E45M1-M PRO to use in my home storage. [...]
> > I get "Disabling IRQ 16" and "Disabling IRQ 19". [...]
> > Is there a patch or something that resolves this issue yet?
> 
> As far as I remember, this is a hardware bug in the ASMedia PCIe/PCI
> bridge.  This can neither easily nor completely be worked around in
> software.

So, I got noted of this discussion: https://lkml.org/lkml/2012/1/30/216

So why aren't you guys producing a proper patch for people to test?
Simply get everyone of the bugreporters to give it a try and if all is
well, Linus said he'll take it.

Clemens, Jeroen?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

