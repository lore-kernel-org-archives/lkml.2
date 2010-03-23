Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0CWTdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:33:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab0CWTdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:33:10 -0400
Date: Tue, 23 Mar 2010 20:32:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf archive: Explain how to use the generated
 tarball
Message-ID: <20100323193246.GA32432@elte.hu>
References: <1269365638-10223-1-git-send-email-acme@infradead.org>
 <20100323184929.GA18815@elte.hu>
 <20100323192952.GA23584@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323192952.GA23584@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Tue, Mar 23, 2010 at 07:49:29PM +0100, Ingo Molnar escreveu:
> > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > 
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > > [root@doppio ~]# perf archive
> > > Now please run:
> > > 
> > > $ tar xvf perf.data.tar.bz2 -C ~/.debug
> > > 
> > > wherever you need to run 'perf report' on.
> > > [root@doppio ~]#
> > 
> > hm, i think it would be nicer to have a way to both pack and unpack an archive 
> > that is in the current directory. Something like:
> > 
> >   perf archive pack
> >   perf archive unpack
> > 
> > or so?
> 
> Yes, its just that this was easy enough to improve the current situation, 
> this is still a shell script that I wrote as a way to show how to do some 
> porcelain out of 'perf buildid-list'.
> 
> But it probably will be better to have it as a full fledged tool, as I can 
> imagine people asking for .tar.xz support, and I also want to be able to 
> tell it to strip debugging information, putting there just the symtabs, etc.

Yeah - although we definitely want to keep it relatively simple - robust 
archiving and cross-system transport is abot simplicity.

> So if you can get this one in, the current situation would be improved and 
> I'll eventually get to implement your suggestion.

Sure, just wanted to mention this.

	Ingo
