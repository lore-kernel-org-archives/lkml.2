Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0HPNaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:30:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab0HPNaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:30:20 -0400
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
From: Peter Zijlstra <peterz@infradead.org>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100816124101.1829415C039@msa104.auone-net.jp>
References: <20100816124101.1829415C039@msa104.auone-net.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 15:30:05 +0200
Message-ID: <1281965405.1926.1387.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 21:41 +0900, Kusanagi Kouichi wrote:
> DASH doesn't support brace expansion.

I really hate these second rate shells, but I guess we could do this on
the grounds of POSIX sh not specifying the brace expansion.

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


