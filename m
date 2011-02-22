Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1BVMLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:11:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1BVMLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:11:48 -0500
Date: Tue, 22 Feb 2011 09:11:39 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -perf/perf/makefile  0/2] Perf bugfixes for cross-builds
Message-ID: <20110222121139.GB27070@ghostprotocols.net>
References: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp> <4D63A642.5090203@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D63A642.5090203@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 22, 2011 at 09:04:18PM +0900, Masami Hiramatsu escreveu:
> Hi Arnaldo,
> 
> BTW, could you pull these patches for cross building?

I'll try again to use this new feature, sorry for not sending feedback,
but I failed to use it on a RHEL6 system, have to try again and provide
proper feedback.
 
> (2011/02/10 11:28), Masami Hiramatsu wrote:
> > Hi,
> > 
> > Here are some bugfixes related to cross builds.
> > - Introduce ARCH=XX for cross-builds instead of obsolate
> >   EXTRA_CFLAGS=-mXX option.
> > - Rename obsolate NO_PERL to NO_LIBPERL
> > 
> > Still not sure how I can do cross-builds i386 binary with
> > perl/python support on x86-64. Anyway, now we can do without
> > that as below;
> > 
> >  $ make ARCH=i386 NO_LIBPERL=1 NO_LIBPYTHON=1
> > 
> > Thank you,
> > 
> > ---
> > 
> > Masami Hiramatsu (2):
> >       perf tools: Rename old NO_PERL option to NO_LIBPERL
> >       perf tools: Introduce ARCH= option for cross building
> > 
> > 
> >  tools/perf/Makefile              |   48 +++++++++++++++++++++++++-------------
> >  tools/perf/arch/arm/Makefile     |    2 +-
> >  tools/perf/arch/powerpc/Makefile |    2 +-
> >  tools/perf/arch/s390/Makefile    |    2 +-
> >  tools/perf/arch/sh/Makefile      |    2 +-
> >  tools/perf/arch/sparc/Makefile   |    2 +-
> >  tools/perf/arch/x86/Makefile     |    2 +-
> >  7 files changed, 38 insertions(+), 22 deletions(-)
> > 
> 
> 
> -- 
> Masami HIRAMATSU
> 2nd Dept. Linux Technology Center
> Hitachi, Ltd., Systems Development Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
