Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2LUSng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:43:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53481 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LUSnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:43:31 -0500
Date: Fri, 21 Dec 2012 19:43:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vince Weaver <vince@deater.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tool: Add non arch events for SandyBridge microarchitecture
Message-ID: <20121221184324.GG16230@one.firstfloor.org>
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com> <1355751425-7993-4-git-send-email-jolsa@redhat.com> <m2zk19d7vk.fsf@firstfloor.org> <20121220111313.GB1241@krava.brq.redhat.com> <alpine.DEB.2.02.1212211305300.13284@pianoman.cluster.toy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1212211305300.13284@pianoman.cluster.toy>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I hate to sound like a broken record here, but, again, what's the 
> rationalization for not using libpfm4 here?

Personally I always hated the libpfm4 syntax. It's even worse than
oprofile.

> 
> Is it simply NIH or is there some sort of technical reason?  It seems a 
> lot of wasted effort to create all these tables one chip at a time when 
> libpfm4 already has well-tested and debugged event tables for most CPUs 
> with perf_event support.

I'm probably biased, but it's usually best to use the format the CPU
vendor releases the original event tables in. That gives you
the fastest access with the minimum amount of hazzle.

That would need a parser for each vendor, but there aren't really all
that many.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
