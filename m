Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0DZTI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:08:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab0DZTI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:08:26 -0400
Date: Mon, 26 Apr 2010 16:08:06 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 2/4] perf probe: Fix to use symtab only if no
	debuginfo
Message-ID: <20100426190806.GA8565@ghostprotocols.net>
References: <20100421195616.24664.89980.stgit@localhost6.localdomain6> <20100421195624.24664.46214.stgit@localhost6.localdomain6> <20100426124815.GD7460@ghostprotocols.net> <4BD5E298.4020506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD5E298.4020506@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 26, 2010 at 02:59:36PM -0400, Masami Hiramatsu escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Em Wed, Apr 21, 2010 at 03:56:24PM -0400, Masami Hiramatsu escreveu:
> >> Fix perf probe to use symtab only if there is no debuginfo,
> >> because debuginfo has more precise information than symtab.
> > 
> > "more precise"? Wouldn't it be "more expressive", i.e. with more
> > information (parameter list with types, return type, location of
> > parameters, etc), because what is common to both have the same value,
> > i.e. the function address and size.
> 
> Indeed. debuginfo has just more information than symtab, but
> symtab certainly provides precise information for symbol-address.

I applied the patch, just replaced "more precise information" with "more
information".

- Arnaldo
