Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2FGV2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2FGV2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:28:10 -0400
Date: Thu, 7 Jun 2012 18:28:00 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120607212759.GD30641@infradead.org>
References: <20120607202355.GQ27374@one.firstfloor.org>
 <CABPqkBQ99PTsET6c_NPuioLUr_yto4x=6EBQ1K73N4ratHz48A@mail.gmail.com>
 <20120607205836.GT27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120607205836.GT27374@one.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 07, 2012 at 10:58:36PM +0200, Andi Kleen escreveu:
> On Thu, Jun 07, 2012 at 10:53:19PM +0200, Stephane Eranian wrote:
> > On Thu, Jun 7, 2012 at 10:23 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > >
> > > With a perf user tool compiled from a 3.5rc1+ kernel I cannot
> > > use the 'p' attribute anymore. Always get
> > >
> > > ak@petrock:~> ./perf record -e cycles:p ./t
> > >
> > >  Error: sys_perf_event_open() syscall returned with 22 (Invalid argument).  /bin/dmesg may provide additional information.
> > >
> > >  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> > >
> > Remember that PEBS is disabled on SNB unless you have the new ucode + my patch.
> 
> This is not the problem. This was actually a -E where it was not disabled
> in my tree.  And the older perf binary works, so it's clearly not a kernel 
> problem.

Are you sure the old one works? Perhaps it silently falls back to
cpu-clock?

What 'perf evlist -v' says?

- Arnaldo
