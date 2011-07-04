Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab1GDILV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:11:21 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:53676 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1GDILS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:11:18 -0400
Date: Mon, 4 Jul 2011 10:10:53 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 09/11] s390/irqs: Do not trace arch_local_{*,irq_*}
 functions
Message-ID: <20110704101053.38717f0b@mschwide>
In-Reply-To: <20110702033854.283591061@goodmis.org>
References: <20110702030435.308336775@goodmis.org>
	<20110702033854.283591061@goodmis.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jul 2011 23:04:44 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
> Although they are marked inline, gcc may still make a function out of
> them and add it to the pool of functions that are traced by the function
> tracer. This can cause undesirable results (kernel panic, triple faults,
> etc).
> 
> Add the notrace notation to prevent them from ever being traced.
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Applied to git390, thanks Steven.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

