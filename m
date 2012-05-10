Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2EJIzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:55:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36056 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab2EJIzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:55:37 -0400
Date: Thu, 10 May 2012 10:55:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20120510085531.GA8186@gmail.com>
References: <1336585439-32378-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336585439-32378-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 09c0211c0bb0e40231e6ee9a35041d467ed72f16:
> 
>   perf: Turn off compiler warnings for flex and bison generated files (2012-05-07 10:03:01 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent
> 
> for you to fetch changes up to 20d23aaa31da295378abff4272716e3dfc72baf0:
> 
>   perf stat: handle ENXIO error for perf_event_open (2012-05-09 14:14:41 -0300)
> 
> ----------------------------------------------------------------
> Fix for perf/urgent:
> 
> . Fix handling of older kernels on PPC, from David Ahern.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> David Ahern (1):
>       perf stat: handle ENXIO error for perf_event_open
> 
>  tools/perf/builtin-stat.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Pulled, thanks!

	Ingo
