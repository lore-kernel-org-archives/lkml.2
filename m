Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2HGQFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:05:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57754 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab2HGQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:05:17 -0400
Date: Tue, 7 Aug 2012 18:05:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf tools: Support for events bash completion
Message-ID: <20120807160447.GE12858@somewhere.redhat.com>
References: <1344345586-15068-1-git-send-email-fweisbec@gmail.com>
 <1344345586-15068-3-git-send-email-fweisbec@gmail.com>
 <50212AA4.604@gmail.com>
 <20120807170504.35646bf8@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807170504.35646bf8@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 05:05:04PM +0100, Alan Cox wrote:
> > >   		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
> > > +	# List possible events for -e option
> > > +	elif [[ $prev == "-e" && "${COMP_WORDS[1]}" == @(record|stat|top) ]]; then
> > > +		cmds=$(perf list --raw-dump)
> > > +		COMPREPLY=( $( compgen -W '$cmds' -- $cur ) )
> 
> 
> Surely $cur should be quoted here...

Right, fixing that too.

thanks.
 
> Alan
