Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1ARIUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 03:20:10 -0500
Received: from www.tglx.de ([62.245.132.106]:54194 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1ARIUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 03:20:09 -0500
Date: Tue, 18 Jan 2011 09:19:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Sven Neumann <s.neumann@raumfeld.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Subject: Re: resume regression in 2.6.37
In-Reply-To: <4D349787.80201@metafoo.de>
Message-ID: <alpine.LFD.2.00.1101180917340.6537@localhost6.localdomain6>
References: <1294933492.2535.23.camel@sven> <alpine.LFD.2.00.1101131720350.2678@localhost6.localdomain6> <1294938961.10740.24.camel@sven> <alpine.LFD.2.00.1101131827080.2678@localhost6.localdomain6> <1295260580.2060.29.camel@sven>
 <alpine.LFD.2.00.1101171142380.2678@localhost6.localdomain6> <4D349787.80201@metafoo.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Mon, 17 Jan 2011, Lars-Peter Clausen wrote:
> If you take a look at the pxa gpio irq handling you'll see that it sets the
> "set_wake" field of it's irq_chip after calling set_irq_chip for all of the irqs, so
> the compat handler gets never installed.

Good catch. Can you please resend with a proper changelog and SOB?
Please add 

Cc: stable@kernel.org

after the Signed-off-by line.

Also feel free to add:

Acked-by: Thomas Gleixner <tglx@linutronix.de>
