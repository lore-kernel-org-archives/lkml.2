Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0CWTaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:30:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0CWTaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:30:02 -0400
Date: Tue, 23 Mar 2010 16:29:52 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf archive: Explain how to use the generated
 tarball
Message-ID: <20100323192952.GA23584@ghostprotocols.net>
References: <1269365638-10223-1-git-send-email-acme@infradead.org>
 <20100323184929.GA18815@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323184929.GA18815@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 23, 2010 at 07:49:29PM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > [root@doppio ~]# perf archive
> > Now please run:
> > 
> > $ tar xvf perf.data.tar.bz2 -C ~/.debug
> > 
> > wherever you need to run 'perf report' on.
> > [root@doppio ~]#
> 
> hm, i think it would be nicer to have a way to both pack and unpack an archive 
> that is in the current directory. Something like:
> 
>   perf archive pack
>   perf archive unpack
> 
> or so?

Yes, its just that this was easy enough to improve the current
situation, this is still a shell script that I wrote as a way to show
how to do some porcelain out of 'perf buildid-list'.

But it probably will be better to have it as a full fledged tool, as I
can imagine people asking for .tar.xz support, and I also want to be
able to tell it to strip debugging information, putting there just the
symtabs, etc.

So if you can get this one in, the current situation would be improved
and I'll eventually get to implement your suggestion.

- Arnaldo
