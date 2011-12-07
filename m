Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab1LGT6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:58:22 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48550 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1LGT6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:58:20 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzzz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVUNH2-01-PVZ-02
X-M-MSG: 
Date: Wed, 7 Dec 2011 20:57:53 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] rework of extended state handling, LWP support
Message-ID: <20111207195753.GD665@escobedo.osrc.amd.com>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
 <m2ipm2lioy.fsf@firstfloor.org>
 <20111130173745.GT878@escobedo.osrc.amd.com>
 <20111130215200.GS24062@one.firstfloor.org>
 <20111201203605.GB411@escobedo.osrc.amd.com>
 <4ED83177.7070706@zytor.com>
 <20111202112050.GC411@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111202112050.GC411@escobedo.osrc.amd.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 02, 2011 at 12:20:50PM +0100, Hans Rosenfeld wrote:
> On Thu, Dec 01, 2011 at 06:01:27PM -0800, H. Peter Anvin wrote:
> > On 12/01/2011 12:36 PM, Hans Rosenfeld wrote:
> > > 
> > > So I assume, if you have 10000s of processes on a legacy 32bit system
> > > that never do any FPU stuff or SSE optimizations, you might indeed waste
> > > a couple of megabytes. I don't think thats very realistic, but that's
> > > just my opinion.
> > > 
> > 
> > A couple of megabytes of *lowmem*...
> 
> Ok, I'll rework that part, so that preallocation only happens on systems
> that support non-lazy states. That means patch #7 is going away and
> patch #8 is getting slightly bigger. This may take a few days as I have
> to test that again.

The reworked LWP patches are ready and will follow shortly. I also added
a Kconfig option to completely disable support for non-lazy states,
allowing to completely avoid preallocation of the xstate area if
required.


Did you look at the other patches already?


Hans



-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

