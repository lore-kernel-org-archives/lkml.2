Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614Ab2J2V4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:56:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:36939 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab2J2V4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:56:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,673,1344236400"; 
   d="scan'208";a="162093381"
Date: Mon, 29 Oct 2012 14:56:07 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load
 Latency
Message-ID: <20121029215607.GM2266@tassilo.jf.intel.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
 <1351523752-4215-5-git-send-email-eranian@google.com>
 <20121029194203.GK2266@tassilo.jf.intel.com>
 <CABPqkBQ3pdvhV=tYjmdaAFyZFvUsM0PkvVw385c1cLA9_Z3KoQ@mail.gmail.com>
 <20121029211615.GL2266@tassilo.jf.intel.com>
 <CABPqkBTwoVQw8yb1dbYcyV=11U3_xYDNdQQLhuJgn9iJ2Ar65g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTwoVQw8yb1dbYcyV=11U3_xYDNdQQLhuJgn9iJ2Ar65g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree. I did that because it was the easiest thing I could think of.
> Discovered I had to deal with all of this just two days ago when I
> rebased. Wasn't too happy to have to deal with this at the last minute.

I'll repost, as soon as I debugged why Jiri's version of my 31/33 parser patch
doesn't work.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
