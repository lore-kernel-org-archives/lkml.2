Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab2LRRg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:36:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab2LRRg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:36:26 -0500
Date: Tue, 18 Dec 2012 14:35:50 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tests: Add event parsing test for '*:*'
 tracepoints
Message-ID: <20121218173550.GA27243@infradead.org>
References: <1355749718-4355-1-git-send-email-jolsa@redhat.com>
 <1355749718-4355-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355749718-4355-4-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 17, 2012 at 02:08:38PM +0100, Jiri Olsa escreveu:
> Adding event parsing test for '*:*' tracepoints. Checking the
> count matches all the tracepoints available plus current
> standard tracepoint perf_event_attr check.
> 
> This test exposes warnings from traceevent lib about not being
> able to parse some tracepoints' format data. Exposing these
> messages in the automated test suite will probably speed up
> the fix ;-)

Ok, merged, now where is that speedup? ;-)

- Arnaldo
