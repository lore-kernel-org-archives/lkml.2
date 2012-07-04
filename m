Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2GDP0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:26:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42622 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2GDP0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:26:24 -0400
Subject: Re: [PATCH 1/3 v2] slub: prefetch next freelist pointer in
 __slab_alloc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: JoonSoo Kim <js1304@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
In-Reply-To: <CAOJsxLGBxeu2sE-wDT+YNyVipmXiPj7Gvmmdo-0zGmJObp2zxg@mail.gmail.com>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com>
	 <1340390729-2821-1-git-send-email-js1304@gmail.com>
	 <CAOJsxLHSboF0rQdGv8bdgGtinBz5dTo+omQbUnj9on_ewzgNAQ@mail.gmail.com>
	 <CAAmzW4OdDhn5C_vfMhu3ejzzcXmCCt6r0h=nXUqKJaNYZxg8Bw@mail.gmail.com>
	 <CAOJsxLGBxeu2sE-wDT+YNyVipmXiPj7Gvmmdo-0zGmJObp2zxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 17:26:19 +0200
Message-ID: <1341415579.2583.2134.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 18:08 +0300, Pekka Enberg wrote:

> That doesn't seem like that obvious win to me... Eric, Christoph?

Its the slow path. I am not convinced its useful on real workloads (not
a benchmark)

I mean, if a workload hits badly slow path, some more important work
should be done to avoid this at a higher level.


