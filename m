Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0D1V5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:57:09 -0400
Received: from mx1.corp.avencall.com ([91.194.178.12]:56884 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0D1V5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:57:07 -0400
Date: Wed, 28 Apr 2010 23:56:57 +0200
From: Guillaume Knispel <gknispel@proformatique.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <peterz@infradead.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] genirq: reliably replay pending edge-triggered irq
Message-Id: <20100428235657.7120edd9.gknispel@proformatique.com>
In-Reply-To: <alpine.LFD.2.00.1004271537130.2951@localhost.localdomain>
References: <1271941798-9659-1-git-send-email-gknispel@proformatique.com>
	<1271941798-9659-2-git-send-email-gknispel@proformatique.com>
	<alpine.LFD.2.00.1004271537130.2951@localhost.localdomain>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 15:42:11 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 22 Apr 2010, Guillaume Knispel wrote:
[snip] 
> > acked and masked at controller level and IRQ_PENDING is set.
> > ---
> >  arch/arm/Kconfig                                   |    4 ----
> >  arch/arm/configs/acs5k_defconfig                   |    1 -
> >  arch/arm/configs/acs5k_tiny_defconfig              |    1 -
> 
>    Changing the defconfigs should be a separate patch and I'm not
>    going to push such a thing through the genirq tree. The stale
>    entries do not hurt.

Ok
In this separate patch, to I put "genirq" in the title?
Do I put it in the same series?

Cheers,
Guillaume Knispel
