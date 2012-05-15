Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2EOGcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:32:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41758 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab2EOGcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:32:21 -0400
Date: Mon, 14 May 2012 23:32:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: change cmpxchg_double_slab in get_freelist() to
 __cmpxchg_double_slab
In-Reply-To: <1336665378-2967-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205142332060.19403@chino.kir.corp.google.com>
References: <1336665378-2967-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Joonsoo Kim wrote:

> get_freelist() is only called by __slab_alloc with interrupt disabled,
> so __cmpxchg_double_slab is suitable.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
