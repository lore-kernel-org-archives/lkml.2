Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1BEQUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 11:20:30 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:22095
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752075Ab1BEQU3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 11:20:29 -0500
X-SpamScore: -26
X-BigFish: VPS-26(zz542N1432N98dN9371Pzz1202hzzz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/4] ARM: Xilinx: Adding Xilinx platform infrastructuresupport
Date: Sat, 5 Feb 2011 09:20:12 -0700
In-Reply-To: <20110205161610.GB29411@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/4] ARM: Xilinx: Adding Xilinx platform infrastructuresupport
Thread-Index: AcvFUCmD+/kz5l47QSaQO5eTyHcSdwAACfyw
References: <1296922124-23379-1-git-send-email-john.linn@xilinx.com> <cdf64eb9-f50e-4435-92a9-48e161215853@VA3EHSMHS017.ehs.local> <20110205161610.GB29411@n2100.arm.linux.org.uk>
From: John Linn <John.Linn@xilinx.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <kernel@vger.kernel.org>,
        <catalin.marinas@arm.com>, <glikely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Feb 2011 16:20:13.0326 (UTC) FILETIME=[91235AE0:01CBC550]
X-RCIS-Action: ALLOW
Message-ID: <d5717920-de31-4915-8caf-f165711e8ce3@VA3EHSMHS023.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Saturday, February 05, 2011 9:16 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org; kernel@vger.kernel.org;
catalin.marinas@arm.com;
> glikely@secretlab.ca
> Subject: Re: [PATCH 1/4] ARM: Xilinx: Adding Xilinx platform
infrastructuresupport
> 
> On Sat, Feb 05, 2011 at 09:08:41AM -0700, John Linn wrote:
> > +config ARCH_XILINX
> > +	bool "Xilinx ARM Cortex A9 Based FPGA"
> > +	select CPU_V7
> 
> Ok, so your platform only supports ARMv7, so you select this symbol.
> 

Yes.  I added linux-kernel list also as I had hosed it up.

> > diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> > index 9d30c6f..cf0c6f6 100644
> > --- a/arch/arm/mm/Kconfig
> > +++ b/arch/arm/mm/Kconfig
> > @@ -415,7 +415,7 @@ config CPU_32v6K
> >
> >  # ARMv7
> >  config CPU_V7
> > -	bool "Support ARM V7 processor" if ARCH_INTEGRATOR ||
MACH_REALVIEW_EB || MACH_REALVIEW_PBX
> > +	bool "Support ARM V7 processor" if ARCH_INTEGRATOR ||
MACH_REALVIEW_EB || MACH_REALVIEW_PBX ||
> ARCH_XILINX
> 
> However, this makes the prompt visible to the user, and with the
'select'
> above, the only possible answer is 'y'.  You don't need to do this -
just
> remove this change.  That means "Support ARM V7 processor" won't be
offered
> to the user, but it will be set in the configuration.

Thanks Russell. Will do.

-- John



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


