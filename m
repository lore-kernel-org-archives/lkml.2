Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1JSBMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 21:12:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39957 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1JSBMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 21:12:40 -0400
Date: Tue, 18 Oct 2011 23:12:33 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/7] perf ui browser: Make the colors configurable and
 change the defaults
Message-ID: <20111019011233.GB3494@ghostprotocols.net>
References: <1318974247-6683-1-git-send-email-acme@infradead.org>
 <1318974247-6683-7-git-send-email-acme@infradead.org>
 <4E9E082D.8040403@gmail.com>
 <20111018235133.GA3494@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018235133.GA3494@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 18, 2011 at 09:51:33PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Oct 18, 2011 at 05:13:49PM -0600, David Ahern escreveu:
> > Using gnome3 with Fedora 15 these last 2 color sets don't look so good.
> > The 'black' background is not really black - more of a gray'ish look and
> > the green font does not show up well. Yes, I get that they are
> > configurable, but the defaults should be readable too.
 
> Yeah, I also noticed that libslang's "black" is kinda like a
> bright black, really strange, I need to figure this out and also how to
> get the colors currently set in the terminal to get this finally like
> --stdio.

Gack, its this problem:

https://bugzilla.redhat.com/show_bug.cgi?id=426948

I know need to continue reading to figure out how to overcome this, as
it seems to only affect libslang based apps, grrr.

Out to bed now tho :-)

- Arnaldo
