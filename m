Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395Ab2C3U6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:58:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760597Ab2C3U6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:58:46 -0400
Date: Fri, 30 Mar 2012 17:58:37 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf tools: fix build for rbtree.c change
Message-ID: <20120330205837.GI18888@infradead.org>
References: <1333129114-22117-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333129114-22117-1-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 30, 2012 at 10:38:33AM -0700, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> rbtree.c in the main tree now includes linux/export.h, so this file
> needs a stub too. This makes perf build again in mainline.
 

Thank you, this one got fixed already.


> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/include/linux/export.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/util/include/linux/export.h
> 
> diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
> new file mode 100644
> index 0000000..493b181
> --- /dev/null
> +++ b/tools/perf/util/include/linux/export.h
> @@ -0,0 +1 @@
> +#include <linux/module.h>
> -- 
> 1.7.7.6
