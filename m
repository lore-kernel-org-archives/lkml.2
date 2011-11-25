Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab1KYOLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:11:20 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:13444
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580Ab1KYOLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:11:19 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LV7ZEO-01-8ED-02
X-M-MSG: 
Date: Fri, 25 Nov 2011 15:11:10 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: <mingo@redhat.com>, <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <efault@gmx.de>, <peterz@infradead.org>
Subject: Re: libperf interface stability
Message-ID: <20111125141110.GO15738@erda.amd.com>
References: <new-submission>
 <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org>
 <20111124162845.GB7795@erda.amd.com>
 <20111124181052.GA4058@infradead.org>
 <20111125104535.GN15738@erda.amd.com>
 <20111125114611.GA7098@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111125114611.GA7098@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.11.11 09:46:11, Arnaldo Carvalho de Melo wrote:
> 1) get the above list of c files except for util/python.c that is just
> glue stuff for the python binding and make it the new libperf.a
> 
> 2) make a perf.a that just is libperf.a + the rest of the .c files today
> in libperf.a, i.e. perf.a would be the "just for perf tools for now"
> bundle
> 
> 3) make the python binding be just this new libperf.a + util/python.c
> 
> 4) make libperf.so.0.0.1 be just what is in this new libperf.a

Yeah, I was thinking about something like this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

