Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab2EPGqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:46:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51625 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759118Ab2EPGqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:46:18 -0400
Date: Wed, 16 May 2012 09:46:13 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: Joonsoo Kim <js1304@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: remove unused argument of init_kmem_cache_node()
In-Reply-To: <alpine.DEB.2.00.1205142326000.19403@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1205160946020.2249@tux.localdomain>
References: <1336665047-22205-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1205142326000.19403@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, David Rientjes wrote:
> On Fri, 11 May 2012, Joonsoo Kim wrote:
> 
> > We don't use the argument since commit 3b89d7d881a1dbb4da158f7eb5d6b3ceefc72810
> > ('slub: move min_partial to struct kmem_cache'), so remove it
> > 
> > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>

Applied, thanks!
