Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1JNJyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:54:24 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:55591
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1JNJyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:54:23 -0400
Message-ID: <4E9806CE.8020506@kernel.dk>
Date: Fri, 14 Oct 2011 11:54:22 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
References: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com> <4E97D9E4.4090202@kernel.dk> <alpine.DEB.2.00.1110140215380.21487@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110140215380.21487@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-14 11:17, David Rientjes wrote:
> On Fri, 14 Oct 2011, Jens Axboe wrote:
> 
>> Looks good to me, I can switch struct bio_vec over to this once it's in.
>>
> 
> Looks like it could also be embedded within struct pipe_buffer.

Yep, that too.

-- 
Jens Axboe

