Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1AGT4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:56:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:32844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab1AGTz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:55:57 -0500
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
From: Peter Zijlstra <peterz@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110107195016.2334940467@magilla.sf.frob.com>
References: <1293121303.3390.185.camel@Palantir>
	 <20110107192809.05CFF40467@magilla.sf.frob.com>
	 <20110107193547.GA28634@redhat.com>
	 <20110107195016.2334940467@magilla.sf.frob.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Jan 2011 20:56:15 +0100
Message-ID: <1294430175.2016.455.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 11:50 -0800, Roland McGrath wrote:
> I think the constraints on /proc/.../stat reflect the most considered
> judgement of the security folks.  I suspect that the lack of constraint on
> /proc/.../schedstat reflects the scheduler folks just having failed to
> consider the same issues.  IMHO all access to the equivalent kinds of
> information should have the same security constraints. 

FWIW I'm fine with adding a PTRACE_MAY_READ constraint on schedstat.
