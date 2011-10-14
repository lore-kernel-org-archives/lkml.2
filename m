Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1JNGmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:42:45 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:52772
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1JNGmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:42:44 -0400
Message-ID: <4E97D9E4.4090202@kernel.dk>
Date: Fri, 14 Oct 2011 08:42:44 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
References: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-13 12:02, Ian Campbell wrote:
> A few network drivers currently use skb_frag_struct for this purpose but I have
> patches which add additional fields and semantics there which these other uses
> do not want.
> 
> A structure for reference sub-page regions seems like a generally useful thing
> so do so instead of adding a network subsystem specific structure.

Looks good to me, I can switch struct bio_vec over to this once it's in.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

