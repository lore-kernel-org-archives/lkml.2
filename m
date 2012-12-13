Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2LMNMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:12:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab2LMNMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:12:50 -0500
Date: Thu, 13 Dec 2012 14:10:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 00/14] perf, diff: multiple perf.data file support
Message-ID: <20121213131056.GC1148@krava.brq.redhat.com>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 02:08:58PM +0100, Jiri Olsa wrote:
> hi,
> adding support to display diff for more than 2 perf.data files.
> 
> The basic idea is describe in the initial RFC in here:
> https://lkml.org/lkml/2012/11/28/200
> 
> It's rebased on current Arnaldo's perf core with Namhyung's
> changes.

and it's available in here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/multi12

jirka
