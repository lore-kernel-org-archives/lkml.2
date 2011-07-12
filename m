Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1GLOEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 10:04:43 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:60792 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1GLOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 10:04:42 -0400
Date: Tue, 12 Jul 2011 10:03:51 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Stephane Eranian <eranian@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, paulus <paulus@samba.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: perf error codes
In-Reply-To: <1310460101.18678.111.camel@twins>
Message-ID: <alpine.DEB.2.00.1107120959450.24091@cl320.eecs.utk.edu>
References: <1310460101.18678.111.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011, Peter Zijlstra wrote:

> Linus recently expressed dislike of our -ENOSPC usage for indicating the
> pmu is 'full'. Do either of your projects (libpfm, libpapi resp.) rely
> on this particular error code for this condition?

PAPI doesn't have any code that relies on ENOSPC.

I have to agree with Linus, when I was working on some validation tests 
and had the buffer size wrong it was very confusing when strerror() told
me the problem was "No space left of device" when none of my disks were 
full.  It took me a while (and some grepping of the kernel source) to 
figure out what was going on.

Vince
