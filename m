Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1DSAio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 20:38:44 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:42748 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1DSAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 20:38:42 -0400
Date: Tue, 19 Apr 2011 02:38:39 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
Message-ID: <20110419003839.GA1624@x4.trippels.de>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
 <BANLkTi=hpNy3iA+49N90dbU4f0_L2RVJNQ@mail.gmail.com>
 <20110418203726.GA30868@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418203726.GA30868@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.18 at 22:37 +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Some opteron love would be good, but I don't have access to any right here.
> 
> Here's one:

And another:

CPU vendor   : AuthenticAMD
CPU model    : AMD Phenom(tm) II X4 955 Processor
CPU stepping : 2
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using mfence_rdtsc because you don't have an Intel CPU
Will test the "mfence;rdtsc" clock.
Now test passed  : margin 208 with 8769512 samples
Load3 test passed: margin 339 with 4880373 samples
Load test passed : margin 193 with 7189144 samples
Store test passed: margin 192 with 7149930 samples

-- 
Markus
