Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2GMTU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:20:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:46259 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2GMTU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:20:28 -0400
Date: Fri, 13 Jul 2012 21:20:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Seiji Aguchi <seiji.aguchi@hds.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "vnagarnaik@google.com" <vnagarnaik@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH]trace,x86: add x86 irq vector tracepoints
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40F08E421@USINDEM101.corp.hds.com>
Message-ID: <alpine.LFD.2.02.1207132115500.32033@ionos>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AA07@USINDEM103.corp.hds.com> <1341521053.21574.22.camel@gandalf.stny.rr.com> <A5ED84D3BB3A384992CBB9C77DEDA4D40F08E359@USINDEM101.corp.hds.com> <alpine.LFD.2.02.1207131727430.32033@ionos>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40F08E421@USINDEM101.corp.hds.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Seiji Aguchi wrote:

> > Those x86 specific ones are not really frequently raised vectors,
> > so enabling them all won't affect performance and readability of
> > the traces too much.
> 
> OK. I will unify these to a single tracepoint.
> "x86_irq_vector" or so?

I'd rather see a real generic one, which can be used by other
architectures for their esoteric non common vectors as well.

Something like misc_vector_entry/exit. Any better name is welcome :)

Thanks,

	tglx


