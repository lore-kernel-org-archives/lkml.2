Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0CZS0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 14:26:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:39453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0CZS0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 14:26:43 -0400
Date: Fri, 26 Mar 2010 15:26:26 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Gelmini <andrea.gelmini@gelma.net>, linux-doc@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] Tools perf probe-finder.c: duplicated include
Message-ID: <20100326182626.GL3625@ghostprotocols.net>
References: <1269537767-7553-14-git-send-email-andrea.gelmini@gelma.net> <4BABA088.2000405@redhat.com> <20100326142933.6CA7.A69D9226@jp.fujitsu.com> <4BACD64F.4090005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BACD64F.4090005@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 26, 2010 at 11:44:15AM -0400, Masami Hiramatsu escreveu:
> KOSAKI Motohiro wrote:
> >> Hi Andrea,
> >>
> >> Andrea Gelmini wrote:
> >>> tools/perf/util/probe-finder.c: string.h is included more than once.
> >>
> >> Would you mean that <string.h> and "string.h" are duplicated? 
> >> If so, NAK, sorry. Those are different, <string.h> is for
> >> /usr/include/string.h, and "string.h" is for tools/perf/util/string.h.
> >>
> >> Thank you,
> > 
> > I think this discussion suggested "string.h" should be renameed more review
> > friendly name. probably.

String should be renamed, yes, I'll do that.
 
> Hmm, we'd better review files under tools/utils/include too. :(
> (not sure why we have those files, because some files includes
>  headers from original include directory, as like as 
>  "../../include/linux/blahblah.h")

To share code with the kernel (rbtree.[ch], list.h).

- Arnaldo
