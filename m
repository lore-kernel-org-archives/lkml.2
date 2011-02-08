Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1BHNxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:53:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab1BHNxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:53:15 -0500
Date: Tue, 8 Feb 2011 11:51:44 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH] perf: fix compile error in annotate.h
Message-ID: <20110208135144.GE7651@ghostprotocols.net>
References: <4d51432a.a7fed80a.1571.fffffe9f@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d51432a.a7fed80a.1571.fffffe9f@mx.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 08, 2011 at 02:20:01PM +0200, Stephane Eranian escreveu:
> The following patch is necessary to compile without NEWT.

Merged already, Borislav Petkov sent a similar patch.

Thanks,

- Arnaldo
 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
> index b1253aa..bc08b36 100644
> --- a/tools/perf/util/annotate.h
> +++ b/tools/perf/util/annotate.h
> @@ -82,7 +82,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
>  			 int max_lines);
>  
>  #ifdef NO_NEWT_SUPPORT
> -static inline int symbol__tui_annotate(symbol *sym __used,
> +static inline int symbol__tui_annotate(struct symbol *sym __used,
>  				       struct map *map __used, int evidx __used)
>  {
>  	return 0;
