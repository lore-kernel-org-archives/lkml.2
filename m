Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1BOOzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:55:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1BOOzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:55:33 -0500
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v9)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <4d590250.114ddf0a.689e.4482@mx.google.com>
References: <4d590250.114ddf0a.689e.4482@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 15:55:10 +0100
Message-ID: <1297781710.2413.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 11:20 +0200, Stephane Eranian wrote:
> +                       if (mode & PERF_CGROUP_SWOUT) {
> +                               cpu_ctx_sched_out(cpuctx, EVENT_ALL);
> +                               /*
> +                                * must not be done before ctxswout dur
> +                                * to event_filter_match() in event_sched_out()
> +                                */
> +                               cpuctx->cgrp = NULL;
> +                       } 

s/dur/due/ ?
