Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab2JRWvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:51:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54885 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2JRWvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:51:01 -0400
Date: Thu, 18 Oct 2012 15:50:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] mm/slob: Use object_size field in
 kmem_cache_size()
In-Reply-To: <1350600107-4558-2-git-send-email-elezegarcia@gmail.com>
Message-ID: <alpine.DEB.2.00.1210181550100.4902@chino.kir.corp.google.com>
References: <1350600107-4558-1-git-send-email-elezegarcia@gmail.com> <1350600107-4558-2-git-send-email-elezegarcia@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Ezequiel Garcia wrote:

> Fields object_size and size are not the same: the latter might include
> slab metadata. Return object_size field in kmem_cache_size().
> Also, improve trace accuracy by correctly tracing reported size.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
