Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1DFOnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:43:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35527 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1DFOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:43:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=foH4tHZHz+C6DDb91JaqGY9cNbKuseobt95SeiJVHsmADutP0Zmy2TcUyVWECk2MvF
         N7sC+LvBIY0DuX8/Iz6CmDvXMgKCMeEX0TEhhqaMUUUe/nM/XaQUqAFH2Fogk/XOxn+i
         P7hjKiAgLlFKLHBq1TuCFC2nQDbq9JFHNT4GY=
Date: Wed, 6 Apr 2011 16:43:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
Message-ID: <20110406144308.GF1867@nowhere>
References: <4D8CAE74.9080805@gmail.com>
 <4D906450.1040809@hitachi.com>
 <4D909BBB.5020500@gmail.com>
 <20110401151313.GC2335@nowhere>
 <4D96072E.4060902@gmail.com>
 <20110406121501.GA1867@nowhere>
 <20110406140958.GA4987@ghostprotocols.net>
 <1302099301.2225.1381.camel@twins>
 <20110406143003.GD1867@nowhere>
 <4D9C79F1.2060308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9C79F1.2060308@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 08:34:25AM -0600, David Ahern wrote:
> 
> 
> On 04/06/11 08:30, Frederic Weisbecker wrote:
> > On Wed, Apr 06, 2011 at 04:15:01PM +0200, Peter Zijlstra wrote:
> >> On Wed, 2011-04-06 at 11:09 -0300, Arnaldo Carvalho de Melo wrote:
> >>>> What we seem to need for that is to bring a pagefault tracepoint. We had
> >>>> propositions for that in the past, but work on this is in pause mode it
> >>>> seems. 
> >>
> >> Huh, whot? You can get that using PERF_COUNT_SW_PAGE_FAULT and
> >> PERF_SAMPLE_ADDR.
> > 
> > Where are we doing that? I can't find the code that handles it.
> 
> That's what the other email thread was about, and the solution is just
> that - perf record -e faults -c 1 -d ... Then it comes to dumping the
> information. That's easy with the current perf-script.

Yeah indeed.

Thanks.
