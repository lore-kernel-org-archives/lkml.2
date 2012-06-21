Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab2FUBhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:37:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42079 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab2FUBhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:37:52 -0400
Date: Wed, 20 Jun 2012 18:37:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michel Lespinasse <walken@google.com>
cc: linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: do not call compound_head() in page_get_cache()
In-Reply-To: <1340233273-10994-1-git-send-email-walken@google.com>
Message-ID: <alpine.DEB.2.00.1206201837320.7850@chino.kir.corp.google.com>
References: <1340233273-10994-1-git-send-email-walken@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Michel Lespinasse wrote:

> page_get_cache() does not need to call compound_head(), as its unique
> caller virt_to_slab() already makes sure to return a head page.
> 
> Additionally, removing the compound_head() call makes page_get_cache()
> consistent with page_get_slab().
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: David Rientjes <rientjes@google.com>
