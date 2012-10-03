Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2JCOQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:16:27 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:47900 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117Ab2JCOQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:16:26 -0400
Date: Wed, 3 Oct 2012 14:16:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Fengguang Wu <fengguang.wu@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] slub: init_kmem_cache_cpus() and put_cpu_partial() can
 be static
In-Reply-To: <alpine.DEB.2.00.1210022154520.8723@chino.kir.corp.google.com>
Message-ID: <0000013a26fc13cf-2a85d946-fe2b-4180-a5a0-fbe6781a2934-000000@email.amazonses.com>
References: <20120928083405.GA23740@localhost> <alpine.DEB.2.00.1210022154520.8723@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, David Rientjes wrote:

> On Fri, 28 Sep 2012, Fengguang Wu wrote:
>
> > Acked-by: Glauber Costa <glommer@parallels.com>
> > Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
>
> Acked-by: David Rientjes <rientjes@google.com>
>
> I think init_kmem_cache_cpus() would also benefit from just being inlined
> into alloc_kmem_cache_cpus().

The compiler will do that if it is advantageous.

