Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0ITR1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:27:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48369 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab0ITR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:27:41 -0400
Message-ID: <4C979992.2080604@kernel.dk>
Date: Mon, 20 Sep 2010 19:27:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [RFC][PATCH 1/2] kernel: remove PF_FLUSHER
References: <20100920151334.569154707@chello.nl> <20100920151839.359805789@chello.nl>
In-Reply-To: <20100920151839.359805789@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-20 17:13, Peter Zijlstra wrote:
> PF_FLUSHER is only ever set, not tested, remove it.

Looks good, it probably didn't get dropped appropriately
when current_is_pdflush() was killed.

-- 
Jens Axboe

