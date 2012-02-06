Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2BFO1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:27:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:49811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2BFO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:27:00 -0500
Subject: Re: [BUG] perf: perf sched warning possibly due to clock
 granularity on AMD
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        robert.richter@amd.com, eric.dumazet@gmail.com,
        Borislav Petkov <bp@amd64.org>
In-Reply-To: <20120206132546.GA30854@quad>
References: <20120206132546.GA30854@quad>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 15:26:43 +0100
Message-ID: <1328538403.2482.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 14:25 +0100, Stephane Eranian wrote:
> In summary, two issues:
>   - Why is sched_clock_stable not set or even tested on recent AMD systems?

I'll leave that for Robert to answer, also added Boris to the CC, him
know AMD bits too. 

>   - perf should not rely on fine granularity timestamps in the re-ordering code

Uhm, what else is there?

