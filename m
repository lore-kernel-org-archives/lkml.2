Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1DVQwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:52:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:64946 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab1DVQwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:52:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,254,1301900400"; 
   d="scan'208";a="737111227"
Date: Fri, 22 Apr 2011 09:51:20 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110422165120.GA16607@tassilo.jf.intel.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <BANLkTinaZyHNV2Bm7CJFJ11WBCPGgsYijQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinaZyHNV2Bm7CJFJ11WBCPGgsYijQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Once you have clear and precise definition, then we can look at the actual
> events and figure out a mapping.

It's unclear this can be even done. Linux runs on a wide variety of micro
architectures, with all kinds of cache architectures.

Micro architectures are so different. I suspect a "generic" definition would
need to be so vague as to be useless.

This in general seems to be the problem of the current cache events.

Overall for any interesting analysis you need to go CPU specific.
Abstracted performance analysis is a contradiction in terms.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
