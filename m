Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab0FROYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:24:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47301 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265Ab0FROYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=DeS+ISsEGKkBhii6eoVE6DfwpNKqNDCIrRhmx9HPUYfLoDmbQ93mpACN1QEn0T2jNu
         xHvpAMMhDYbdOKGz9WVQiW7+zgt8ktIp2EnBiRE9XNWx3GhikYAnWWxkyOuLJQ7aSxO/
         gouca8P5dgle6iSh7+lOJCKdHaAtzkOtsqWUs=
Date: Fri, 18 Jun 2010 11:24:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       mingo@elte.hu, fweisbec@gmail.com
Subject: Re: [PATCH] perf: Makefile fix for Perl scripting
Message-ID: <20100618142405.GA2645@ghostprotocols.net>
References: <1276836006.7762.15.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276836006.7762.15.camel@tropicana>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 17, 2010 at 11:40:06PM -0500, Tom Zanussi escreveu:
> Fix a typo introduced by recent Makefile changes.  Without it, Perl
> scripting support won't get compiled in.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

Right, sorry about that, applying,

- Arnaldo

> ---
>  tools/perf/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 6aa2fe3..17a3692 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -577,7 +577,7 @@ ifdef NO_LIBPERL
>  else
>  	PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
>  	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
> -	PERL_EMBED_FLAGS=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
> +	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
>  
>  	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
>  		BASIC_CFLAGS += -DNO_LIBPERL
> -- 
> 1.6.4.GIT
> 
> 
