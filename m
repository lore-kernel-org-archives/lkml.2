Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab0JEIIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:08:39 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39469 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0JEIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:08:36 -0400
Date: Tue, 5 Oct 2010 17:08:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Robert Richter <robert.richter@amd.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 6/7] sh: oprofile: Use perf-events oprofile backend
Message-ID: <20101005080833.GA7984@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <db62cbe463d5bce89196d6456ad386129ce0022a.1286222593.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db62cbe463d5bce89196d6456ad386129ce0022a.1286222593.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 09:44:24PM +0100, Matt Fleming wrote:
> Now that we've got a generic perf-events based oprofile backend we might
> as well make use of it seeing as SH doesn't do anything special with its
> oprofile backend. Also introduce a new CONFIG_HW_PERF_EVENTS symbol so
> that we can fallback to using the timer interrupt for oprofile if the
> CPU doesn't support perf events.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
