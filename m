Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2JBQBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:01:17 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61267 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab2JBQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:01:16 -0400
Date: Tue, 2 Oct 2012 18:01:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] perf tools: Bash completion update
Message-ID: <20121002160058.GE10605@somewhere>
References: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 12:21:31AM +0900, Namhyung Kim wrote:
> Hi,
> 
> This patchset improves bash completion support for perf tools.  Some
> option names are really painful to type so here comes a support for
> completing those long option names.  But I still think the
> --showcpuutilization option needs to be renamed (at least adding a
> couple of dashes in it).
> 
> Thanks,
> Namhyung

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks Namhyung!

> 
> 
> Namhyung Kim (3):
>   perf tools: Check existence of _get_comp_words_by_ref when bash completing
>   perf tools: Complete long option names of perf command
>   perf tools: Long option completion support for each subcommands
> 
>  tools/perf/bash_completion      |   36 +++++++++++++++++++++++++++++-------
>  tools/perf/util/parse-options.c |    8 ++++++++
>  tools/perf/util/parse-options.h |    1 +
>  3 files changed, 38 insertions(+), 7 deletions(-)
> 
> -- 
> 1.7.9.2
> 
