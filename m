Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2DOV1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:27:43 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22005 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2DOV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:27:42 -0400
Date: Sun, 15 Apr 2012 23:27:38 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Xi Wang <xi.wang@gmail.com>
cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] CodingStyle: add kmalloc_array() to memory allocators
In-Reply-To: <1334396894-27176-1-git-send-email-xi.wang@gmail.com>
Message-ID: <alpine.LNX.2.00.1204152326530.18522@swampdragon.chaosbits.net>
References: <1334396894-27176-1-git-send-email-xi.wang@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2012, Xi Wang wrote:

> Add the new kmalloc_array() to the list of general-purpose memory
> allocators in chapter 14.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Cc: Jesper Juhl <jj@chaosbits.net>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Pekka Enberg <penberg@kernel.org>

Looks OK to me.

Acked-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

