Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0ENQW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:22:28 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63559 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0ENQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AxI+yqB/fS5YxLW4hMeck/1wFYHXGVcoU0Xei/phJdC0xn1QLwX6WYxajyvTNYrpfS
         CfVSuMZIYtkXoyDAk7JE8Z9FQX8ZSU62+DKZhslFV/2ghfaxbEAvl7G5sbWw2aTQ3lzT
         g3dBGyGRxfLhfQAh2p3XzNprWiortMdTIK55Q=
Date: Fri, 14 May 2010 18:22:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/trace: use read() instead of lseek() in
	trace_event_read.c:skip()
Message-ID: <20100514162222.GB5504@nowhere>
References: <1273032130.6383.28.camel@tropicana> <20100514161255.GA8535@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514161255.GA8535@kryptos.osrc.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 06:12:55PM +0200, Borislav Petkov wrote:
> From: Tom Zanussi <tzanussi@gmail.com>
> Date: Tue, May 04, 2010 at 11:02:10PM -0500
> 
> Hi,
> 
> > Here's a small fix for a problem affecting live-mode, introduced in the
> > past day or so:
> > 
> > root@tropicana:~# perf trace rwtop
> > perf trace started with Perl
> > script /root/libexec/perf-core/scripts/perl/rwtop.pl
> > 
> >   Fatal: did not read header event
> > 
> > commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7 added a skip()
> > function to skip over e.g. header_page, but this doesn't work for live
> > mode.  This patch re-implements skip() to use read() instead of
> > lseek() to fix that.
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> has this one landed in any tree in the meantime?
> 
> tip/perf/core doesn't have it.


I forgot to queue it, my bad.

Queued, thanks.

