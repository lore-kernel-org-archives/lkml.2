Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab0EUWic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:38:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:60249 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717Ab0EUWia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:38:30 -0400
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521130417.GB27829@pengutronix.de>
References: <1274433088.1931.63.camel@pasglop>
	 <20100521130417.GB27829@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 May 2010 08:38:13 +1000
Message-ID: <1274481493.1931.98.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 15:04 +0200, Wolfram Sang wrote:
> > Wolfram Sang (4):
> >       powerpc/pmac: Fix dangling pointers
> >       i2c/mpc: Drop NO_IRQ
> >       i2c/cpm: Drop NO_IRQ
> >       i2c/ibm-iic: Drop NO_IRQ
> 
> Sorry for the confusion, but the other Ben (Dooks) has pushed those
> NO_IRQ-thigies meanwhile.

That shouldn't be a problem. git or Linus should sort it out easily :-)
I did a test merge before sending the pull request and there was nothing
it wouldn't resolve automatically.

Cheers,
Ben.


