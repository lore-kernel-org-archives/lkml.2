Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab0IRJm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 05:42:27 -0400
Received: from www.tglx.de ([62.245.132.106]:54115 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0IRJmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 05:42:25 -0400
Date: Sat, 18 Sep 2010 11:41:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Damien Wyart <damien.wyart@free.fr>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Nix <nix@esperi.org.uk>,
        Artur Skawina <art.08.09@gmail.com>,
        John Drescher <drescherjm@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH RFC] x86: hpet: Avoid the readback penalty
In-Reply-To: <20100918074939.GA3275@brouette>
Message-ID: <alpine.LFD.2.00.1009181140010.2416@localhost6.localdomain6>
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org> <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6> <20100918074939.GA3275@brouette>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010, Damien Wyart wrote:

> * Thomas Gleixner <tglx@linutronix.de> [2010-09-15 15:11]:
> > > x86: hpet: Work around hardware stupidity
> 
> > After my brain recovered from yesterdays exposure with the x86 timer
> > horror, I came up with a different solution for this problem, which
> > avoids the readback of the compare register completely. It works
> > nicely on my affected ATI system, but needs some exposure to the other
> > machines.
> 
> Comments for this different solution seemed fine, but it seems only the
> first one was commited into mainline and then stable. Is this intended?

Yes. I wanted to have confirmation for the second solution (also from
the HW folks). I'm queueing it for .37

Thanks,

	tglx
