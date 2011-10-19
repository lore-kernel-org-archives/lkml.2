Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1JSNxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:53:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45650 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1JSNxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:53:36 -0400
Date: Wed, 19 Oct 2011 11:53:31 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf ui browser: Honour the xterm colors
Message-ID: <20111019135331.GB2229@ghostprotocols.net>
References: <1318974247-6683-1-git-send-email-acme@infradead.org>
 <1318974247-6683-7-git-send-email-acme@infradead.org>
 <4E9E082D.8040403@gmail.com>
 <20111018235133.GA3494@ghostprotocols.net>
 <20111019011233.GB3494@ghostprotocols.net>
 <20111019024124.GA4596@ghostprotocols.net>
 <4E9E3DE6.6040600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9E3DE6.6040600@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 18, 2011 at 09:03:02PM -0600, David Ahern escreveu:
> On 10/18/2011 08:41 PM, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Oct 18, 2011 at 11:12:33PM -0200, Arnaldo Carvalho de Melo escreveu:
> >> Em Tue, Oct 18, 2011 at 09:51:33PM -0200, Arnaldo Carvalho de Melo escreveu:
> >>> Em Tue, Oct 18, 2011 at 05:13:49PM -0600, David Ahern escreveu:
> >>>> Using gnome3 with Fedora 15 these last 2 color sets don't look so good.
> >>>> The 'black' background is not really black - more of a gray'ish look and

> >>> Yeah, I also noticed that libslang's "black" is kinda like a
> >>> bright black, really strange, I need to figure this out and also how to
> >>> get the colors currently set in the terminal to get this finally like
> >>> --stdio.

> >> https://bugzilla.redhat.com/show_bug.cgi?id=426948

> >> I know need to continue reading to figure out how to overcome this, as

> > Ok, the following patch, that I pushed to my perf/core branch, does the
> > trick...

> Indeed it does. Much better color contrasts -- for me anyways.

Thanks for testing it, really appreciated!

- Arnaldo
