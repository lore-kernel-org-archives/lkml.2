Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0FIGcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 02:32:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:38966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0FIGcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 02:32:45 -0400
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <20100609050534.GA5878@linux.vnet.ibm.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
	 <1276012661.2046.120.camel@twins>
	 <20100608173559.GE2800@linux.vnet.ibm.com>
	 <1276024211.15884.107.camel@gandalf.stny.rr.com>
	 <20100609050534.GA5878@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Jun 2010 08:32:30 +0200
Message-ID: <1276065150.2046.1004.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 10:35 +0530, Srikar Dronamraju wrote:

> Peter, can you please point me to the fix for the floating point
> exception patch?

Ingo just commited the fix, see tip commit f6ab91add6 (perf: Fix signed
comparison in perf_adjust_period()).


