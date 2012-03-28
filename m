Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab2C1OfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:35:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2C1OfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:35:18 -0400
Date: Wed, 28 Mar 2012 11:35:04 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, rostedt@goodmis.org
Subject: Re: [PATCH] perf: missing export.h file
Message-ID: <20120328143504.GD8482@infradead.org>
References: <4F6AF410.1010400@linux.vnet.ibm.com>
 <4F6AFD92.4030603@linux.vnet.ibm.com>
 <4F6C721B.9060807@hitachi.com>
 <4F703FB9.9020407@linux.vnet.ibm.com>
 <4F704A1E.2040401@hitachi.com>
 <20120328114745.GA17936@gmail.com>
 <1332939541.2325.7.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332939541.2325.7.camel@edumazet-glaptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 28, 2012 at 02:59:01PM +0200, Eric Dumazet escreveu:
>     CC util/rbtree.o
> ../../lib/rbtree.c:24:26: error: linux/export.h: No such file or
> directory
> cc1: warnings being treated as errors
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> I must be missing something, why nobody hits this error ???

I think I saw this reported by another person too, checking.

- Arnaldo
 
> diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
> new file mode 100644
> index 0000000..841636d
> --- /dev/null
> +++ b/tools/perf/util/include/linux/export.h
> @@ -0,0 +1,6 @@
> +#ifndef PERF_LINUX_EXPORT_H
> +#define PERF_LINUX_EXPORT_H
> +
> +#define EXPORT_SYMBOL(name)
> +
> +#endif
> 
