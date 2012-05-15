Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2EOG0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:26:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45992 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2EOG0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:26:14 -0400
Date: Mon, 14 May 2012 23:26:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: remove unused argument of init_kmem_cache_node()
In-Reply-To: <1336665047-22205-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205142326000.19403@chino.kir.corp.google.com>
References: <1336665047-22205-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Joonsoo Kim wrote:

> We don't use the argument since commit 3b89d7d881a1dbb4da158f7eb5d6b3ceefc72810
> ('slub: move min_partial to struct kmem_cache'), so remove it
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
