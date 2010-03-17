Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab0CQJw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:52:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41438 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0CQJw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:52:56 -0400
Date: Wed, 17 Mar 2010 10:52:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to lock
Message-ID: <20100317095230.GD17146@elte.hu>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1268590435.9440.8.camel@laptop>
 <20100317013236.GB5258@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317013236.GB5258@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > You add chained indirect calls into all lock ops, that's got to hurt.
> 
> Well, the idea was not bad at the first glance. It was separating lockdep 
> and lock events codes.
> 
> But indeed, the indirect calls plus the locking are not good for such a fast 
> path.

What would be nice to have is some sort of dynamic patching approach to enable 
_both_ lockdep, lockstat and perf lock.

If TRACE_EVENT() tracepoints were patchable we could use them. (but they arent 
right now)

	Ingo
