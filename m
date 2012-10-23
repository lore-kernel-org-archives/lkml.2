Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2JWH1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:27:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab2JWH1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:27:12 -0400
Date: Tue, 23 Oct 2012 09:27:03 +0200
From: Andrew Jones <drjones@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: perf: header: Regression
Message-ID: <20121023072702.GB2772@turtle.usersys.redhat.com>
References: <20121022131141.GA11455@turtle.usersys.redhat.com>
 <87sj96hrg4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sj96hrg4.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 11:07:07AM +0900, Namhyung Kim wrote:
> Hi Andrew,
> 
> On Mon, 22 Oct 2012 15:11:42 +0200, Andrew Jones wrote:
> > The patch series that contains 7e94cfcc9d20 regresses the
> > header output. Below is a diff of info from before and
> > after the series
> >
> > 58,64c58,59
> > < # node1 meminfo  : total = 16777216 kB, free = 15712440 kB
> > < # node1 cpu list : 2,6,10,14,18,22,26,30
> > < # node2 meminfo  : total = 16777216 kB, free = 16299132 kB
> > < # node2 cpu list : 1,5,9,13,17,21,25,29
> > < # node3 meminfo  : total = 16777216 kB, free = 16217192 kB
> > < # node3 cpu list : 3,7,11,15,19,23,27,31
> > < # pmu mappings: cpu = 4, software = 1, tracepoint = 2, uncore_bbox_0 =
> > 15, uncore_bbox_1 = 16, uncore_cbox_0 = 7, uncore_cbox_1 = 8,
> > uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, uncore_cbox_5 =
> > 12, uncore_cbox_6 = 13, uncore_cbox_7 = 14, uncore_mbox_0 = 19,
> > uncore_mbox_1 = 20, uncore_rbox_0 = 21, uncore_rbox_1 = 22, uncore_sbox_0
> > = 17, uncore_sbox_1 = 18, breakpoint = 5, uncore_ubox = 6, uncore_wbox =
> > 23
> > ---
> >> # numa topology : not available
> >> # pmu mappings: cpu = 4, software = 1, tracepoint = 2, uncore_bbox_0 =
> > 15, uncore_bbox_1 = 16, uncore_cbox_0 = 7, uncore_cbox_1 = 8,
> > uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, uncore_cbox_5 =
> > 12, uncore_cbox_6 = 13, uncore_cbox_7 = 14, uncore_mbox_0 = 19# pmu
> > mappings: unable to read
> >
> > As can be seen in the diff, before the series we had complete
> > numa info and pmu mappings info. After we get 
> >
> > "# numa topology : not available" and "# pmu
> > mappings: unable to read"
> 
> Hmm.. I couldn't reproduce on my system:
> 
> # node0 meminfo  : total = 33505624 kB, free = 25213528 kB
> # node0 cpu list : 0-11
> # pmu mappings: cpu = 4, software = 1, uncore_pcu = 13, tracepoint = 2,
> uncore_imc_0 = 15, uncore_imc_1 = 16, uncore_imc_2 = 17, uncore_imc_3
> = 18, uncore_qpi_0 = 19, u = 20, uncore_cbox_0 = 7, uncore_cbox_1 = 8,
> uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, un = 12,
> uncore_ha = 14, uncore_r2pcie = 21, uncore_r3qpi_0 = 22,
> uncore_r3qpi_1 = 23, breakpoint = 5, uncore_ubox = 6 
> 
> I don't have a NUMA machine.  Could you send your perf.data file or a
> link via private mail?

I sent a link to my perf.data in a private mail. Let me know if you'd like
me to test a fix.

Thanks,
drew

> 
> Thanks,
> Namhyung
