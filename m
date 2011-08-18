Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1HRMnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:43:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57256 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab1HRMnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:43:52 -0400
Date: Thu, 18 Aug 2011 09:43:41 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/6] perf/core fixes and improvements
Message-ID: <20110818124341.GA22222@ghostprotocols.net>
References: <1313505695-20724-1-git-send-email-acme@infradead.org>
 <20110817213617.GA9634@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817213617.GA9634@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 17, 2011 at 11:36:17PM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > Hi Ingo,
> > 
> >         Please consider pulling from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> hm, shouldnt these:
> 
> >   perf list: Fix exit value
> >   perf evlist: Fix missing event name init for default event (v2)
> >   perf tools: Fix error handling of unknown events
> 
> be in perf/urgent (based on -git) and go into v3.1, while the rest is 
> for perf/core and goes into v3.2?

I'll rework the branches, adding these and other fixes (glibc build fix,
etc) in perf/urgent and the rest in perf/core, resubmit.

- Arnaldo
