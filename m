Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1GAMOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:14:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab1GAMOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:14:21 -0400
Date: Fri, 1 Jul 2011 14:14:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 1/2] mm: Move definition of MIN_MEMORY_BLOCK_SIZE to a
 header
Message-ID: <20110701121408.GC28008@elte.hu>
References: <1308013070.2874.784.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308013070.2874.784.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> The macro MIN_MEMORY_BLOCK_SIZE is currently defined twice in two .c
> files, and I need it in a third one to fix a powerpc bug, so let's
> first move it into a header
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Ingo, Thomas: Who needs to ack the x86 bit ? I'd like to send that
> to Linus asap with the powerpc fix.

Acked-by: Ingo Molnar <mingo@elte.hu>

(btw., you can consider obvious cleanups as being implicitly acked by 
me and don't need to block fixes on me.)

Thanks,

	Ingo
