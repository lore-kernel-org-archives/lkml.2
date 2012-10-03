Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2JCEzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:55:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53956 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2JCEzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:55:13 -0400
Date: Tue, 2 Oct 2012 21:55:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] slub: init_kmem_cache_cpus() and put_cpu_partial() can
 be static
In-Reply-To: <20120928083405.GA23740@localhost>
Message-ID: <alpine.DEB.2.00.1210022154520.8723@chino.kir.corp.google.com>
References: <20120928083405.GA23740@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Fengguang Wu wrote:

> Acked-by: Glauber Costa <glommer@parallels.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: David Rientjes <rientjes@google.com>

I think init_kmem_cache_cpus() would also benefit from just being inlined
into alloc_kmem_cache_cpus().
