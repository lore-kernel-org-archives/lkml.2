Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab2GEP1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:27:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57752 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab2GEP1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:27:18 -0400
Date: Thu, 5 Jul 2012 12:27:12 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Subject: Re: [GIT PULL 00/16] tools lib traceevent: Pending backports of
 libparseevent
Message-ID: <20120705152712.GB17035@infradead.org>
References: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 04, 2012 at 02:34:28PM +0900, Namhyung Kim escreveu:
> Please pull pending libparseevent improvements from my tree. All
> patches in the tree got acked or signed-off by Steven. They were
> originally in the trace-cmd tree, and format-patched + path name
> adjusted and re-applied.
> 
> I've fixed the committer note and Link positions as you requested.  
> (I put the Links right before Steven's s-o-b as he's the original
> committer.) Also changelogs are reflowed (to fit to 70 column width
> that is the default value of emacs fill-paragraph function).
> 
> The following changes since commit 17d7a1123f0f6d532830152564cc812cc73db2f3:
> 
>   perf bench: Fix confused variable namings and descriptions in mem subsystem (2012-07-02 14:35:45 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git 

I think you need to wait a bit more till git request-pull can find the
tags/libtraceevent-core-for-acme in git.k.o, so that the above line
would become:

    git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git tags/libtraceevent-core-for-acme

I did merge this branch, signature checked, all is well, it seems, lets
see when Ingo pulls from my perf/core branch if everything is OK.

Thanks!

- Arnaldo
