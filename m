Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2LSApF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:45:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab2LSApC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:45:02 -0500
Date: Wed, 19 Dec 2012 01:43:11 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tests: Add event parsing test for '*:*'
 tracepoints
Message-ID: <20121219004311.GA1333@krava.redhat.com>
References: <1355749718-4355-1-git-send-email-jolsa@redhat.com>
 <1355749718-4355-4-git-send-email-jolsa@redhat.com>
 <20121218173550.GA27243@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218173550.GA27243@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 02:35:50PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 17, 2012 at 02:08:38PM +0100, Jiri Olsa escreveu:
> > Adding event parsing test for '*:*' tracepoints. Checking the
> > count matches all the tracepoints available plus current
> > standard tracepoint perf_event_attr check.
> > 
> > This test exposes warnings from traceevent lib about not being
> > able to parse some tracepoints' format data. Exposing these
> > messages in the automated test suite will probably speed up
> > the fix ;-)
> 
> Ok, merged, now where is that speedup? ;-)

well.. I did say 'probably' ;-)

thanks,
jirka
