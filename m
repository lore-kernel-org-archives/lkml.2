Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab0JIPx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 11:53:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab0JIPx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 11:53:58 -0400
Subject: Re: [PATCH] sched: SCHED_RESET_ON_FORK to recalculate load weights
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>, stable@kernel.org
In-Reply-To: <1286612169-27529-1-git-send-email-linus.walleij@stericsson.com>
References: <1286612169-27529-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Oct 2010 17:53:46 +0200
Message-ID: <1286639626.1891.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-09 at 10:16 +0200, Linus Walleij wrote:
> 
> So we always need to call set_load_weight(), not just if the
> niceval was changed, because the scheduler gives
> SCHED_RR/SCHED_FIFO processes very high weights. 

SCHED_RR/FIFO never uses that weight, we should remove all that cruft..


