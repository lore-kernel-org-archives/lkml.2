Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1IUJBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:01:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:48225 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1IUJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:01:44 -0400
Date: Wed, 21 Sep 2011 11:01:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] trace,x86: Add tracepoint to x86 timer interrupt
 handler
In-Reply-To: <1311983978-10350-2-git-send-email-vnagarnaik@google.com>
Message-ID: <alpine.LFD.2.02.1109211053430.2723@ionos>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com> <1311983978-10350-2-git-send-email-vnagarnaik@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, Vaibhav Nagarnaik wrote:

> The x86 timer interrupt handler is the only handler not traced in the
> irq/irq_handler_{entry|exit} trace events.

Nonsense. The timer irq (irq0) comes via the genirq interrupt handling
and not via a special vector. So it's traced already.
 
Thanks,

	tglx
