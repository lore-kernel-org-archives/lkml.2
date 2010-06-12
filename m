Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0FLJnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 05:43:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:43640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0FLJnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 05:43:31 -0400
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1276328098-24114-2-git-send-regression-fweisbec@gmail.com>
References: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
	 <1276328098-24114-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 12 Jun 2010 11:43:11 +0200
Message-ID: <1276335791.2077.3095.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-12 at 09:34 +0200, Frederic Weisbecker wrote:
> In order to introduce new context exclusions, software events will
> have to eventually stop when needed. We'll want perf_event_stop() to
> act on every events.
> 
> To achieve this, remove the stub stop/start pmu callbacks of software
> and tracepoint events that fixed a race in perf_adjust_period, and do
> an explicit check to only reset the hardware event using the
> start/stop callbacks.

I really object to this,. its just too ugly to live.
