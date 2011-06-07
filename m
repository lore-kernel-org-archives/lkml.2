Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1FGLP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:15:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1FGLP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:15:26 -0400
X-Authority-Analysis: v=1.1 cv=rr9DlE2fnT1UeYFJeFag6ks/js+bHNfqVlaSByoS2d4= c=1 sm=0 a=auj7d2cZCtoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=OeRK8J--zQNAME_2AhgA:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] slob/lockdep: Fix gfp flags passed to lockdep
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Paul Mundt <lethal@linux-sh.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110607101948.GB21356@elte.hu>
References: <1307369665.31814.20.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1106062106580.22635@chino.kir.corp.google.com>
	 <BANLkTikmp5CFKykBXaPUP0SBZEto1idDsA@mail.gmail.com>
	 <20110607101948.GB21356@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Jun 2011 07:15:22 -0400
Message-ID: <1307445322.31814.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 12:19 +0200, Ingo Molnar wrote:
> * Pekka Enberg <penberg@kernel.org> wrote:

> > However, I'm not pulling from a "tip/lockdep/devel" branch to slab.git
> > so Steven needs to send this to me in patch format or Ingo picks it up
> > in which case consider the patch:
> > 
> > Acked-by: Pekka Enberg <penberg@kernel.org>
> 
> Unless there are some dependencies i missed i think it would be 
> better if you pulled this, hm?

Nope, this is my fault. I searched for SLOB in MAINTAINERS and didn't
find it. But I should have looked at SLAB.

I'll resend this as a normal patch for Pekka.

-- Steve



