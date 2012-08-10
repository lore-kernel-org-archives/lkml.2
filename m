Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2HJNaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 09:30:12 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61072 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2HJNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 09:30:07 -0400
Date: Fri, 10 Aug 2012 15:30:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf tools: Initial bash completion support
Message-ID: <20120810132958.GG27624@somewhere.redhat.com>
References: <1344522713-27951-1-git-send-email-fweisbec@gmail.com>
 <1344522713-27951-2-git-send-email-fweisbec@gmail.com>
 <20120809163515.GA4084@infradead.org>
 <5023E7F3.8090701@gmail.com>
 <20120809171419.GC4084@infradead.org>
 <20120809192706.625671f0@pyramind.ukuu.org.uk>
 <20120809190819.GD4084@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120809190819.GD4084@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:08:19PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Aug 09, 2012 at 07:27:06PM +0100, Alan Cox escreveu:
> > > > 3rd patch should fix this.
> > > 
> > > Huh? The problem is not /etc/bash_completion.d/ not existing, it exists,
> > > its just that I'm not using sudo nor installing as root, this new bash
> > > completion file is the only one that is being installed on the root
> > > filesystem, all others are in ~acme/
> > 
> > And even with permissions it might not have the right security labels on
> > a well secured box.
> > 
> > It's a neat little script (or once its been properly security audited
> > will be) but IMHO it belongs in the distro bash script packages.
> 
> Yeah, I think we can keep it in the kernel sources and then send new
> versions to the bash-completion-devel@lists.alioth.debian.org guys.
> 
> To test I just did:
> 
>   ln -s ~/etc/bash_completion.d/perf ~/.bash_completion
> 
> Frédéric, I merged your patches as-is and pushed them to my perf/core
> branch, thanks!

Thanks!
