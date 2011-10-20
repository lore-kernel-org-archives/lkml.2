Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1JTFlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:41:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36627 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1JTFla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 01:41:30 -0400
Date: Wed, 19 Oct 2011 22:44:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
Message-Id: <20111019224412.396b9a79.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1110192236080.4618@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1110131327470.24853@chino.kir.corp.google.com>
	<20111013.163708.1319779926961023813.davem@davemloft.net>
	<alpine.DEB.2.00.1110131348310.24853@chino.kir.corp.google.com>
	<20111013.165148.64222593458932960.davem@davemloft.net>
	<20111013142201.355f9afc.akpm@linux-foundation.org>
	<1318575363.11016.8.camel@dagon.hellion.org.uk>
	<1318927778.16132.52.camel@zakaz.uk.xensource.com>
	<alpine.DEB.2.00.1110192236080.4618@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011 22:36:30 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Tue, 18 Oct 2011, Ian Campbell wrote:
> 
> > From 806b74572ad63e2ed3ca69bb5640a55dc4475e73 Mon Sep 17 00:00:00 2001
> > From: Ian Campbell <ian.campbell@citrix.com>
> > Date: Mon, 3 Oct 2011 16:46:54 +0100
> > Subject: [PATCH] mm: add a "struct page_frag" type containing a page, offset and length
> > 
> > A few network drivers currently use skb_frag_struct for this purpose but I have
> > patches which add additional fields and semantics there which these other uses
> > do not want.
> > 
> > A structure for reference sub-page regions seems like a generally useful thing
> > so do so instead of adding a network subsystem specific structure.
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > Acked-by: Jens Axboe <jaxboe@fusionio.com>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > [since v1: s/struct subpage/struct page_frag/ on advice from Christoph]
> > [since v2: s/page_offset/offset/ on advice from Andrew]
> 
> Looks good, is this going to be going through net-next?

yes please.
