Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2LHO12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:27:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54888 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2LHO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:27:27 -0500
Date: Sat, 8 Dec 2012 15:27:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@au1.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@amd64.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, David Howells <dhowells@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev@ozlabs.org, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, acme@ghostprotocols.net
Subject: Re: [GIT PULL 00/32] perf/core improvements and fixes
Message-ID: <20121208142722.GB9022@gmail.com>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note that I had to do a number of conflict resolutions between 
perf/urgent (now upstream) and perf/core, related to UAPI fixes:

 commit f0b9abfb044649bc452fb2fb975ff2fd599cc6a3
 Merge: adc1ef1 1b3c393
 Author: Ingo Molnar <mingo@kernel.org>
 Date:   Sat Dec 8 15:25:06 2012 +0100

    Merge branch 'linus' into perf/core
    
    Conflicts:
        tools/perf/Makefile
        tools/perf/builtin-test.c
        tools/perf/perf.h
        tools/perf/tests/parse-events.c
        tools/perf/util/evsel.h
    
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

I think I managed to resolve them all correctly - but please 
double check the end result nevertheless.

Thanks,

	Ingo
