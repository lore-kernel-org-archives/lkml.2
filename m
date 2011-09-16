Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1IPMgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:36:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:56478 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1IPMgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:36:49 -0400
Subject: Re: [PATCH] ftrace:  use a global counter for the global clock
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 16 Sep 2011 14:36:43 +0200
In-Reply-To: <1316175506.26295.36.camel@gandalf.stny.rr.com>
References: <1316163765.10174.8.camel@twins>
	 <1316175506.26295.36.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316176603.10174.24.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 08:18 -0400, Steven Rostedt wrote:
> +       return atomic64_add_return(1, &trace_counter);

Oh, fwiw I modified mine to increment by 1000 because we're showing us
in the trace output, 1000 lines with the same 'time'-stamp is slightly
confusing even though you know the order is absolutely right...
