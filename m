Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0C0XBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:01:03 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:49343 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0C0XBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=kWpQtAe/Owmuo10YeIHnWiiyTkac4YPHpG9Jjbu97d7YJarbb64fKg7VfPkA6tLTdH
         LoOZ5ypJwNTkqur/k1JjIrZ5wTv8AgZeGVu709nfTGT5W4BAQdsNBSECFiF73yogz/bg
         ZrnaTUiUwnlkvXtUHLaEg3FyS2Z05700/Vi+M=
Date: Sat, 27 Mar 2010 20:00:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, k-keiichi@bx.jp.nec.com
Subject: Re: [RFC PATCH 0/7] perf: 'live mode'
Message-ID: <20100327230055.GJ23594@ghostprotocols.net>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
 <20100304111856.GE21977@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100304111856.GE21977@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 04, 2010 at 12:18:56PM +0100, Ingo Molnar escreveu:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > Currently, a perf session entails two steps: first 'perf record' or 'perf 
> > trace record' records the perf data to disk, then 'perf report' or 'perf 
> > trace report' reads the saved data from disk and reports the results.
> > 
> > This experimental patchset makes some changes to perf that instead allow the 
> > perf data to be piped directly from the record step to the report step, 
> > without ever touching the disk.
> 
> Very nice!
> 
> > Obviously, it would be better to have a real top-like display for these 
> > rather than a continuously scrolling mode like this, and of course it will 
> > be much more useful once we get the syscall name injection events going (the 
> > column on the left shows syscall numbers only).
> 
> It's still useful for ad-hoc tracing!
> 
> Side-note, it might make sense to expose the 'clear' escape sequence somehow 
> in an easy fashion:
> 
> [H[2J
> 
> to make it non-scrolling ;-) via a pre-provided method.
> 
> > There are some rough edges and inefficiencies, and I guess 'event injection' 
> > may be a better way to do this in the end, but it seems to work pretty well 
> > already, and I think it shows how useful such a capability can be.
> 
> I'm all for it. Frederic, Steve, what do you think?

ITs really nice indeed, I'm reviewing the patches and will test them
after weekend, it fits nicely with the idea of unifying top and report,
i.e. the refresh thing he mentions could do the decay as well if a
parameter is set.

Thnaks Frederic for pointing this patchset to me.

Great work!

- Arnaldo
