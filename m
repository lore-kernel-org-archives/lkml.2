Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0LCGKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 01:10:54 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55419 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0LCGKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 01:10:53 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/4] perf/core improvements
From: Ian Munsie <imunsie@au1.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
In-reply-to: <1291318772-30880-1-git-send-email-acme@infradead.org>
References: <1291318772-30880-1-git-send-email-acme@infradead.org>
Date: Fri, 03 Dec 2010 17:10:44 +1100
Message-Id: <1291356549-sup-6865@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Arnaldo Carvalho de Melo's message of Fri Dec 03 06:39:28 +1100 2010:
>     Ian, if you prefer, please test it before Ingo merges it.

Have done so and just about finished rebasing my patches on top of these
- I'll try to get them posted tonight. The bug I was working on is
fixed, so I'm happy :)

I haven't come across the bug that Thomas ran into, but then again I
haven't been testing the non-perf parts of perf for this either.

Which reminds me, does anyone have a test suite for perf other than
./perf test?

Cheers,
-Ian
