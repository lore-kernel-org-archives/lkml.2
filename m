Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0EPWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:25:27 -0400
Received: from toro.web-alm.net ([62.245.132.31]:49355 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab0EPWZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:25:26 -0400
Message-Id: <20100516221844.515632338@osadl.org>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 00:18:44 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/1] tracing/sched: Fix task states in sched_switch event 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> The whole enumeration there is pointless in that .c file - it tells nothing
> to the code reader.

> If it cannot be expressed in a meaningful way then introduce
> TASK_STATE_STRINGS_INIT construct that is defined next to the strings (in a
> .h file or so) - that way it's a coherent whole.
The updated patch
- has all definitions at a common place,
- adapts the related comment,
- makes the string array declaration in fs/proc/array.c a one-liner. 

	Carsten.

