Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2IFQCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:02:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33890 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2IFQCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:02:11 -0400
Message-ID: <1346947316.18408.36.camel@twins>
Subject: Re: [PATCH] perf: remove sw events from multiplexing rotation list
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com
Date: Thu, 06 Sep 2012 18:01:56 +0200
In-Reply-To: <20120906132346.GA32717@quad>
References: <20120906132346.GA32717@quad>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 15:23 +0200, Stephane Eranian wrote:
> Software events (sw,tracepoints,...) do not need to be
> multiplexed. However, when using a SW event, the SW PMU
> (TYPE_SOFTWARE, TYPE_TRACEPOINT) was added to the per-cpu
> rotation_list. That list is used by perf_rotate_context()
> to iterate over all the PMUs to rotate event lists and
> multiplex.
> 
> This is not needed for SW events. Doing this adds some
> unnecessary overhead, so drop it by rejecting SW PMUs
> in perf_pmu_rotate_start().

Thanks!
