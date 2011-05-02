Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1EBQe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:34:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:57349 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1EBQex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:34:53 -0400
Date: Mon, 2 May 2011 18:34:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 2 (uml irqs)
In-Reply-To: <20110502091546.5c04f4e6.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.2.02.1105021834240.3005@ionos>
References: <20110502150150.d932642f.sfr@canb.auug.org.au> <20110502091546.5c04f4e6.randy.dunlap@oracle.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Randy Dunlap wrote:

> On Mon, 2 May 2011 15:01:50 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110429:
> 
> 
> building uml on i386 or x86_64 fails with:
> 
> linux-next-20110502/kernel/irq/generic-chip.c: In function 'irq_setup_generic_chip':
> linux-next-20110502/kernel/irq/generic-chip.c:232: error: implicit declaration of function 'readl'

Fix is on the way.
