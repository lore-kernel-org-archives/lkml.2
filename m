Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2BPDcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:32:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:60231 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab2BPDcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:32:41 -0500
Message-ID: <1329363097.3772.46.camel@pasglop>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        linaro-kernel@lists.linaro.org, Nicolas Pitre <nico@fluxnic.net>,
        Oleg Nesterov <oleg@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Chan <mike@android.com>, Dave Jones <davej@redhat.com>,
        Todd Poynor <toddpoynor@google.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 16 Feb 2012 14:31:37 +1100
In-Reply-To: <1329318063.2293.136.camel@twins>
References: <20120208013959.GA24535@panacea>
	 <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com>
	 <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu>
	 <4F35DD3E.4020406@codeaurora.org> <20120211144530.GA497@elte.hu>
	 <4F3AEC4E.9000303@codeaurora.org> <1329313085.2293.106.camel@twins>
	 <20120215140245.GB27825@n2100.arm.linux.org.uk>
	 <1329318063.2293.136.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 16:01 +0100, Peter Zijlstra wrote:
> 
> Thing is, the scheduler doesn't care about completion, all it needs is
> to be able to kick-start the thing atomically. So you really have to
> wait for it or can you do an interrupt driven state machine?

Or the scheduler callback could schedule a wq to do the job ?

Cheers,
Ben.


