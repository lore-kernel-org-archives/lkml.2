Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1EGIXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 04:23:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1EGIXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 04:23:14 -0400
Date: Sat, 7 May 2011 10:22:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Hellermann <stefan@the2masters.de>,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH] mm: Use alloc_bootmem_node_nopanic on really needed path
Message-ID: <20110507082257.GD25065@elte.hu>
References: <4DC30251.9040902@the2masters.de>
 <4DC31D5F.8070209@the2masters.de>
 <4DC31F72.5050206@kernel.org>
 <4DC328AC.1060906@the2masters.de>
 <4DC3958F.1090800@kernel.org>
 <4DC3B6C6.7000704@the2masters.de>
 <4DC47655.5040201@kernel.org>
 <20110506153914.b1bceb51.akpm@linux-foundation.org>
 <4DC47AA6.3080302@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC47AA6.3080302@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On 05/06/2011 03:39 PM, Andrew Morton wrote:
> > On Fri, 06 May 2011 15:29:41 -0700
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Stefan found nobootmem does not work on his system that only have 8M ram.
> > 
> > What does "does not work" mean?  From the patch, it appears that the
> > machine paniced?
> 
> yes, early panic.

Why the heck did you not share this information in the original changelog 
itself? Do you think maintainers enjoy having to waste time asking you again 
and again to clarify your changelogs?

Changelogs need specificity. "does not work" is 10 times worse than "we saw an 
early crash" or "the system booted up with only 10% of the physical RAM 
visible". There are many degrees of "does not work".

Thanks,

	Ingo
