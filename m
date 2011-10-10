Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1JJHeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:34:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38426 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1JJHeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:34:12 -0400
Date: Mon, 10 Oct 2011 09:32:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        the arch/x86 maintainers <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized
 ticketlocks
Message-ID: <20111010073214.GB29035@elte.hu>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
 <201109282008.17722.stephan.diestelhorst@amd.com>
 <CA+55aFwm7ESNfrHhEHrAKcjcPUq8YxtuEkJd5PzAekYo2dMYNw@mail.gmail.com>
 <2707952.s3VYcmPHUN@chlor>
 <4E8DE7F1.3050108@goop.org>
 <4E8DEED0.1020909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8DEED0.1020909@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 10/06/2011 10:40 AM, Jeremy Fitzhardinge wrote:
> > However, it looks like locked xadd is also has better performance:  on
> > my Sandybridge laptop (2 cores, 4 threads), the add+mfence is 20% slower
> > than locked xadd, so that pretty much settles it unless you think
> > there'd be a dramatic difference on an AMD system.
> 
> Konrad measures add+mfence is about 65% slower on AMD Phenom as well.

xadd also results in smaller/tighter code, right?

Thanks,

	Ingo
