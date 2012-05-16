Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2EPGhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:37:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58053 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126Ab2EPGhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205142327580.19403@chino.kir.corp.google.com>
References: <1336663979-2611-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1205142327580.19403@chino.kir.corp.google.com>
Date: Wed, 16 May 2012 09:37:38 +0300
X-Google-Sender-Auth: yfYsFb9biZ0B5-UyUXGLod2VgJQ
Message-ID: <CAOJsxLFao1nP92mUH7M6UsQu16UqzP_Vi3WasSkQw8Q8tFBDjg@mail.gmail.com>
Subject: Re: [PATCH] slub: fix a possible memory leak
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 9:28 AM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 11 May 2012, Joonsoo Kim wrote:
>
>> Memory allocated by kstrdup should be freed,
>> when kmalloc(kmem_size, GFP_KERNEL) is failed.
>>
>> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>
> Acked-by: David Rientjes <rientjes@google.com>
>
> kmem_cache_create() in slub would significantly be improved with a rewrite
> to have a clear error path and use of return values of functions it calls.

Applied, thanks!
