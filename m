Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab1AOQnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 11:43:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:54767 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1AOQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 11:43:04 -0500
Date: Sat, 15 Jan 2011 14:42:38 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -perf/perf/core ] perf probe: Update perf-probe.txt for
	--funcs
Message-ID: <20110115164238.GA31552@ghostprotocols.net>
References: <4D301C37.2040303@hitachi.com> <20110114095324.4669.90160.stgit@ltc236.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114095324.4669.90160.stgit@ltc236.sdl.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 14, 2011 at 06:53:24PM +0900, Masami Hiramatsu escreveu:
> Add a documentation about functions listing option
> to perf-probe.txt

I think this is not 'perf probe' specific, I think the symbol routines
need a separate tool: 'perf sym' :-)

Continuing reading the other patches.
	
 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Original-patch-from: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  tools/perf/Documentation/perf-probe.txt |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
> index 32d4af3..4df425a 100644
> --- a/tools/perf/Documentation/perf-probe.txt
> +++ b/tools/perf/Documentation/perf-probe.txt
> @@ -73,6 +73,10 @@ OPTIONS
>  	(Only for --vars) Show external defined variables in addition to local
>  	variables.
>  
> +-F::
> +--funcs::
> +	Show available functions in given module or kernel.
> +
>  --filter=FILTER::
>  	(Only for --vars and --funcs) Set filter for variables. FILTER is a
>  	combination of glob pattern, see FILTER PATTERN for detail.
