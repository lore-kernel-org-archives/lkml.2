Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab2IHB0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:26:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342Ab2IHB0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:26:52 -0400
Date: Fri, 7 Sep 2012 22:26:41 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Shishkin, Alexander" <alexander.shishkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/12] rbtree: adjust root color in rb_insert_color()
 only when necessary
Message-ID: <20120908012641.GA2177@infradead.org>
References: <1342139517-3451-1-git-send-email-walken@google.com>
 <1342139517-3451-8-git-send-email-walken@google.com>
 <50406F60.5040707@intel.com>
 <CANN689EBA6yPk3pS-yXZ1-ticG7eU3mY1mWMWp2S3xhJ73ODFA@mail.gmail.com>
 <20120831011541.ddf8ed78.akpm@linux-foundation.org>
 <5040775C.3070205@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5040775C.3070205@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 31, 2012 at 11:35:40AM +0300, Adrian Hunter escreveu:
> AFAICS tools/perf/util/include/linux is for fixing up the
> differences between kernel headers and exported kernel headers.
> Hence my change:
> 
> diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
> index 7a243a1..2a030c5 100644
> --- a/tools/perf/util/include/linux/rbtree.h
> +++ b/tools/perf/util/include/linux/rbtree.h
> @@ -1 +1,2 @@
> +#include <stdbool.h>
>  #include "../../../../include/linux/rbtree.h"

I applied this one now, thanks,

- Arnaldo
