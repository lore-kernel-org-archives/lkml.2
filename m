Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2DNLlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:41:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60039 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2DNLlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:41:35 -0400
Date: Sat, 14 Apr 2012 13:41:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Fix parsers' rules to dependencies
Message-ID: <20120414114129.GF24688@gmail.com>
References: <1334140791-3024-1-git-send-email-jolsa@redhat.com>
 <tip-024e6c9747bb274c9d744ad52a987a0ebec528a6@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-024e6c9747bb274c9d744ad52a987a0ebec528a6@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Jiri Olsa <jolsa@redhat.com> wrote:

> Commit-ID:  024e6c9747bb274c9d744ad52a987a0ebec528a6
> Gitweb:     http://git.kernel.org/tip/024e6c9747bb274c9d744ad52a987a0ebec528a6
> Author:     Jiri Olsa <jolsa@redhat.com>
> AuthorDate: Wed, 11 Apr 2012 12:39:51 +0200
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Wed, 11 Apr 2012 16:57:09 -0300
> 
> perf tools: Fix parsers' rules to dependencies
> 
> Currently the parsers objects (bison/flex related) are each time perf
> is built. No matter the generated files are already in place, the
> parser generation is executed every time.
> 
> Changing the rules to have proper flex/bison objects generation
> dependencies.
> 
> The parsers code is not rebuilt until the flex/bison source files
> are touched. Also when flex/bison source is changed, only dependent
> objects are rebuilt.

Hm, can I cherry-pick this over into perf/urgent? I see no good 
reason why we should leave the v3.4 version half-broken.

Thanks,

	Ingo
