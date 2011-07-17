Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1GQSMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 14:12:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32921 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1GQSMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 14:12:09 -0400
Date: Sun, 17 Jul 2011 20:12:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>, peterz@infradead.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@samba.org
Subject: Re: [PATCH v2] perf tools: fix endian conversion reading event attr
 from file header
Message-ID: <20110717181202.GC29355@somewhere>
References: <1310754849-12474-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310754849-12474-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 12:34:09PM -0600, David Ahern wrote:
> The perf_event_attr struct has 2 __u32's at the top and need to
> be swapped individually. With this change I was able to analyze
> a perf.data collected in a 32-bit PPC VM on an x86 system. I
> tested both 32-bit and 64-bit binaries for the Intel analysis
> side; both read the PPC perf.data file correctly.
> 
> v1 -> v2:
> - changed the existing perf_event__attr_swap to swap only elements
>   of perf_event_attr and exported it for use in swapping the
>   attributes in the file header
> - updated swap_ops used for processing events
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
