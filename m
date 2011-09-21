Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1IUKGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:06:31 -0400
Received: from tservice.net.ru ([195.178.208.66]:32868 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752416Ab1IUKGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:06:30 -0400
Date: Wed, 21 Sep 2011 14:06:27 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Samuel Ortiz <sameo@linux.intel.com>,
        Andres Salomon <dilinger@queued.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?Q?Jean-Fran=C3=A7ois?= Dagenais <dagenaisj@sonatest.com>,
        Tony Lindgren <tony@atomide.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 50/57] w1: irq: Remove IRQF_DISABLED
Message-ID: <20110921100627.GA15912@ioremap.net>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
 <1316597339-29861-51-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316597339-29861-51-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 05:28:51PM +0800, Yong Zhang (yong.zhang0@gmail.com) wrote:
> Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.

Looks good, thank you.
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
