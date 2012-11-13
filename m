Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2KMRz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:55:26 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35101 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2KMRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:55:23 -0500
Date: Tue, 13 Nov 2012 18:55:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20121113175517.GA12824@gmail.com>
References: <1351602159-10340-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351602159-10340-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 0d855354ea351bec6b222e9fea86a876cfafdcb6:
> 
>   perf, powerpc: Fix hw breakpoints returning -ENOSPC (2012-10-30 10:07:58 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to f787d9519fb10411f2948f5b9957a1669879ba84:
> 
>   perf tools: Fix strbuf_addf() when the buffer needs to grow (2012-10-30 10:32:56 -0200)
> 
> ----------------------------------------------------------------
> perf/urgent fixes
> 
> .  Fix numa topology printing, from Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Namhyung Kim (2):
>       perf header: Fix numa topology printing
>       perf tools: Fix strbuf_addf() when the buffer needs to grow
> 
>  tools/perf/util/header.c |    2 ++
>  tools/perf/util/strbuf.c |    8 ++++----
>  2 files changed, 6 insertions(+), 4 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
