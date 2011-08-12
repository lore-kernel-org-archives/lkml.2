Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1HLTwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:52:37 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:9359
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab1HLTwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:52:34 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LPTZ6J-01-2BI-02
X-M-MSG: 
Date: Fri, 12 Aug 2011 21:51:54 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] perf, x86: Implement IBS event configuration
Message-ID: <20110812195154.GK11702@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-4-git-send-email-robert.richter@amd.com>
 <1312284933.1147.106.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1312284933.1147.106.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.11 07:35:33, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > +static struct perf_ibs perf_ibs_fetch = {
> > +       .pmu = {
> > +               .event_init     = perf_ibs_init,
> > +               .add            = perf_ibs_add,
> > +               .del            = perf_ibs_del,
> > +       },
> > +       .msr                    = MSR_AMD64_IBSFETCHCTL,
> > +       .config_mask            = IBS_FETCH_CONFIG_MASK,
> > +       .cnt_mask               = IBS_FETCH_MAX_CNT,
> > +       .enable_mask            = IBS_FETCH_ENABLE,
> > +};
> > +
> > +static struct perf_ibs perf_ibs_op = {
> > +       .pmu = {
> > +               .event_init     = perf_ibs_init,
> > +               .add            = perf_ibs_add,
> > +               .del            = perf_ibs_del,
> > +       },
> > +       .msr                    = MSR_AMD64_IBSOPCTL,
> > +       .config_mask            = IBS_OP_CONFIG_MASK,
> > +       .cnt_mask               = IBS_OP_MAX_CNT,
> > +       .enable_mask            = IBS_OP_ENABLE,
> >  };
> >   
> 
> It it intentional that you map the IBS things to the hw task_context ?

I didn't get you here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

