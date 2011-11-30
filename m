Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1K3RiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:38:01 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:23749
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596Ab1K3Rh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:37:59 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz146fK1432N98dKzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVHIB1-01-4Y3-02
X-M-MSG: 
Date: Wed, 30 Nov 2011 18:37:46 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] rework of extended state handling, LWP support
Message-ID: <20111130173745.GT878@escobedo.osrc.amd.com>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
 <m2ipm2lioy.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <m2ipm2lioy.fsf@firstfloor.org>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 01:31:09PM -0800, Andi Kleen wrote:
> Hans Rosenfeld <hans.rosenfeld@amd.com> writes:
> >
> > The lazy allocation of the xstate area has been removed. The support for
> > extended states that cannot be saved/restored lazily, like AMD's LWP,
> > need this. Since optimized library functions using SSE etc. are widely
> > used today, most processes would have an xstate area anyway, making the
> > memory overhead negligible.
> 
> Do you have any data on that?  It sounds dubious for specialized
> workloads.

What kind of specialized workload do you mean?


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

