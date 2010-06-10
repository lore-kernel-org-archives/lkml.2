Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0FJUhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:37:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0FJUg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:36:59 -0400
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <1276195271.28329.2.camel@gandalf.stny.rr.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
	 <1276012661.2046.120.camel@twins>
	 <20100608173559.GE2800@linux.vnet.ibm.com>
	 <1276024211.15884.107.camel@gandalf.stny.rr.com>
	 <1276195271.28329.2.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 22:36:40 +0200
Message-ID: <1276202200.2077.820.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 14:41 -0400, Steven Rostedt wrote:
> Can I get an Acked-by from you on this patch? I know you acked the clean
> up version. But this is a minimal fix for .35. We'll add the clean up
> version to .36.

Sure,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
