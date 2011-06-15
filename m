Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1FOIP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:15:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54529 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab1FOIPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:15:22 -0400
Date: Wed, 15 Jun 2011 10:15:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Liao <phyomh@gmail.com>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
Message-ID: <20110615081518.GC12496@elte.hu>
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
 <20110609193300.GA16858@dev1756.snc6.facebook.com>
 <20110614221517.GA20319@dev1756.snc6.facebook.com>
 <BANLkTikcxA53t1ummUG3-3TagFhj==qYjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikcxA53t1ummUG3-3TagFhj==qYjw@mail.gmail.com>
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


* Sam Liao <phyomh@gmail.com> wrote:

> On Wed, Jun 15, 2011 at 6:15 AM, Arun Sharma <asharma@fb.com> wrote:
> > Sam,
> >
> > $ perf report -g graph,0.5,caller --sort pid
> >
> > is a bit hard to type. Perhaps add a simpler command line option
> > that has the same effect?
> >
> >  -Arun
> >
> >
> 
> How about perf report -g [caller/callee,][graph,0.1] -s pid
> 
> or remove the order of the options for "-g"

We could alias the -G flag to the inverse graph.

Plus it would be nice to allow a .perfconfig flag for people to 
configure their desired default reporting parameters.

Thanks,

	Ingo
