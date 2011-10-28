Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1J1HoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:44:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42219 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab1J1HoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:44:00 -0400
Date: Fri, 28 Oct 2011 09:39:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
Message-ID: <20111028073915.GA27593@elte.hu>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
 <20111027193448.GA3514@merkur.ravnborg.org>
 <20111028070336.GF12995@elte.hu>
 <1319786635.3235.11.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319786635.3235.11.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <levinsasha928@gmail.com> wrote:

> > ? It would be very obvious at a glance what it does.
> 
> We can possibly make 'make defconfig abc' run arch specific script 
> located next to the defconfig files (arch/$(ARCH)/configs/).

AFAICS that's not the same as the current kvmconfig functionality 
though: we want to minimally enable certain config options in the 
current .config - not pick some default config.

My main usecase for this is that i want to minimally change .config's 
that get mailed to me, to reproduce a bug reporter's kernel as 
closely as possible - and be able to boot it in KVM.

It's a straightforward, very useful feature, i've been using my own 
similar hack to do something similar for years and it works very 
well.

Thanks,

	Ingo
