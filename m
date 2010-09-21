Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0IUPJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:09:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab0IUPJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:09:35 -0400
Date: Tue, 21 Sep 2010 17:09:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        rostedt@goodmis.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
Message-ID: <20100921150911.GA2262@elte.hu>
References: <cover.1284733808.git.jbaron@redhat.com>
 <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
 <20100921131232.GA3024@one.firstfloor.org>
 <20100921143555.GA2873@redhat.com>
 <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > [someone, identity censored by Andi] wrote:
> >
> > Also, I think the hash table deals nicely with modules.
> 
> Maybe but it's also a lot of code. And it seems to me that it is 
> optimizing the wrong thing. Simpler is nicer.

Uhm, no - you are not making it simpler, you are making it stupider.

Using a list walk for even 100 items is already borderline horrible and 
tasteless. We dont want crap code.

Thanks,

	Ingo
