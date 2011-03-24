Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab1CXIrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:47:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab1CXIra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:47:30 -0400
Date: Thu, 24 Mar 2011 09:47:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf probe: Add fastpath to do lookup by function name
Message-ID: <20110324084717.GG30812@elte.hu>
References: <1300981134-7333-1-git-send-email-ming.m.lin@intel.com>
 <20110324075830.GA28885@elte.hu>
 <1300955923.14111.29.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300955923.14111.29.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> ./perf stat -r 10 -- ./perf probe -k /home/mlin/vmlinux \
>         -s /home/mlin/linux-2.6 \
> 	--line csum_partial_copy_to_user > tmp.log
> 
> before patch applied
> =====================
>         364.535892 task-clock-msecs         #      0.997 CPUs  
>        865,862,109 cycles                   #   2375.245 M/sec 
>      1,255,259,630 instructions             #      1.450 IPC  

> after patch applied
> =====================
>          89.896405 task-clock-msecs         #      0.991 CPUs
>        214,553,875 cycles                   #   2386.679 M/sec
>        226,915,559 instructions             #      1.058 IPC

That's a very nice speedup :-)

Thanks,

	Ingo
