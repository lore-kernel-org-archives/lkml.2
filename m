Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1LUMpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:45:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab1LUMpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:45:21 -0500
Message-ID: <4EF1D4B6.3020408@redhat.com>
Date: Wed, 21 Dec 2011 14:44:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Joerg Roedel <joro@8bytes.org>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
References: <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu> <4EEF26F0.1050709@redhat.com> <20111220091511.GB3091@elte.hu> <4EF05996.8030807@redhat.com> <20111220100916.GA20788@elte.hu> <20111220152758.GA30127@8bytes.org> <20111220184004.GE8408@elte.hu> <20111221000716.GB30127@8bytes.org> <20111221123442.GB6071@elte.hu>
In-Reply-To: <20111221123442.GB6071@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 02:34 PM, Ingo Molnar wrote:
> I think it can all be supported in a consistent way (see my 
> previous mails) - but the feature as presented today just does 
> not look useful enough to me if only supports that niche 
> self-monitoring usecase.

I hate to re-enter this thread, but this "niche use case" is exactly
what LWP is designed for.  And once the JVM is adapted to exploit LWP,
its use will dwarf all of the uses of perf put together (except the NMI
watchdog).  You're only causing the developers needless pain by forcing
them to fit this red peg into a green hole.

-- 
error compiling committee.c: too many arguments to function

