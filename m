Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1ANCqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:46:51 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:26189
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576Ab1ANCqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 21:46:45 -0500
X-SpamScore: -13
X-BigFish: VPS-13(z426fnzbb2cK1432N98dN148cMzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEZQXR-02-830-02
X-M-MSG: 
Date: Fri, 14 Jan 2011 03:29:50 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: [PATCH] oprofile: Add support for missing Intel core i7 models
Message-ID: <20110114022950.GC4739@erda.amd.com>
References: <1294958291-5626-1-git-send-email-sbohrer@rgmadvisors.com>
 <20110113235503.GY4739@erda.amd.com>
 <20110114002435.GR25713@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110114002435.GR25713@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.01.11 19:24:35, Andi Kleen wrote:
> On Fri, Jan 14, 2011 at 12:55:03AM +0100, Robert Richter wrote:
> > On 13.01.11 17:38:11, Shawn Bohrer wrote:
> > > Added missing core i7 models found in "Intel 64 and IA-32 Architectures
> > > Software Developer's Manual Volume 3B: System Programming Guide",
> > > Table B-1.  Tested with oprofile 0.9.6 on a:
> > > 
> > > model      : 44
> > > model name : Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz
> > > 
> > > Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> > 
> > Andi,
> > 
> > please ACK.
> 
> NACK -- first it's wrong because that's a westmere and westmere
> has a different event list. And the new way is to fall back to arch-perfmon
> and handle the CPUID in user space. This has been already implemented.
> So the fix is to upgrade user space.

Andi,

thanks for looking at this.

Will it be the general way in the future not to add model detection
for new Intel cpus to kernel code and instead use arch_perfmon? Are
the user land patches for cpu detection already in the oprofile
repository? I assume oprofile 0.9.6 is not up-to-date and needs to be
patched.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

