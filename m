Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab0EMRgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:36:32 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38951 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab0EMRga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=JOcQuVVmnNYbvJwe8Qa7w0Fl5/JtlIzLXCZBJs6Kl08kNYA8+2ShRMU4CBeyPM7UR5
         6+iTUiS6RbhNGQiJxU62T6z9KBtPfjbrN/of6K8qT/FtY7nxVUSmLZ+1kjjZt9UsNBbD
         07Tk2kPkhU7xlYYU8aWNbuXkMOccxuw9emUss=
Date: Thu, 13 May 2010 14:36:23 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: perf: relative path to source for perf probe?
Message-ID: <20100513173623.GL19192@ghostprotocols.net>
References: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
 <20100513145826.GJ30926@ghostprotocols.net>
 <AANLkTimLKfPHI81K_-N7gIkDXgenqOzNQlTvGFlCutvi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimLKfPHI81K_-N7gIkDXgenqOzNQlTvGFlCutvi@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 13, 2010 at 05:51:45PM +0200, Chase Douglas escreveu:
> On Thu, May 13, 2010 at 4:58 PM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Probably you won't find this if you look at the old 2.6.34 codebase
> > (yay, for tools/perf it is already hundreds of patches behind :-)), so
> > I recomend you look at what we have in linux-2.6-tip, branch
> > tip/perf/core, what is in 2.6.34 is in tip/perf/urgent and right now,
> > IIRC, just a one patch that is not in 2.6.34 proper, a cherry-pick from
> > tip/perf/core, no less :-)
> 
> Where are these branches? I've looked at:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=summary
> 
> but I don't see these branches listed.

Well, if you decide to go from my tree, its all in the "perf" branch,
but I'd recommend you follow Ingo, my git tree, at the moment, is just a
conduit to get things out to him, which happens without noticeable delay
once I send a pull request.
 
> Thanks for the pointers!

You're welcome, please let us know about any other thing we may be of
help to make you of help to us ;-)

> -- Chase
