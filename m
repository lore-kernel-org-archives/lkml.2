Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1DFOmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:42:37 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35957 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab1DFOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fx0GL1duYGLsNevi+mohIYx7XAEcMDZHPlpieuj2iqu9wrffxq6ncjyYZbuJKqfGYW
         Y5pbf0Rfkwsqvj8V+/evpYg64MPs3GmK8byyYaEUeTezDW2Zz9UYpt6ydWHP8+Jvl0hs
         wSujAUwpBYIriL2FjLtlG5nAuATrqI2Cg0Yok=
Date: Wed, 6 Apr 2011 16:42:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
Message-ID: <20110406144226.GE1867@nowhere>
References: <4D8B79E6.2050603@gmail.com>
 <4D8C6B1B.70409@hitachi.com>
 <4D8CAE74.9080805@gmail.com>
 <4D906450.1040809@hitachi.com>
 <4D909BBB.5020500@gmail.com>
 <20110401151313.GC2335@nowhere>
 <4D96072E.4060902@gmail.com>
 <20110406121501.GA1867@nowhere>
 <20110406140958.GA4987@ghostprotocols.net>
 <1302099301.2225.1381.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302099301.2225.1381.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 04:15:01PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-04-06 at 11:09 -0300, Arnaldo Carvalho de Melo wrote:
> > > What we seem to need for that is to bring a pagefault tracepoint. We had
> > > propositions for that in the past, but work on this is in pause mode it
> > > seems. 
> 
> Huh, whot? You can get that using PERF_COUNT_SW_PAGE_FAULT and
> PERF_SAMPLE_ADDR.

Oops, right, found it.
