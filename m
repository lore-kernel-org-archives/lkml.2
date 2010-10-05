Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0JEILB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:11:01 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36456 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0JEIK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:10:59 -0400
Date: Tue, 5 Oct 2010 17:10:57 +0900
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
Subject: Re: [PATCH 2/7] perf: New helper function for pmu name
Message-ID: <20101005081057.GB7984@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 09:44:20PM +0100, Matt Fleming wrote:
> Introduce perf_pmu_name() helper function that returns the name of the
> pmu. This gives us a generic way to get the name of a pmu regardless of
> how an architecture identifies it internally, e.g. ARM uses an id
> whereas SH currently uses a string.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

This looks fine too. Later we can see about switching the SH case over to
CPU subtype IDs, but it doesn't matter for now.

Acked-by: Paul Mundt <lethal@linux-sh.org>
