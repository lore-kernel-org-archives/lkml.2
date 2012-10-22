Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2JVJHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab2JVJHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:07:10 -0400
Date: Mon, 22 Oct 2012 11:06:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
Message-ID: <20121022090629.GD1758@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <87ipa3j72c.fsf@sejong.aot.lge.com>
 <20121022075304.GA984@krava.brq.redhat.com>
 <876262khv7.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876262khv7.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 05:53:32PM +0900, Namhyung Kim wrote:
> On Mon, 22 Oct 2012 09:53:05 +0200, Jiri Olsa wrote:
> > On Mon, Oct 22, 2012 at 04:32:11PM +0900, Namhyung Kim wrote:
> >> It'd be better if you provide a git branch for this series.
> >
> > aaah right, I forgot to mention that.. ;)
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
> > perf/group2
> 
> I couldn't get the branch.  Do you mind rechecking?
> 
> $ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git perf/group2
> fatal: Couldn't find remote ref perf/group2

aaand it's pushed now ;)

jirka
