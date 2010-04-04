Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0DDOmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:42:37 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51234 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0DDOma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:42:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gHTob++VSq/2avqvrTAzo/K7B4PjEadLHnLEAjuErpM5ZBxajz36jwHqiI7VlbAV0U
         gQu1YmfrSTvK+4hoxTO4IM0kpiCFBFUZI5VR7mZin0eARyuKj/vAcrkOUvQhVqsS9RE4
         Y9e5t/99DNqnJvIrM1f9WuncWRJ3OfFiChCmU=
Date: Sun, 4 Apr 2010 16:42:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf updates
Message-ID: <20100404144223.GB5608@nowhere>
References: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 04:36:40PM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       perf: Drop the frame reliablity check
>       perf: Fetch hot regs from the template caller
> 
> Arnd Bergmann (1):
>       perf_event: Make perf fd non seekable
> 
> Hitoshi Mitake (1):
>       Swap inclusion order of util.h and string.h in util/string.c


I just did a last minute rebase, just to prepend the title of this
one with "perf: "


> 
> 
>  arch/x86/kernel/cpu/perf_event.c |    3 +--
>  include/trace/ftrace.h           |   23 ++++++++++++-----------
>  kernel/perf_event.c              |    1 +
>  tools/perf/util/string.c         |    2 +-
>  4 files changed, 15 insertions(+), 14 deletions(-)

