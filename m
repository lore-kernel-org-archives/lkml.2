Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0HQOS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:18:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab0HQOSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:18:25 -0400
Date: Tue, 17 Aug 2010 11:17:54 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
Message-ID: <20100817141754.GF13095@ghostprotocols.net>
References: <20100816124017.BE24D6AC03A@msa102.auone-net.jp> <20100816152410.GA13095@ghostprotocols.net> <20100817140841.0859362C03A@msa106.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817140841.0859362C03A@msa106.auone-net.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 17, 2010 at 11:08:40PM +0900, Kusanagi Kouichi escreveu:
> --- a/tools/perf/feature-tests.mak
> +++ b/tools/perf/feature-tests.mak
> @@ -113,7 +113,7 @@ endef
>  # try-cc
>  # Usage: option = $(call try-cc, source-to-build, cc-options)
>  try-cc = $(shell sh -c						  \
> -	'TMP="$(TMPOUT).$$$$";			 		  \
> +	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
>  	 echo "$(1)" |						  \
>  	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
>  	 rm -f "$$TMP"')

Much better! Will test and merge, thanks!

- Arnaldo
