Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1KWFaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 00:30:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61677 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1KWFaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 00:30:03 -0500
Date: Tue, 22 Nov 2011 21:30:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] slub: avoid potential NULL dereference or
 corruption
In-Reply-To: <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111222129420.21009@chino.kir.corp.google.com>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1111220855460.25785@router.home> <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> show_slab_objects() can trigger NULL dereferences or memory corruption.
> 
> Another cpu can change its c->page to NULL or c->node to NUMA_NO_NODE
> while we use them.
> 
> Use ACCESS_ONCE(c->page) and ACCESS_ONCE(c->node) to make sure this
> cannot happen.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 

Acked-by: David Rientjes <rientjes@google.com>
