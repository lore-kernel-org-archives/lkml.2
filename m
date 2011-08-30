Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1H3TLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:11:08 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:48919 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab1H3TLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:11:05 -0400
Subject: Re: [PATCH] perf symbols: Synthesize anonymous mmap events
From: Pekka Enberg <penberg@kernel.org>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110830091506.60b51fe8@kryten>
References: <20110830091506.60b51fe8@kryten>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 30 Aug 2011 22:11:02 +0300
Message-ID: <1314731462.9659.3.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 09:15 +1000, Anton Blanchard wrote:
> perf_event__synthesize_mmap_events does not create anonymous mmap
> events even though the kernel does. As a result an already running
> application with dynamically created code will not get profiled -
> all samples end up in the unknown bucket.
> 
> This patch skips any entries with '[' in the name to avoid adding
> events for special regions (eg the vsyscall page). All other
> executable mmaps are assumed to be anonymous and an event is
> synthesized.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Pekka Enberg <penberg@kernel.org>

