Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1AEPsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:48:38 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42733 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1AEPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:48:37 -0500
Date: Wed, 5 Jan 2011 13:48:21 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20110105154821.GB3159@ghostprotocols.net>
References: <1294161485-28528-1-git-send-email-acme@infradead.org>
 <20110105131117.GC10129@elte.hu>
 <20110105131411.GD10129@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110105131411.GD10129@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 05, 2011 at 02:14:11PM +0100, Ingo Molnar escreveu:
> 
> sorry, had to unpull it:
> 
> util/evsel.c: In function ‘perf_evsel__open_per_cpu’:
> util/evsel.c:137: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
> util/evsel.c:158: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
> util/evsel.c:141: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
> util/evsel.c:142: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
> util/evsel.c:185: note: initialized from here
> cc1: error: dereferencing pointer ‘map__empty.57’ does break strict-aliasing rules
> util/evsel.c:185: note: initialized from here
> make: *** [util/evsel.o] Error 1
> make: *** Waiting for unfinished jobs....
> 
> gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) 
> 
> on a 32-bit Fedora 12 box.

Checking it,

- Arnaldo
