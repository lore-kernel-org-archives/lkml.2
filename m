Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2JZJw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:52:29 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:59643 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2JZJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <1351244130.16863.7.camel@twins>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	<1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	<CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
	<1351172849.12171.10.camel@twins>
	<CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
	<1351241389.12171.45.camel@twins>
	<20121026092421.GB628@gmail.com>
	<1351244130.16863.7.camel@twins>
Date: Fri, 26 Oct 2012 11:52:25 +0200
Message-ID: <CAC3jWvKq4uRzNLzW7roXLuNfdT4E4No5rc0vuKPiBSwUOCBECw@mail.gmail.com>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Harald Gustafsson <hgu1972@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, paulmck@linux.vnet.ibm.com, raistlin@linux.it,
        insop.song@ericsson.com, liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>   dl_period * dl_runtime < U64_MAX && dl_deadline * dl_runtime < U64_MAX

I think this makes sense to make the limitation on the product, since
IMO if you need a period longer than 4 seconds then the runtime is
much shorter due to that you want to express something like executing
for 100ms each 10s. Much less likely that an application would need to
execute for 7.8 s out of a period of 8s and would not be happy with
3.9s out of 4s.

/Harald
