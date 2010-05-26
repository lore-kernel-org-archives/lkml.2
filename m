Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0EZMtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:49:41 -0400
Received: from www.tglx.de ([62.245.132.106]:60410 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0EZMtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:49:40 -0400
Date: Wed, 26 May 2010 14:47:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@lst.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: always use irq stacks
In-Reply-To: <20100526110923.GA28414@lst.de>
Message-ID: <alpine.LFD.2.00.1005261446290.2995@localhost.localdomain>
References: <20100526110923.GA28414@lst.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Christoph Hellwig wrote:

> 
> IRQ stacks provide much better safety against unexpected stack use from
> interrupts, at the minimal downside of slightly higher memory usage.
> Enable irq stacks also for the default 8k stack to minimize the problem
> of stack overflows through interrupt activity.
> 
> This is what x86-64 and various other architectures already do.

We got rid of nested interrupts, so is this really a concern anymore ?

Thanks,

	tglx
