Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0JOOXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:23:39 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:27038 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756123Ab0JOOXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:23:37 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 58vkgN8VM1msS6HsFMBAn0RDCn_l6JQeOC4aArpB0esedGI
 y9w9umztaqDaTtiK000YJ2HrjDeRxx6yfVN4YcET46qSDYAF48IrKSDY55Sv
 2Uth2Iodagq9vrAw4a0y99yGVMcFQZZVwzCDq2Ied_UF7Ouz9gxDTdtq_8Q3
 OGXAKsZ_D.ASpPspjvYqwYsfpyhJcnGTH1ChS3usL1YvPpzoOpb6qL8g.6M8
 4nWlxeaPZFDfEdgGPzGiIa7dnpjx_
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 15 Oct 2010 09:23:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH net-next] net:  allocate skbs on local node
In-Reply-To: <alpine.DEB.2.00.1010131539440.27839@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1010150922440.22598@router.home>
References: <1286838210.30423.128.camel@edumazet-laptop> <1286839363.30423.130.camel@edumazet-laptop> <1286859925.30423.184.camel@edumazet-laptop> <20101011230322.f0f6dd47.akpm@linux-foundation.org> <1286866699.30423.234.camel@edumazet-laptop>
 <20101012002435.f51f2c0e.akpm@linux-foundation.org> <1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org> <4CB441CB.2000708@cs.helsinki.fi> <alpine.DEB.2.00.1010120745360.31832@router.home>
 <alpine.DEB.2.00.1010121234380.10165@chino.kir.corp.google.com> <alpine.DEB.2.00.1010131056180.29099@router.home> <alpine.DEB.2.00.1010131342310.15185@chino.kir.corp.google.com> <alpine.DEB.2.00.1010131642220.8351@router.home>
 <alpine.DEB.2.00.1010131539440.27839@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 13 Oct 2010, David Rientjes wrote:

> On Wed, 13 Oct 2010, Christoph Lameter wrote:
>
> > > I was going to mention that as an idea, but I thought storing the metadata
> > > for certain debugging features might differ from the two allocators so
> > > substantially that it would be even more convoluted and difficult to
> > > maintain?
> >
> > We could have some callbacks to store allocator specific metadata?
> >
>
> It depends on whether we could share the same base for both slab (unified
> allocator) and slub, which you snipped from your reply, that would make
> this cleaner.

I already said before that we should consider having a common base so I
thought that was not necessary.

