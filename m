Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab0GBVKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 17:10:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759472Ab0GBVKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 17:10:12 -0400
Date: Fri, 2 Jul 2010 17:10:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Chris Metcalf <cmetcalf@tilera.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Break out types from <linux/list.h> to
 <linux/list_types.h>.
Message-ID: <20100702211010.GA8732@infradead.org>
References: <201007021811.04197.arnd@arndb.de>
 <201007021747.o62HlgmV019405@farm-0002.internal.tilera.com>
 <20100702191910.GA5842@parisc-linux.org>
 <201007022243.13270.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007022243.13270.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 10:43:13PM +0200, Arnd Bergmann wrote:
> On Friday 02 July 2010 21:19:11 Matthew Wilcox wrote:
> > Why a new header file instead of linux/types.h?
> 
> I think it mostly makes sense because a list_head by itself usually
> isn't all that useful, you also want the list_add/list_for_each/...
> macros, so you end up including linux/list.h anyway.

It's useful for headers.  You can assume linux/types.h is already
included and don't have to bother to include list{_types}.h everywhere.

