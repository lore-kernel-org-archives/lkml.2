Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab2GBK4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:56:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35483 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab2GBK4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:56:08 -0400
Date: Mon, 2 Jul 2012 13:56:03 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: do not call compound_head() in page_get_cache()
In-Reply-To: <alpine.DEB.2.00.1206201837320.7850@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1207021355211.1916@tux.localdomain>
References: <1340233273-10994-1-git-send-email-walken@google.com> <alpine.DEB.2.00.1206201837320.7850@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, David Rientjes wrote:

> On Wed, 20 Jun 2012, Michel Lespinasse wrote:
> 
> > page_get_cache() does not need to call compound_head(), as its unique
> > caller virt_to_slab() already makes sure to return a head page.
> > 
> > Additionally, removing the compound_head() call makes page_get_cache()
> > consistent with page_get_slab().
> > 
> > Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>

The page_get_cache() helper is no longer used in the slab/next branch of

  git://github.com/penberg/linux.git

			Pekka
