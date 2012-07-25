Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab2GYRPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:15:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43151 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2GYRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:15:29 -0400
Date: Wed, 25 Jul 2012 19:15:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCHv7 00/17] perf: Add backtrace post dwarf unwind
Message-ID: <20120725171521.GG1173@somewhere.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 02:14:23PM +0200, Jiri Olsa wrote:
> hi,
> 
> patches available also as tarball in here:
> http://people.redhat.com/~jolsa/perf_post_unwind_v7.tar.bz2
> 
> v7 changes:
>    - omitted v6 patches 9 and 15
>      They need more work and will be sent separately. I dont want to hold off whole
>      patchset because of them. We could miss some related backtraces (syscall, vdso)
>      in this version.
>    - v6 patch 11, 14, 20 already in

I'm personally ok with the kernel bits. And the tool bits look like a nice
base to work on.

If nobody has a strong opposition, it would be nice to merge this in -tip.
Either in perf/core or in some staging tree. So that we continue incrementally.

Nice work overall, thanks!
