Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab2JZJPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:15:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:39661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2JZJPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:15:07 -0400
Message-ID: <1351242885.16863.0.camel@twins>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read
 support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 26 Oct 2012 11:14:45 +0200
In-Reply-To: <87txti81i2.fsf@sejong.aot.lge.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	 <87txti81i2.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 10:29 +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Sat, 20 Oct 2012 16:33:08 +0200, Jiri Olsa wrote:
> > hi,
> > adding support to read sample values through the PERF_SAMPLE_READ
> > sample type. It's now possible to specify 'S' modifier for an event
> > and get its sample value by PERF_SAMPLE_READ.
> 
> I have a question.  What's an actual impact of specifying 'S' modifiere
> to a non-group event or even only a (non-leader) member of a group?  For
> instance, 'cycles:S' or '{branches,branch-misses:S}'.

I would hope a syntax error from the parser ;-)

I haven't actually looked at the implementation, but I understood it to
be a group modifier, not an event modifier.
