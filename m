Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0HYQrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 12:47:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36549 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab0HYQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 12:47:07 -0400
Date: Wed, 25 Aug 2010 09:45:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for August 25 (mm/slub)
Message-Id: <20100825094559.bc652afe.randy.dunlap@oracle.com>
In-Reply-To: <20100825132057.c8416bef.sfr@canb.auug.org.au>
References: <20100825132057.c8416bef.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 13:20:57 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100824:


2 separate slub build errors/warnings:

mm/slub.c:1732: error: implicit declaration of function 'slab_pre_alloc_hook'
mm/slub.c:1751: error: implicit declaration of function 'slab_post_alloc_hook'
mm/slub.c:1881: error: implicit declaration of function 'slab_free_hook'
mm/slub.c:1886: error: implicit declaration of function 'slab_free_hook_irq'


and in different builds:

mm/slub.c:1898: note: expected 'struct kmem_cache *' but argument is of type 'struct kmem_cache **'
mm/slub.c:1756: note: expected 'struct kmem_cache *' but argument is of type 'struct kmem_cache **'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
