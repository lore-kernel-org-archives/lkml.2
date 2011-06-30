Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab1F3DPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 23:15:16 -0400
Received: from ozlabs.org ([203.10.76.45]:47827 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab1F3DPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 23:15:13 -0400
Date: Thu, 30 Jun 2011 13:15:09 +1000
From: Anton Blanchard <anton@samba.org>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf report/annotate: Add option to specify a CPU range
Message-ID: <20110630131509.673fa438@kryten>
In-Reply-To: <4E0B69EC.70009@gmail.com>
References: <20110629150739.49b25604@kryten>
	<4E0B69EC.70009@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

> > Add an option to perf report and perf annotate to specify which CPUs
> 
> What about perf-script?

Good point, I added the option to perf script.

> > +	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
> > +		return 0;
> > +
> 
> Need to check that the SAMPLE_CPU attribute is set for the event for
> which the sample is generated; see builtin-script.c,
> perf_evsel__check_attr().

Added.

> This option should be added to the Documentation file,
> Documentation/perf-report.txt

Added. Updated patch on the way.

Thanks,
Anton
