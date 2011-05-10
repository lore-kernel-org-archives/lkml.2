Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1EJIVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:21:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399Ab1EJIVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:21:52 -0400
Date: Tue, 10 May 2011 10:21:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH][Trivial] perf: Only include annotate.h once in
 tools/perf/util/ui/browsers/annotate.c
In-Reply-To: <alpine.LNX.2.00.1104101944070.17706@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1105101021190.28291@pobox.suse.cz>
References: <alpine.LNX.2.00.1104101944070.17706@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Apr 2011, Jesper Juhl wrote:

> Including "../../annotate.h" once in 
> tools/perf/util/ui/browsers/annotate.c is enough. No need to do it twice.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  annotate.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
> index 8c17a87..c1360f7 100644
> --- a/tools/perf/util/ui/browsers/annotate.c
> +++ b/tools/perf/util/ui/browsers/annotate.c
> @@ -5,7 +5,6 @@
>  #include "../../hist.h"
>  #include "../../sort.h"
>  #include "../../symbol.h"
> -#include "../../annotate.h"
>  #include <pthread.h>
>  
>  static void ui__error_window(const char *fmt, ...)

This patch is not present in linux-next as of today. I have picked it up.

-- 
Jiri Kosina
SUSE Labs
