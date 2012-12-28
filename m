Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2L1LWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:22:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab2L1LWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:22:15 -0500
Date: Fri, 28 Dec 2012 12:21:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/10] perf tools: Cleanups and bug fixes on sort keys
Message-ID: <20121228112147.GA976@krava.brq.redhat.com>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 06:11:37PM +0900, Namhyung Kim wrote:
> Hi,
> 
> There's a bug report from Stefan Beller that gets segfault on using
> some sort keys.  In addition to it, I had some TODO items related to
> it, hence this patchset. :)
> 
> This is mostly simple few liners and more complex ones might come later.
> 
> Stephane, it'd be great if you check I'm not messed up something on
> the branch stack side (or other area too).  Although I've tested basic
> functionality there might be something that I missed.
> 
> You can also get this from following tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git perf/sort-v1
> 
> Thanks,
> Namhyung
> 
> 
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> 
> Namhyung Kim (10):
>   perf sort: Move misplaced sort entry functions
>   perf sort: Get rid of unnecessary __maybe_unused
>   perf sort: Fix --sort pid output
>   perf sort: Align cpu column to right
>   perf sort: Calculate parent column width too
>   perf sort: Drop ip_[lr] arguments from _sort__sym_cmp()
>   perf sort: Check return value of strdup()
>   perf sort: Clean up sort__first_dimension setting
>   perf sort: Separate out branch stack specific sort keys
>   perf report: Update documentation for sort keys

I've tested all except for the branch related stuff, though they look ok as well

Acked-by: Jiri Olsa <jolsa@redhat.com>

for the the patchset

jirka
