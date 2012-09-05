Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744Ab2IEWhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:37:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42450 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2IEWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:37:45 -0400
Date: Wed, 5 Sep 2012 15:37:39 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf: remove unneeded include of network header files
Message-ID: <20120905223739.GE8203@ghostprotocols.net>
References: <1346255732-93246-1-git-send-email-dsahern@gmail.com>
 <20120905203903.GB8203@ghostprotocols.net>
 <5047C18B.9060602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5047C18B.9060602@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 05, 2012 at 03:18:03PM -0600, David Ahern escreveu:
> On 9/5/12 2:39 PM, Arnaldo Carvalho de Melo wrote:
> >Em Wed, Aug 29, 2012 at 09:55:32AM -0600, David Ahern escreveu:
> >>perf does not have networking related functionality, and the inclusion of
> >>these headers is one of the causes of compile failures for Android:
> >>   https://lkml.org/lkml/2012/8/23/316
> >>   https://lkml.org/lkml/2012/8/28/293
> >>
> >>So, remove them.
> >>
> >>Signed-off-by: David Ahern <dsahern@gmail.com>
> >>Cc: Ingo Molnar <mingo@kernel.org>
> >>Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >>Cc: Peter Zijlstra <peterz@infradead.org>
> >
> >     CC /home/acme/git/build/perf/util/scripting-engines/trace-event-python.o
> >In file included from /usr/lib64/perl5/CORE/perl.h:1239,
> >                  from util/scripting-engines/trace-event-perl.c:36:
> >/usr/include/netdb.h:591: error: expected identifier or ‘(’ before ‘[’ token
> >make: *** [/home/acme/git/build/perf/util/scripting-engines/trace-event-perl.o] Error 1
> >make: *** Waiting for unfinished jobs....
> >make: Leaving directory `/home/git/linux/tools/perf'
> 
> grr... removed the perl package testing the kconfig integration.
> forgot to reinstall. Will update.
> 

I fixed it already, nevermind, it was just a matter of reordering
includes, think how fragil that is, but it works now.

- Arnaldo
