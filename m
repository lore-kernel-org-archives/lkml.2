Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0KXNSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:18:45 -0500
Received: from www.tglx.de ([62.245.132.106]:35270 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0KXNSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:18:44 -0500
Date: Wed, 24 Nov 2010 14:18:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [question] NR_IRQS in genirq
In-Reply-To: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1011241416360.2900@localhost6.localdomain6>
References: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Haojian Zhuang wrote:

> Hi all,
> 
> I'm using the latest kernel 2.6.37-rc1. Now I met some issues on genirq.
> 
> 1. While SPARSE IRQ is enabled, nr_irqs may be larger than NR_IRQS.
> But the allocated_irqs bitmap (kernel/irq/irqdesc.c) is restricted in
> NR_IRQS. Is it an issue?

Why can nr_irqs become larger? Is that a theoretical problem or did
you run into this ?

Thanks,

	tglx


