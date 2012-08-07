Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2HGNXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:23:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42502 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab2HGNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:23:00 -0400
Date: Tue, 7 Aug 2012 15:22:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/2] perf tools: Basic bash completion support
Message-ID: <20120807132252.GA12858@somewhere.redhat.com>
References: <1344345586-15068-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344345586-15068-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 03:19:44PM +0200, Frederic Weisbecker wrote:
> Hey,
> 
> Basic bash completion support. Only support perf subcommands and most -e basic
> event descriptor (no grouping).
> 
> I just have a small issue with tracepoints because of their ":" in the middle.
> It auto completes as long as we haven't yet reached the semicolon. Otherwise
> we need to add a double quote in the beginning of the expression. I'm quite
> a newbie in bash completion though, so I might find a subtelty later to solve
> this.

Tips: for testing, you need to "make install" and update the bash completion
scripts:

	# make install
	$ . /etc/bash_completion

