Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2ENIlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:41:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:46939 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab2ENIlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:41:14 -0400
Date: Mon, 14 May 2012 10:41:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: allmodconfig build broken by gpio changes
In-Reply-To: <20120513.001049.1690048451766768688.davem@davemloft.net>
Message-ID: <alpine.LFD.2.02.1205141039530.3231@ionos>
References: <20120513.001049.1690048451766768688.davem@davemloft.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2012, David Miller wrote:
> 
> You can't reference handle_edge_irq in the pch9 driver, since pch9 can
> be built modular yet handle_edge_irq is not exported to modules.
> 
> I assume allmodconfig is part of your standard validation procedures,

Yep, it is, but I merily posted the patch, w/o running it through my
testing :)

> so I'm really surprised this made it all the way to Linus's tree :-)

Me too :)
