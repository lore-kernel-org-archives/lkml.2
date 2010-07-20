Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0GTGjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 02:39:01 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51445 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0GTGjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 02:39:00 -0400
Date: Tue, 20 Jul 2010 12:08:05 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 0/13]  Uprobes Patches:
Message-ID: <20100720063805.GA19375@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100720041938.GA28533@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100720041938.GA28533@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I tried this again and it worked.  That is kinda worked becuase I could

Thanks for trying.

> use it to trace things in my running bash instance, but haven't really
> figured out how to trace something useful using the pid based interface.
> The processes I care about really don't run long enough for that.

I am working/(continue to work) on file based probes. But
currently spending some of my time merging the current patchset to
latest tip. Once this patchset gets pushed to tip, I should be able to
speed up the file based probing.

> 
> So thanks for the good work so far, but we'll really need a way to
> define the trace points per-file and have a way to invoke a program
> with tracing that uses it enabled.
> 
> A minor note on perf probe -S output:  This seems to include a lot of
> T.456 or similar labels, which from my recollection are gcc internal
> things.  It would be good to filter those out as they aren't quite
> useful and just fill up the list.

Okay .. will take a look. Offhand I dont know about the T.456
labels, so I will google and see if its possible for us to identify if
its a t.456 label. However if you know how to identify a t456 label
from normal functions, then it would be great.

> 
> 
> And I really need to complain about the per-patch changelogs inside
> the visible commit message again.  I know you disagree, but it's
> a real pain to read through it in git-log when you look for information
> about the patch (which for some of the patches is rather short anyway)
> and all you see is some rather useless patch versioning changelogs.

I am okay with dropping the Changelog or moving the Changelog under the
--- section. However I had retained it because Stephen Rostedt
replied to your post saying he found Changelog to be useful. 

Assuming, he is fine dropping the changelog, I will move the
Changelog to the --- section as suggested by you. 

> This is what basically all patches to the kernel do, and what's also
> suggested in Documentation/SubmittingPatches.

Agree. 

> 
> While talking about changelogs: your patches duplicate the patch
> subject line inside the mail body, leading to rather funny git
> commit messages after a git-am:
> 
> commit c32a1b63db113bb1508dbf01af34d29f6cda747a
> Author: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Date:   Mon Jul 12 16:04:42 2010 +0530
> 
>     perf: show functions in a file without using pid
>         
>     [RFC] perf: show functions in a file without using pid

Okay, I shall drop the Subject from the body of the patch next time I
send the patchset.

--
Thanks and Regards
Srikar
