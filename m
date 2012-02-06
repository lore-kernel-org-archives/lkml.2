Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2BFQyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:54:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49191 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2BFQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:54:37 -0500
Subject: Re: [BUG] perf: perf sched warning possibly due to clock
 granularity on AMD
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu, robert.richter@amd.com,
        eric.dumazet@gmail.com, Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20120206164626.GA31704@aftab>
References: <20120206132546.GA30854@quad> <1328538403.2482.4.camel@laptop>
	 <20120206153408.GA31237@aftab> <1328546246.2482.10.camel@laptop>
	 <20120206164626.GA31704@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 17:54:19 +0100
Message-ID: <1328547259.2482.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 17:46 +0100, Borislav Petkov wrote:
> > across all CPUs in the entire system.
> 
> Right, by the "entire system" you mean consistent across cores and
> sockets but not necessarily across cabinets, as in the comment above,
> correct?
> 
> If so, let me ask around if this holds true too.

Every CPU available to the kernel. So if you run a single system image
across your cabinets, then yes those too.

