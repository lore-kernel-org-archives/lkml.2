Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab1GXKTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 06:19:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1GXKS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 06:18:59 -0400
Date: Sun, 24 Jul 2011 12:18:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Drake <dsd@laptop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        x86@kernel.org
Subject: Re: OLPC power management patches - merge for 3.1?
Message-ID: <20110724101810.GA23597@elte.hu>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
 <20110724072729.GA21281@elte.hu>
 <CAGq3pz6zGhFCgpeWy2zfWw_fNv2UFz=51uL9cfjArggu=wztcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGq3pz6zGhFCgpeWy2zfWw_fNv2UFz=51uL9cfjArggu=wztcw@mail.gmail.com>
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


* Daniel Drake <dsd@laptop.org> wrote:

> On 24 July 2011 08:27, Ingo Molnar <mingo@elte.hu> wrote:
> > it's excluded because in testing i found a boot crash with it.
> > Thomas did a quick fix for it but i have not heard about it since
> > then - Thomas/Peter, is this all resolved in x86/olpc?
> 
> Ah, sorry if we broke something. Can you go into more details on the
> crash? We haven't heard anything on these lines. I'm willing to help
> out fixing it.
> 
> Is it related to the apbuart serial patch you included in your mail? I
> don't see how that could have been affected by OLPC patches - but I am
> probably missing something.

i don't have the details anymore, i'll re-test once the build failure 
is fixed. We can certainly push it in this merge window if it's 
stable.

Thanks,

	Ingo
