Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab2I0XBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 19:01:55 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52342 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab2I0XBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 19:01:54 -0400
Date: Fri, 28 Sep 2012 01:01:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist
 periods
Message-ID: <20120927230138.GA10660@somewhere.redhat.com>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
 <87pq5awvgp.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq5awvgp.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:57:26PM +0900, Namhyung Kim wrote:
> Ping.  Any comments for this?
> 
> Arun, thanks for testing!
> Namhyung

When Arun was working on this, I asked him to explore if it could make sense to reuse
the "-b, --branch-stack"  perf report option. Because after all, this feature is doing
about the same than "-b" except it's using callchains instead of full branch tracing.
But callchains are branches. Just a limited subset of all branches taken on excecution.
So you can probably reuse some interface and even ground code there.

What do you think?
