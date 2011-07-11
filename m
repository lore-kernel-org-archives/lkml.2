Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab1GKOWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:22:21 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:6008 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752978Ab1GKOWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:22:18 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2dK9371M1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LO6AHL-01-6O8-02
X-M-MSG: 
Date: Mon, 11 Jul 2011 16:20:04 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH x86/urgent 2/2] x86: Implement pfn -> nid mapping
 granularity check
Message-ID: <20110711142004.GA11163@escobedo.osrc.amd.com>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <4E181477.5090405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E181477.5090405@zytor.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 04:42:31AM -0400, H. Peter Anvin wrote:
> On 07/09/2011 01:32 AM, Tejun Heo wrote:
> > 
> > Ping?  If the change is too invasive at this stage, we can disable AMD
> > NUMA on x86_32 for 3.0 and queue these two for 3.1.
> > 
> 
> I am kind of leaning that way... Hans, what is your opinion?

Thats ok for me. Disable it in 3.0 and fix it properly in 3.1.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

