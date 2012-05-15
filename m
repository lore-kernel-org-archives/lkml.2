Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2EOG24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:28:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33460 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2EOG2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:28:55 -0400
Date: Mon, 14 May 2012 23:28:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: fix a possible memory leak
In-Reply-To: <1336663979-2611-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205142327580.19403@chino.kir.corp.google.com>
References: <1336663979-2611-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Joonsoo Kim wrote:

> Memory allocated by kstrdup should be freed,
> when kmalloc(kmem_size, GFP_KERNEL) is failed.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

kmem_cache_create() in slub would significantly be improved with a rewrite 
to have a clear error path and use of return values of functions it calls.
