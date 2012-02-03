Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2BCHgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:36:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab2BCHgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:36:52 -0500
Date: Fri, 3 Feb 2012 08:36:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
Message-ID: <20120203073632.GB30543@elte.hu>
References: <20120128160925.275163704@goodmis.org>
 <20120130144857.GA22013@elte.hu>
 <1327936060.22710.165.camel@gandalf.stny.rr.com>
 <20120131194813.GA12074@elte.hu>
 <1328072925.5882.57.camel@gandalf.stny.rr.com>
 <20120201080539.GA11770@elte.hu>
 <1328109697.5882.65.camel@gandalf.stny.rr.com>
 <20120202135154.GA10315@elte.hu>
 <4F2A9960.2090500@zytor.com>
 <1328193068.5882.95.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328193068.5882.95.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Now I'm running a ktest bisect on the out-of-tree branch to 
> find the commit that prevents this box from booting. [...]

Let me know once you have found that and are able to boot -tip 
with your new bits applied. tip:out-of-tree needs definitely 
needs a cleanup - I'll probably even make it internal to my 
testing to not uglify tip:master.

Thanks,

	Ingo
