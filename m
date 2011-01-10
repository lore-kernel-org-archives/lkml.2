Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1AJXhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:37:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44154 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1AJXhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:37:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=sfUf+mm0UbjL9H6DzQSXawFTfVOtaceaCbgyY4geU/+OEcPv+VRQFByWYFEqT4qfAh
         8AhdOY8F3U5E+JPJxiB4wTZLJZda4ICZmH1vzeBa8VY0okAupen8N1MtL9jSIkz3Iua6
         ypUkHImF3njDiwO+yR7IO4QCkTQrk04dAGCag=
Date: Mon, 10 Jan 2011 21:37:09 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] perf builtin-script: It's enough to include
 util/parse-options.h header once.
Message-ID: <20110110233709.GD19703@ghostprotocols.net>
References: <alpine.LNX.2.00.1101102312160.32164@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101102312160.32164@swampdragon.chaosbits.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 10, 2011 at 11:14:18PM +0100, Jesper Juhl escreveu:
> It should be enough to include util/parse-options.h once in 
> tools/perf/builtin-script.c

Indeed, thanks!
 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  builtin-script.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 150a606..0173a80 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -8,11 +8,10 @@
>  #include "util/parse-options.h"
>  #include "util/session.h"
>  #include "util/symbol.h"
>  #include "util/thread.h"
>  #include "util/trace-event.h"
> -#include "util/parse-options.h"
>  #include "util/util.h"
>  
>  static char const		*script_name;
>  static char const		*generate_script_lang;
>  static bool			debug_mode;
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
