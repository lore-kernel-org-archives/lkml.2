Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab1B0K2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 05:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1B0K17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 05:27:59 -0500
Date: Sun, 27 Feb 2011 07:27:43 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -perf/perf/makefile  0/2] Perf bugfixes for cross-builds
Message-ID: <20110227102743.GA16202@ghostprotocols.net>
References: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp> <4D63A642.5090203@hitachi.com> <20110222121139.GB27070@ghostprotocols.net> <4D6A1CDB.4040908@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6A1CDB.4040908@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Feb 27, 2011 at 06:43:55PM +0900, Masami Hiramatsu escreveu:
> (2011/02/22 21:11), Arnaldo Carvalho de Melo wrote:
> > Em Tue, Feb 22, 2011 at 09:04:18PM +0900, Masami Hiramatsu escreveu:
> >> Hi Arnaldo,
> >>
> >> BTW, could you pull these patches for cross building?
> > 
> > I'll try again to use this new feature, sorry for not sending feedback,
> > but I failed to use it on a RHEL6 system, have to try again and provide
> > proper feedback.
> 
> Hmm, would you install some devel packages for i686 too?
> This change requires 32bits devel packages for cross building.

Yeah, I did it, perhaps some was missing, as I said, have to try it
again.
 
> Thank you,
> 
> >  
> >> (2011/02/10 11:28), Masami Hiramatsu wrote:
> >>> Hi,
> >>>
> >>> Here are some bugfixes related to cross builds.
> >>> - Introduce ARCH=XX for cross-builds instead of obsolate
> >>>   EXTRA_CFLAGS=-mXX option.
> >>> - Rename obsolate NO_PERL to NO_LIBPERL
> >>>
> >>> Still not sure how I can do cross-builds i386 binary with
> >>> perl/python support on x86-64. Anyway, now we can do without
> >>> that as below;
> >>>
> >>>  $ make ARCH=i386 NO_LIBPERL=1 NO_LIBPYTHON=1
> >>>
> >>> Thank you,
> >>>
> >>> ---
> >>>
> >>> Masami Hiramatsu (2):
> >>>       perf tools: Rename old NO_PERL option to NO_LIBPERL
> >>>       perf tools: Introduce ARCH= option for cross building
> >>>
> >>>
> >>>  tools/perf/Makefile              |   48 +++++++++++++++++++++++++-------------
> >>>  tools/perf/arch/arm/Makefile     |    2 +-
> >>>  tools/perf/arch/powerpc/Makefile |    2 +-
> >>>  tools/perf/arch/s390/Makefile    |    2 +-
> >>>  tools/perf/arch/sh/Makefile      |    2 +-
> >>>  tools/perf/arch/sparc/Makefile   |    2 +-
> >>>  tools/perf/arch/x86/Makefile     |    2 +-
> >>>  7 files changed, 38 insertions(+), 22 deletions(-)
> >>>
> >>
> >>
> >> -- 
> >> Masami HIRAMATSU
> >> 2nd Dept. Linux Technology Center
> >> Hitachi, Ltd., Systems Development Laboratory
> >> E-mail: masami.hiramatsu.pt@hitachi.com
> 
> 
> -- 
> Masami HIRAMATSU
> 2nd Dept. Linux Technology Center
> Hitachi, Ltd., Systems Development Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
