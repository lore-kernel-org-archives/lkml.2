Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1ADQrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:47:49 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:1393 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1ADQrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:47:48 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEIBZC-01-K0T-02
X-M-MSG: 
Date: Tue, 4 Jan 2011 17:47:37 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Stephane Eranian <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>,
        "eranian@gmail.com" <eranian@gmail.com>
Subject: Re: [PATCH] perf: fix perf_event.h header usage
Message-ID: <20110104164737.GB4739@erda.amd.com>
References: <4d233cf0.2308e30a.7b00.ffffc187@mx.google.com>
 <20110104154439.GA26167@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110104154439.GA26167@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.01.11 10:44:39, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 04, 2011 at 04:30:01PM +0200, Stephane Eranian escreveu:
> > This patch fixes the usage of the perf_event.h header file
> > between command modules and the supporting code in util.
> > 
> > It is necessary to ensure that ALL files use the SAME
> > perf_event.h header from the kernel source tree.
> > 
> > There were a couple of #include <linux/perf_event.h> mixed
> > with #include "../../perf_event.h".
> > 
> > This caused issues on some distros because of mismatch
> > in the layout of struct perf_event_attr. That eventually
> > led perf stat to segfault.
> > 
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> Thanks, applying.

Isn't this valid for all <linux/*.h> header files?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

