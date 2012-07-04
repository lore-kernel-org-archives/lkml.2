Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2GDPsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:48:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35688 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2GDPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:48:44 -0400
MIME-Version: 1.0
In-Reply-To: <1341415579.2583.2134.camel@edumazet-glaptop>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com>
	<1340390729-2821-1-git-send-email-js1304@gmail.com>
	<CAOJsxLHSboF0rQdGv8bdgGtinBz5dTo+omQbUnj9on_ewzgNAQ@mail.gmail.com>
	<CAAmzW4OdDhn5C_vfMhu3ejzzcXmCCt6r0h=nXUqKJaNYZxg8Bw@mail.gmail.com>
	<CAOJsxLGBxeu2sE-wDT+YNyVipmXiPj7Gvmmdo-0zGmJObp2zxg@mail.gmail.com>
	<1341415579.2583.2134.camel@edumazet-glaptop>
Date: Thu, 5 Jul 2012 00:48:43 +0900
Message-ID: <CAAmzW4P8itKqMLLUqAAtT7GakKecCixd0PV8y0LgFOL+=g_tZQ@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] slub: prefetch next freelist pointer in __slab_alloc()
From: JoonSoo Kim <js1304@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/5 Eric Dumazet <eric.dumazet@gmail.com>:
> Its the slow path. I am not convinced its useful on real workloads (not
> a benchmark)
>
> I mean, if a workload hits badly slow path, some more important work
> should be done to avoid this at a higher level.
>

In hackbench test, fast path allocation is about to 93%.
Is it insufficient?
