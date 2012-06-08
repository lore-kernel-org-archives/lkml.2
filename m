Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab2FHQxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:53:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57026 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760681Ab2FHQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:53:20 -0400
Date: Fri, 8 Jun 2012 18:53:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephane Eranian <eranian@google.com>,
        jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120608165319.GC27374@one.firstfloor.org>
References: <20120607202355.GQ27374@one.firstfloor.org> <CABPqkBQ99PTsET6c_NPuioLUr_yto4x=6EBQ1K73N4ratHz48A@mail.gmail.com> <20120607205836.GT27374@one.firstfloor.org> <20120607212759.GD30641@infradead.org> <20120608031009.GV27374@one.firstfloor.org> <20120608154814.GA21250@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608154814.GA21250@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 12:48:14PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jun 08, 2012 at 05:10:09AM +0200, Andi Kleen escreveu:
> > > Are you sure the old one works? Perhaps it silently falls back to
> > > cpu-clock?
>  
> > Yes i'm sure. I was actually debugging some kernel pebs code,
> > and had a heavily instrumented pebs code path and was first trying
> > to figure out what went wrong in the kernel, until I realized 
> > that the userland was broken.
> > 
> > Does :p work for anyone else?
> 
> It seems to work for Linus on Ivy Bridge with what is on tip/perf/urgent

Hmm, maybe some local problem. I'll do some debugging and a bisect.

-Andi
