Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1JQGud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 02:50:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1JQGuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 02:50:32 -0400
Date: Mon, 17 Oct 2011 08:48:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
Message-ID: <20111017064855.GA18858@elte.hu>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
 <20111015145946.GB9516@elte.hu>
 <4E99BC44.40400@gmail.com>
 <20111015170452.GD29782@elte.hu>
 <4E99C6E6.2040201@gmail.com>
 <20111015190620.GA21352@ghostprotocols.net>
 <4E99DA6C.3030906@gmail.com>
 <20111017011521.GD21352@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017011521.GD21352@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Sat, Oct 15, 2011 at 01:09:32PM -0600, David Ahern escreveu:
> > On 10/15/2011 01:06 PM, Arnaldo Carvalho de Melo wrote:
> > >>
> > >> It should. The message comes from map__load() when it detects a deleted
> > >> mapping such as:
> > >>
> > >> 7f9e8d5c7000-7f9e8d5c8000 rw-p 0000c000 fd:02 1046947
> > >>  /lib64/libpam.so.0.82.2.#prelink#.cM3f72 (deleted)
> > >>
> > >> I have removed prelink from most of my systems (managed to find one lone
> > >> server with the above).
> > > 
> > > 	Can you send me a patch that clarifies this situation?
> > 
> > Clarifies in what way? The code checks for "(deleted)" on the dso and
> > suggests a restart of the process.
> 
> Perhaps telling that prelinking is the reason, so that users that 
> don't recall updating anything understands the situation.

Yeah. I am certainly aware of prelinking yet it did not occur to me 
when i saw the message.

Thanks,

	Ingo
