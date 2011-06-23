Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1FWBXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:23:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50071 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758041Ab1FWBXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:23:55 -0400
Date: Thu, 23 Jun 2011 02:23:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: Simulating level triggered interrupts with edges
Message-ID: <20110623012352.GD20949@opensource.wolfsonmicro.com>
References: <20110622195008.GC19628@opensource.wolfsonmicro.com>
 <alpine.LFD.2.02.1106222233580.11814@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1106222233580.11814@ionos>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:32:03PM +0200, Thomas Gleixner wrote:

> Though it's non-trivial. Think threaded interrupts, where we cannot
> deal with that in handle_irq_edge(). I have no immediate idea how to
> solve that at the core code, but feel free to have a stab.

Yes, that's why I asked - all the devices I care about have threaded
handlers and I care about a system where the interrupt controller is
threaded too.  I was thinking error handling on set_type() and flags
but thought I must be missing something.  I'll probably have a poke
sometime anyway.
