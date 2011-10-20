Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1JTJEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:04:42 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:52703 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab1JTJEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:04:40 -0400
X-IronPort-AV: E=Sophos;i="4.69,378,1315180800"; 
   d="scan'208";a="8492172"
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Miller <davem@davemloft.net>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Thu, 20 Oct 2011 10:04:39 +0100
In-Reply-To: <20111020.045933.1246070642138310107.davem@davemloft.net>
References: <20111013142201.355f9afc.akpm@linux-foundation.org>
	 <1318575363.11016.8.camel@dagon.hellion.org.uk>
	 <1318927778.16132.52.camel@zakaz.uk.xensource.com>
	 <20111020.045933.1246070642138310107.davem@davemloft.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1319101479.3385.131.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 09:59 +0100, David Miller wrote:
> From: Ian Campbell <Ian.Campbell@citrix.com>
> Date: Tue, 18 Oct 2011 09:49:38 +0100
> 
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
> 
> Applied, thanks Ian.
> 
> Please respin your skbfrag patches.

I think I must've hit send on the respin at about the same time you hit
send on your mail...

> 
> Thanks again.


