Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0HSKGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:06:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:36056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0HSKGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:06:52 -0400
Subject: Re: [GIT PULL] perf callchains updates
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
In-Reply-To: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 12:06:39 +0200
Message-ID: <1282212399.1926.4628.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 01:46 +0200, Frederic Weisbecker wrote:

> Frederic Weisbecker (6):
>       perf: Drop unappropriate tests on arch callchains
>       perf: Generalize callchain_store()
>       perf: Generalize some arch callchain code
>       perf: Factorize callchain context handling
>       perf: Fix race in callchains
>       perf: Humanize the number of contexts
> 
> Namhyung Kim (1):
>       perf, tracing: add missing __percpu markups

Looks good, thanks Frederic!
