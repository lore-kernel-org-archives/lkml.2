Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1KYKpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:45:46 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:56482
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044Ab1KYKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:45:44 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LV7PW2-01-NMU-02
X-M-MSG: 
Date: Fri, 25 Nov 2011 11:45:35 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: <mingo@redhat.com>, <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <efault@gmx.de>, <peterz@infradead.org>
Subject: Re: libperf interface stability
Message-ID: <20111125104535.GN15738@erda.amd.com>
References: <new-submission>
 <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org>
 <20111124162845.GB7795@erda.amd.com>
 <20111124181052.GA4058@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111124181052.GA4058@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.11.11 16:10:52, Arnaldo Carvalho de Melo wrote:
> Em Thu, Nov 24, 2011 at 05:28:45PM +0100, Robert Richter escreveu:
> > It would be good to have a well defined, stable libperf interface for
> > tools other than perf.
> 
> Agreed, an effort in this direction was the perf python binding, that so
> far includes only:
> 
> tools/perf/util/setup.py
> 
> 	sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
> 		   'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
> 		   'util/util.c', 'util/xyarray.c', 'util/cgroup.c',
> 		   'util/debugfs.c'],
> 
> You need https://github.com/acmel/linux/commits/perf/urgent to build it
> tho, it has a fix for that:
> 
> In the end it generates a ~/build/perf/python/perf.so file (I use make
> -C tools/perf O=/home/acme/build/perf) that has all that is needed for
> simple tools like tools/perf/python/twatch.py.
> 
> I think of it as a precursor for a shared library for use with C and I
> have been working on untangling references such as the symbol_conf one
> you mentioned and making the 'perf_evlist' and 'perf_evsel' classes the
> main way to work with libperf.

Thanks Arnaldo, will then take this as a base to start with.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

