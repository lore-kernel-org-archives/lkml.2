Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2EDPJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:09:14 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35372 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab2EDPJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:09:13 -0400
Date: Fri, 4 May 2012 08:09:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        David Miller <davem@davemloft.net>, namhyung.kim@lge.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] perf: Fix build failure on OpenSuse userspace
Message-ID: <20120504150908.GB23511@kroah.com>
References: <20120503.215020.954262287222794218.davem@davemloft.net>
 <CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
 <CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
 <CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
 <20120504024706.GA10461@kroah.com>
 <CACqU3MUwDaRXwAd3fu7sUmM2ApH+pfu4rf1-TNKt1ja+wYpJ9w@mail.gmail.com>
 <20120504031614.GA12048@kroah.com>
 <20120504070928.GA18351@gmail.com>
 <CACqU3MXRGP3Ep2sJwAB+aOTp9ezifRy+FhVkGjZpzTSW2PhCqg@mail.gmail.com>
 <877gwsxafj.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gwsxafj.fsf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 11:55:44PM +0900, Namhyung Kim wrote:
> Hi,
> 
> On Fri, 4 May 2012 10:44:28 -0400, Arnaud Lacombe wrote:
> > How about my solution, pre-generating the lexer/tokenizer ? It has
> > been used without trouble in other place of the tree for years. I
> > don't really see the point of micro-managing flex/bison issue here.
> >
> 
> There was a discussion:
> 
>   https://lkml.org/lkml/2012/3/27/263

Yes, and I agree with Ingo on this, you can require flex and bison to
build this code, I have no problem with that.

It's the "you must build with this specific version that is not possible
for your distro otherwise the build will break" side affect of this that
I do have a problem with :)

Why can't we turn off "build error on warning" for just these generated
files?

thanks,

greg k-h
