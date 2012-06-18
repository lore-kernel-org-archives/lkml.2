Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2FROGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:06:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44961 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FROGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:06:30 -0400
Date: Mon, 18 Jun 2012 11:06:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v2 1/5] tools lib traceevent: Replace malloc_or_die to
 plain calloc in alloc_event()
Message-ID: <20120618140625.GH2303@infradead.org>
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
 <1340027148.25903.90.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340027148.25903.90.camel@gandalf.stny.rr.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 18, 2012 at 09:45:48AM -0400, Steven Rostedt escreveu:
> Arnaldo,
> 
> I've acked this series. Can you add my Acked-by tags on the patches that
> do not have it yet, and then pull it into your repo?

Sure thing, I'll put it in my perf/core branch,

- Arnaldo
