Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935480Ab2JXTqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:46:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35208 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935260Ab2JXTqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:46:22 -0400
Date: Wed, 24 Oct 2012 21:46:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, David Howells <dhowells@redhat.com>,
        mingo@kernel.org, tglx@linutronix.de, davem@davemloft.net,
        torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [RFC][PATCH 0/5] tools, perf: Fix up for x86 UAPI disintegration
Message-ID: <20121024194619.GC17945@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Namhyung Kim <namhyung@gmail.com>,
	David Howells <dhowells@redhat.com>, mingo@kernel.org,
	tglx@linutronix.de, davem@davemloft.net,
	torvalds@linux-foundation.org, paulus@samba.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org
References: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
 <20121024184337.GD13993@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121024184337.GD13993@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:43:37AM -0700, Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 19, 2012 at 05:55:58PM +0100, David Howells escreveu:
> > 
> > Here are some potential fix ups for perf and other tools.  They need to be
> > applied on top of the x86 UAPI disintegration patch.
> 
> Borislav, Namhyung, can you take a look at this series?

Sure.

David, where can get that x86 UAPI disintegration patch?

> 
> - Arnaldo
>  
> > There are five patches:
> > 
> >  (1) Use a makefile $(call ...) function in tools/Makefile to make it easier
> >      to deal with.
> > 
> >      [NOTE!  I think the rule for selftests_install is wrong since it attempts
> >       to discard '_clean' from the end of the target name instead of
> >       '_install']

That's right, it should be "...testing/$(@:_install=)" instead. Good catch.

Thanks.

-- 
Regards/Gruss,
    Boris.
