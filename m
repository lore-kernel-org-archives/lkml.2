Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab2BIOu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:50:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37400 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751215Ab2BIOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:50:25 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+TLNlgZVGTvEdIyUHSA9vcktQ0mJZRPGbI/3+SFT
	EJ/2xaJZy6INHR
Message-ID: <1328799019.9303.27.camel@marge.simpson.net>
Subject: Re: [PATCH] perf annotate: Numeric assembly labels cause incorrect
 annotation
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, emunson@mgebm.net,
        imunsie@au1.ibm.com, eranian@google.com, linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 15:50:19 +0100
In-Reply-To: <20120209133101.GC8830@elte.hu>
References: <20120207145535.71b9f22d@kryten>
	 <20120207144033.GB2172@infradead.org>
	 <1328782223.9303.3.camel@marge.simpson.net> <20120209133101.GC8830@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 14:31 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> > I don't see that problem, but perf top annotation isn't 
> > working properly in tip at least.  It seems to have forgotten 
> > how to average, seems to be clearing hit counts at every 
> > screen refresh or something.
> 
> hm, seems to work fine here. We used to have such a bug recently 
> (as of a few weeks [days?] ago), but latest -tip does not show 
> those symptoms.

Fresh pulled from git server:
marge:/usr/local/src/kernel/git/linux-3.0-tip # git describe
v3.3-rc2-1940-g8819807
marge:/usr/local/src/kernel/git/linux-3.0-tip # perf --version
perf version 3.3.rc2.1940.g881980.dirty

get server:
git@marge:~/linux-2.6> git checkout x86-tip
Switched to branch 'x86-tip'
Your branch is ahead of 'x86-tip/master' by 566 commits

Aha, need to drop/re-checkout again.  Have to be careful with tip, it
wiggles around on ya :)

-Mike

