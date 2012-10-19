Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab2JSOJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:09:13 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:49776 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946Ab2JSOJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:09:12 -0400
Date: Fri, 19 Oct 2012 14:09:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH v2 3/3] mm/sl[aou]b: Move common kmem_cache_size() to
 slab.h
In-Reply-To: <1350649992-25988-3-git-send-email-elezegarcia@gmail.com>
Message-ID: <0000013a795b30e8-b172d712-6376-4b9a-9fea-1dd04669b35c-000000@email.amazonses.com>
References: <1350649992-25988-1-git-send-email-elezegarcia@gmail.com> <1350649992-25988-3-git-send-email-elezegarcia@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Ezequiel Garcia wrote:

> This function is identically defined in all three allocators
> and it's trivial to move it to slab.h
>
> Since now it's static, inline, header-defined function
> this patch also drops the EXPORT_SYMBOL tag.

Acked-by: Christoph Lameter <cl@linux.com>
