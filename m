Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab2BIWmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:42:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61007 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2BIWmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:42:51 -0500
Date: Thu, 9 Feb 2012 14:42:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xi Wang <xi.wang@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
In-Reply-To: <4F33CEAE.60400@gmail.com>
Message-ID: <alpine.DEB.2.00.1202091442070.7219@chino.kir.corp.google.com>
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk>
 <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012, Xi Wang wrote:

> This patch introduces a kmalloc_array() wrapper that performs integer
> overflow checking without zeroing the memory.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

assuming there's at least one new user or one existing user that can be 
modified to use the new interface and this won't just sit around not being 
used.
