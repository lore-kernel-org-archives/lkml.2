Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2EDCrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:47:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41669 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab2EDCrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:47:11 -0400
Date: Thu, 3 May 2012 19:47:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: David Miller <davem@davemloft.net>, namhyung.kim@lge.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf build failure on Linus's tree
Message-ID: <20120504024706.GA10461@kroah.com>
References: <20120503215748.GA18995@kroah.com>
 <87sjfgafqj.fsf@sejong.aot.lge.com>
 <20120503.215020.954262287222794218.davem@davemloft.net>
 <CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
 <CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
 <CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 10:35:02PM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Thu, May 3, 2012 at 10:29 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > [...]
> > [0]: http://pkgs.fedoraproject.org/gitweb/?p=flex.git;a=blob;f=flex-2.5.35-hardening.patch;h=7d608ea2371fa3295bdb8eb97c15eeb03029c02b;hb=HEAD
> >
> as a side note, this patch sounds more being about "silencing" than
> "hardening"...

That's nice, but I can build the perf version in 3.3 just fine, so
something broke here (hint, build regression.)  Do I have to bisect it
down to find the problem?

greg
