Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1AENOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:14:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54189 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab1AENOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:14:24 -0500
Date: Wed, 5 Jan 2011 14:14:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 0/3] perf/core improvements and fixes
Message-ID: <20110105131411.GD10129@elte.hu>
References: <1294161485-28528-1-git-send-email-acme@infradead.org>
 <20110105131117.GC10129@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110105131117.GC10129@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry, had to unpull it:

util/evsel.c: In function ‘perf_evsel__open_per_cpu’:
util/evsel.c:137: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
util/evsel.c:158: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
util/evsel.c:141: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
util/evsel.c:142: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
util/evsel.c:185: note: initialized from here
cc1: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
util/evsel.c:185: note: initialized from here
make: *** [util/evsel.o] Error 1
make: *** Waiting for unfinished jobs....

gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) 

on a 32-bit Fedora 12 box.

Thanks,

	Ingo
