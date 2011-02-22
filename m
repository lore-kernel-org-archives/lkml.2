Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1BVSBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:01:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1BVSBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:01:23 -0500
Date: Tue, 22 Feb 2011 15:01:10 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf lock: show valid sort keys in usage
Message-ID: <20110222180110.GG27070@ghostprotocols.net>
References: <20110222174557.GB9687@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222174557.GB9687@joi.lan>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 22, 2011 at 06:45:57PM +0100, Marcin Slusarz escreveu:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> ---
>  tools/perf/builtin-lock.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index 2b36def..0305a40 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -893,7 +893,7 @@ static const char * const report_usage[] = {
>  
>  static const struct option report_options[] = {
>  	OPT_STRING('k', "key", &sort_key, "acquired",
> -		    "key for sorting"),
> +		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
>  	/* TODO: type */
>  	OPT_END()
>  };

Can you please add to tools/perf/Documentation/perf-lock.txt too?

Thanks,

- Arnaldo
