Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1DFRSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 13:18:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38436 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1DFRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 13:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=NEjfPNylp5RH0qsaTre1gQpZgQ4tGmEpWK8IvJ09FDId25eJSqUy0A/6Tfp9X0CuNH
         GhzAcfCYxMK9ZgUWUKkncFBbVhmCY6t1wmpXk4sQmwbXt8Lm9NTwJE5+pKCMEenGzc3b
         lj9hdtKt+OvSXI0tj81Q1dggA9K+zijnhGjVI=
Date: Wed, 6 Apr 2011 14:18:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
Message-ID: <20110406171821.GB4987@ghostprotocols.net>
References: <4D8B79E6.2050603@gmail.com>
 <4D8C6B1B.70409@hitachi.com>
 <4D8CAE74.9080805@gmail.com>
 <4D906450.1040809@hitachi.com>
 <4D909BBB.5020500@gmail.com>
 <20110401151313.GC2335@nowhere>
 <4D96072E.4060902@gmail.com>
 <20110406121501.GA1867@nowhere>
 <20110406140958.GA4987@ghostprotocols.net>
 <20110406145521.GG1867@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406145521.GG1867@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 06, 2011 at 04:55:23PM +0200, Frederic Weisbecker escreveu:
> On Wed, Apr 06, 2011 at 11:09:58AM -0300, Arnaldo Carvalho de Melo wrote:
> > Isn't there one in the 'tip/tmp.perf/trace' tmp branch? Lemme see...
> > 
> > Yeah, and it is even yours ;-)
> > 
> > commit 6a824e89c0dfe6bce3d7e85f987ec9c8e7304b34
> > Author: Frederic Weisbecker <fweisbec@gmail.com>
> > Date:   Fri Nov 12 05:35:06 2010 +0100
> > 
> >     perf, mm: Add fault tracing
> >     
> >     Part of that are two modified patches from Jiri Olsa who added the
> >     fault tracepoints. I had to split them in two tracepoints so that we get
> >     the faults handling duration.
> >     
> >     Originally-from: Frederic Weisbecker <fweisbec@gmail.com>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> That forgets to mention it's based on Jiri Olsa's patch :)
> 
> "tracing,mm - add kernel pagefault tracepoint for x86 & x86_64"
> 
> (Message id <1289466549-7602-3-git-send-email-jolsa@redhat.com>).
> 
> > 
> > Can we dust this one off and get the ball rolling again? 
> 
> I prefer someone comes with a real need before me or Jiri respin
> that. There was perf trace but its development seems to be stale
> now.

Yeah, I need to resume work on it, sidetracked now tho.
 
> The page fault software event seem to be enough for basic
> dump requests. I don't like software events and prefer tracepoints
> in general but as long as the current implementation is enough
> and people don't need to measure page fault servicing time,
> write scripts or so, we are probably fine.

- ARnaldo
