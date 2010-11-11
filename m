Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0KKLrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:47:17 -0500
Received: from www.tglx.de ([62.245.132.106]:32859 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab0KKLrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:47:16 -0500
Date: Thu, 11 Nov 2010 12:47:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/6] ce4100: Add errata fixes for UART on CE4100
In-Reply-To: <4CDBD91A.2010805@gmail.com>
Message-ID: <alpine.LFD.2.00.1011111246200.2900@localhost6.localdomain6>
References: <cover.1289331834.git.dirk.brandewie@gmail.com> <395c11879580e72e3a47272ef8cf5e04fa334210.1289331834.git.dirk.brandewie@gmail.com> <alpine.LFD.2.00.1011111231430.2900@localhost6.localdomain6> <4CDBD91A.2010805@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Dirk Brandewie wrote:

> On 11/11/2010 03:34 AM, Thomas Gleixner wrote:
> > 
> > 
> > > +	 * Over ride the legacy port configuration that comes from
> > > +	 * asm/serial.h. Using the ioport driver then switching to the
> > > +	 * PCI memmaped driver hangs the IOAPIC
> > > +	 */
> > > +	if (up->iotype !=  UPIO_MEM32) {
> > > +		up->uartclk  = 14745600;
> > > +		up->mapbase = 0xdffe0200;
> > 
> >    What does the uartclk, mapbase fixups in the CONFIG_EARLY_PRINTK=n case ?
> > 
> This is setup in the PCI driver patch #3 in the series

I just can't find it there, that's why I'm asking :)

Thanks,

	tglx
