Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0HPPZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:25:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab0HPPZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:25:20 -0400
Date: Mon, 16 Aug 2010 12:24:52 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
Message-ID: <20100816152452.GB13095@ghostprotocols.net>
References: <20100816124101.1829415C039@msa104.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816124101.1829415C039@msa104.auone-net.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 16, 2010 at 09:41:00PM +0900, Kusanagi Kouichi escreveu:
> DASH doesn't support brace expansion.

Ok, I guess this one is OK :-) Will merge.

- Arnaldo
 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
> ---
>  tools/perf/Makefile |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 41abb90..8fa851b 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -157,8 +157,10 @@ all::
>  #
>  # Define NO_DWARF if you do not want debug-info analysis feature at all.
>  
> -$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
> -$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
> +$(shell sh -c 'mkdir -p $(OUTPUT)scripts/perl/Perf-Trace-Util/' 2> /dev/null)
> +$(shell sh -c 'mkdir -p $(OUTPUT)scripts/python/Perf-Trace-Util/' 2> /dev/null)
> +$(shell sh -c 'mkdir -p $(OUTPUT)util/ui/browsers/' 2> /dev/null)
> +$(shell sh -c 'mkdir -p $(OUTPUT)util/scripting-engines/' 2> /dev/null)
>  $(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
>  
>  $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
> -- 
> 1.7.1
