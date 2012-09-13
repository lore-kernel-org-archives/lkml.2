Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2IMJNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:13:18 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:42034
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab2IMJNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:13:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI1432I1418I4015Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAA6XU-01-7D8-02
X-M-MSG: 
Date: Thu, 13 Sep 2012 11:13:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: David Ahern <dsahern@gmail.com>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 1/3] perf tool: precise mode requires exclude_guest
Message-ID: <20120913091303.GC8285@erda.amd.com>
References: <1347462990-29481-1-git-send-email-dsahern@gmail.com>
 <1347462990-29481-2-git-send-email-dsahern@gmail.com>
 <20120912174655.GA8285@erda.amd.com>
 <20120912185056.GF10019@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120912185056.GF10019@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.09.12 11:50:57, Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 12, 2012 at 07:46:55PM +0200, Robert Richter escreveu:
> > On 12.09.12 09:16:28, David Ahern wrote:
> > > 
> > > Kernel side AMD currently ignores all exclude_* bits, so there is no impact
> > > to existing IBS code paths. Robert Richter has a patch where IBS code will
> > > return EINVAL if an exclude_* bit is set. When this goes in it means use
> > > of :p on AMD with IBS will first fail with EINVAL (because exclude_guest
> > > will be set). Then the existing fallback code within perf will unset
> > > exclude_guest and try again. The second attempt will succeed if the CPU
> > > supports IBS profiling.
> > > 
> > > Signed-off-by: David Ahern <dsahern@gmail.com>
> > > Cc: Ingo Molnar <mingo@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Robert Richter <robert.richter@amd.com>
> > > Cc: Gleb Natapov <gleb@redhat.com>
> > > Cc: Avi Kivity <avi@redhat.com>
> > > Link: https://lkml.org/lkml/2012/7/9/264
> > > ---
> > >  tools/perf/util/parse-events.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > 
> > Acked-by: Robert Richter <robert.richter@amd.com>
> > 
> > I tested the patch set with AMD IBS and it works fine.
> 
> Ok, I think that in this specific patchset I can add:
> 
> Tested-by: Robert Richter <robert.richter@amd.com>
> Reviewed-by: Robert Richter <robert.richter@amd.com>
> 
> Instead of an Acked-by, may I?

I am fine with this.

Thanks,

-Robert

> 
> - Arnaldo
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

