Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0FHSg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 14:36:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab0FHSg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 14:36:58 -0400
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
In-Reply-To: <1276011215.15884.96.camel@gandalf.stny.rr.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Jun 2010 20:36:50 +0200
Message-ID: <1276022210.2046.286.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 11:33 -0400, Steven Rostedt wrote:
> I'm pushing this as an RFC first. This probably should be something that
> makes it into 2.6.35.
> 
> Acks and perhaps a little testing from the perf and kprobe angle?


Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


