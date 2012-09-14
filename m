Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2INNn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:43:58 -0400
Received: from [205.233.59.134] ([205.233.59.134]:40682 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2INNn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:43:57 -0400
Message-ID: <1347630180.7172.34.camel@twins>
Subject: Re: [RFC][PATCH] perf, intel: Expose SMI_COUNT as a fixed counter
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Fri, 14 Sep 2012 15:43:00 +0200
In-Reply-To: <1347449261.15764.9.camel@twins>
References: <1347449261.15764.9.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 13:27 +0200, Peter Zijlstra wrote:
> Subject: perf, intel: Expose SMI_COUNT as a fixed counter
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Sep 12 13:10:53 CEST 2012
> 
> The Intel SMI_COUNT sadly isn't a proper PMU event but a free-running
> MSR, expose it by creating another fake fixed PMC and another pseudo
> event.

OK, so it looks like this MSR has the same content on all CPUs.. is this
inherent to SMIs or is that just my box being funny?


