Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2JPNrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:47:22 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:23245 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054Ab2JPNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:47:19 -0400
Date: Tue, 16 Oct 2012 13:47:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Richard Kennedy <richard@rsk.demon.co.uk>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] SLUB: remove hard coded magic numbers from
 resiliency_test
In-Reply-To: <alpine.DEB.2.00.1210151753060.31712@chino.kir.corp.google.com>
Message-ID: <0000013a69d41636-b42ca340-7e04-431d-86ca-f38610bfaaf8-000000@email.amazonses.com>
References: <1350145885-6099-1-git-send-email-richard@rsk.demon.co.uk> <1350145885-6099-2-git-send-email-richard@rsk.demon.co.uk> <0000013a66294083-76b27acc-ede7-45d7-849a-0932adecac14-000000@email.amazonses.com>
 <alpine.DEB.2.00.1210151753060.31712@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012, David Rientjes wrote:

> On Mon, 15 Oct 2012, Christoph Lameter wrote:
>
> > > Use the always inlined function kmalloc_index to translate
> > > sizes to indexes, so that we don't have to have the slab indexes
> > > hard coded in two places.
> >
> > Acked-by: Christoph Lameter <cl@linux.com>
> >
>
> Shouldn't this be using get_slab() instead?

Right that would even be better.

