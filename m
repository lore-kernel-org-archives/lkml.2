Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0EUKPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:15:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:51223 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0EUKPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:15:46 -0400
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
 track events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521101347.GC30108@nowhere>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.473188012@chello.nl> <20100521094014.GA30108@nowhere>
	 <1274436125.1674.1690.camel@laptop>  <20100521101347.GC30108@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 12:15:43 +0200
Message-ID: <1274436943.1674.1693.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 12:13 +0200, Frederic Weisbecker wrote:
> > What exactly is the puzzlement about?

> The fact we use the hlist API not for hlist purpose but for a list.

I might miss the confusion, but hlist _are_ lists. Its just that their
structure is slightly different that the regular struct list_head stuff.

