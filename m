Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2LQNod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:44:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab2LQNoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:44:32 -0500
Date: Mon, 17 Dec 2012 14:44:20 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf test: Check python path on attr test
Message-ID: <20121217134420.GA8415@krava.brq.redhat.com>
References: <1355729101-31317-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355729101-31317-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 04:25:01PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Current perf test code tries to execute python version 2 in order to
> test attributes on perf_event_open syscall.  However it's not default
> python version anymore a system can have python v3 only or v2 with a
> different name (e.g. python2).  So if there's no such python
> interpreter with the name 'python', the test would fail like this
> (yes, it's happened on my new archlinux laptop :).
> 
> 13: struct perf_event_attr setup                 :sh: python: command not found
>  FAILED!
> 
> As we can pass name of the python interpreter on make, use it for
> the attr test also.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
