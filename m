Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab2FLChF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:37:05 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34697 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2FLChD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:37:03 -0400
X-AuditID: b753bd60-9f483ba000000655-e6-4fd6ab4c19d5
X-AuditID: b753bd60-9f483ba000000655-e6-4fd6ab4c19d5
Message-ID: <4FD6AB49.3010809@hitachi.com>
Date: Tue, 12 Jun 2012 11:36:57 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Reply-To: yoshihiro.yunomae.ez@hitachi.com
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: ivring driver
References: <20120605152947.GA21787@Krystal>
In-Reply-To: <20120605152947.GA21787@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/06 0:29), Mathieu Desnoyers wrote:
> Hi Yoshihiro,
>
> I stumbled on your post on ivring (https://lkml.org/lkml/2012/6/5/143)
> for buffering trace data from guest to host. I notice that it would be
> very interesting to see a comparison of its performance against:
>
> - ftrace ring buffer
> - perf ring buffer
> - lttng 2.0 ring buffer
> - lttng-ust 2.0 (user-space tracing) ring buffer

Hi Mathieu. Thank you for commenting on how to compare among
ring-buffer's performances. And sorry, I'm late for replying to you.

> Comparing only with network-related mechanisms does not seem to provide
> a complete picture of where it stands wrt other ring buffers out there.
>
> One of the metric we have used in the past is the number of nanoseconds
> it takes to write a single event, based on a test that writes lots of
> events into various buffer sizes, into flight recorder mode buffers
> (which overwrites oldest information on buffer full condition, with data
> collection to disk disabled, to remove I/O from the picture -- I/O can
> then be performed in "snapshot" mode, after some error condition is
> detected).

OK, I see. When the overhead of ring-buffers will be evaluated in
the next, I may use the metric as a reference.

Thank you,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
