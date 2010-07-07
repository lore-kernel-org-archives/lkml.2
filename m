Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0GFDYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 23:24:47 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:38242 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab0GFDYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 23:24:46 -0400
Date: Wed, 7 Jul 2010 05:15:48 +0000
From: Andres Salomon <dilinger@queued.net>
To: David Miller <davem@davemloft.net>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
       sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, cjb@laptop.org, wmb@laptop.org,
       pgf@laptop.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code out into drivers/of
Message-ID: <20100707051548.2c44f30c@debxo>
In-Reply-To: <20100705.192221.241453945.davem@davemloft.net>
References: <20100629193618.5a840b8e@dev.queued.net>
	<AANLkTilme2uAoXjorUEzam9j_xosR8kl70W8PS71d-Th@mail.gmail.com>
	<20100707040734.05d625af@debxo>
	<20100705.192221.241453945.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jul 2010 19:22:21 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andres Salomon <dilinger@queued.net>
> Date: Wed, 7 Jul 2010 04:07:34 +0000
> 
> >  - For the pdt, calling into the prom once for each property/node to
> >    create a fdt, and then unflattening it.  This is better than the
> >    previous option, but I don't think the prom->fdt code will be
> > very nice.
> 
> I'll need this on sparc64 at some point to support kexec() anyways.
> 
> So at least for sparc you can assume that a something-->fdt translator
> is going to exist at some point in the future regardless of what
> happens here.
> 


Sounds like we have a winner.  I'll concentrate on that, thanks for
the heads up.
