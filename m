Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab1JTJAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:00:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56906 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab1JTJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:00:50 -0400
Date: Thu, 20 Oct 2011 04:59:33 -0400 (EDT)
Message-Id: <20111020.045933.1246070642138310107.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: akpm@linux-foundation.org, rientjes@google.com,
        linux-kernel@vger.kernel.org, hch@infradead.org, jaxboe@fusionio.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
From: David Miller <davem@davemloft.net>
In-Reply-To: <1318927778.16132.52.camel@zakaz.uk.xensource.com>
References: <20111013142201.355f9afc.akpm@linux-foundation.org>
	<1318575363.11016.8.camel@dagon.hellion.org.uk>
	<1318927778.16132.52.camel@zakaz.uk.xensource.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 01:59:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Tue, 18 Oct 2011 09:49:38 +0100

> Subject: [PATCH] mm: add a "struct page_frag" type containing a page, offset and length
> 
> A few network drivers currently use skb_frag_struct for this purpose but I have
> patches which add additional fields and semantics there which these other uses
> do not want.
> 
> A structure for reference sub-page regions seems like a generally useful thing
> so do so instead of adding a network subsystem specific structure.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Acked-by: Jens Axboe <jaxboe@fusionio.com>
> Acked-by: David Rientjes <rientjes@google.com>

Applied, thanks Ian.

Please respin your skbfrag patches.

Thanks again.
