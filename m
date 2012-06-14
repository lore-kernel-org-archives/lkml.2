Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2FNOhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:37:42 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:48422
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270Ab2FNOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:37:40 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5M3AL-01-57C-02
X-M-MSG: 
Date: Thu, 14 Jun 2012 16:37:28 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <robert.richter@amd.com>, <andreas.herrmann3@amd.com>
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
Message-ID: <20120614143727.GF7922@escobedo.osrc.amd.com>
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

On Tue, Jun 12, 2012 at 05:03:34PM -0700, Suresh Siddha wrote:
> I can split the patch if needed. And I need to do little bit more
> validation (already tested on 64-bit IVB  and 32-bit NHM) before
> removing the 'RFC' tag.
> 
> I tried starting with the old version of Hans patch. But there were lot
> more changes in this area since then and also his patch had few
> user-visible compatibility issues.
> 
> Appended is the version that I came up with. Please review.

Thank you for working on this.

I didn't see anything obviously wrong in a quick review of this code,
but this stuff is too complex for this to mean anything :)

I ran a quick test of your code. I found a signal frame corruption when
running a 32bit test program on a 64bit kernel. I didn't try to find out
why it failed, but I'll send you the test program in a private mail so
you can look at it yourself.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

