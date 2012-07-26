Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2GZJH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:07:56 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:44788 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011Ab2GZJHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:07:54 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI936eI1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M7RG10-02-0QP-02
X-M-MSG: 
Date: Thu, 26 Jul 2012 11:07:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Gleb Natapov <gleb@redhat.com>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120726090745.GM3732@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120723181358.GC6717@infradead.org>
 <500EAF23.8060909@gmail.com>
 <20120724161507.GG3732@erda.amd.com>
 <1343248546.26034.68.camel@twins>
 <20120726055011.GP26120@redhat.com>
 <1343290057.26034.81.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1343290057.26034.81.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.12 10:07:37, Peter Zijlstra wrote:
> On Thu, 2012-07-26 at 08:50 +0300, Gleb Natapov wrote:
> > The commit is 144d31e6, but it introduces hook that is used on VMX only.
> > SVM does not need it to implement guest/host only counters since it
> > has HW support for that in the PMU.
> 
> Right, seems that has changed now that we support IBS.

Will look at this.

-Robert


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

