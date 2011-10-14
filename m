Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1JNJR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:17:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5626 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1JNJR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:17:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=uYkV1qlqnAP7raO/W2lun/5ykmJeRWtbgh5VKGOuOHVcIUp4FvO/yTl8DdMvh2T6+
	39fbXyC/mkjuaqcLPjRug==
Date: Fri, 14 Oct 2011 02:17:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jens Axboe <axboe@kernel.dk>
cc: Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
In-Reply-To: <4E97D9E4.4090202@kernel.dk>
Message-ID: <alpine.DEB.2.00.1110140215380.21487@chino.kir.corp.google.com>
References: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com> <4E97D9E4.4090202@kernel.dk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Jens Axboe wrote:

> Looks good to me, I can switch struct bio_vec over to this once it's in.
> 

Looks like it could also be embedded within struct pipe_buffer.
