Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2ILNhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:37:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:33404 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2ILNhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:37:08 -0400
Date: Wed, 12 Sep 2012 15:36:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Attilio Rao <attilio.rao@citrix.com>, Ian.Campbell@citrix.com,
        Stefano.Stabellini@eu.citrix.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v2 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done setup functions and document its
 semantic
In-Reply-To: <20120911124359.GA5459@phenom.dumpdata.com>
Message-ID: <alpine.LFD.2.02.1209121255310.7093@ionos>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208212315330.2856@ionos> <20120822135753.GA30964@phenom.dumpdata.com> <alpine.LFD.2.02.1208221618380.2856@ionos> <20120911124359.GA5459@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > > > The overall result is basically the same, but it's way simpler to look
> > > > at obvious and well done patches than checking whether a subtle copy
> > > > and paste bug happened in 3/5 of the first version. Copy and paste is
> > > > the #1 cause for subtle bugs. :)
> > > > 
> > > > I'm waiting for the ack of Xen folks before taking it into tip.
> 
> In case you are waiting for that - Acked-by: Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com>

Sorry missed the previous ack over traveling.

> > Having it in tip in an extra branch which you pull into your
> > tree. That's the easiest one.
> 
> ping? Which branch should I pull?

  tip/x86/platform head commit: 6428227

Thanks,

	tglx
