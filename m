Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab2EUVMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:12:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:33533 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab2EUVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:12:11 -0400
Date: Mon, 21 May 2012 23:12:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ning Jiang <ning.n.jiang@gmail.com>
cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: Add IRQS_PENDING for nested and simple irq handler as well
In-Reply-To: <CAH3Oq6T-OVj_=kVBdDXxize5v5hovp8FQSDhxCHvF_kcX4QPuA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1205212308590.3231@ionos>
References: <CAH3Oq6T-OVj_=kVBdDXxize5v5hovp8FQSDhxCHvF_kcX4QPuA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Ning Jiang wrote:

> >From eb72d4c573b482f85b227558deca297d8a8de1df Mon Sep 17 00:00:00 2001
> From: Ning Jiang <ning.n.jiang@gmail.com>
> Date: Tue, 22 May 2012 00:19:20 +0800
> Subject: [PATCH] genirq: Add IRQS_PENDING for nested and simple irq
> handler as well
> 
> Usually nested and simple irq act as second level in interrupt
> distribution tree, in suspend, we need to keep first level irq
> functional by irq flag IRQF_NO_SUSPEND and check the 'pending'
> state in the second level.
> 
> More information can be found in the log of commit:

Please provide a proper explanation why you think that handling the
flag for those interrupts is important as well, rather than refering
to an explanation of something different.
 
Thanks,

	tglx
