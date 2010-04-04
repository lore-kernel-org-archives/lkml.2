Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0DDMyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 08:54:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0DDMyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 08:54:08 -0400
Date: Sun, 4 Apr 2010 09:53:54 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/2] perf newt: Zoom operations
Message-ID: <20100404125354.GA3908@ghostprotocols.net>
References: <1270345250-4833-1-git-send-email-acme@infradead.org>
 <20100404095827.GA30536@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404095827.GA30536@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Apr 04, 2010 at 11:58:27AM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > Arnaldo Carvalho de Melo (2):
> >   perf newt: Add a "Zoom into foo.so DSO" and reverse operations
> >   perf TUI: Add a "Zoom into COMM(PID) thread" and reverse operations
> 
> Pulled, thanks Arnaldo!
> 
> There's still a few basic usability glitches that i've noticed:
> 
>  - it's not clear how to zoom out, once zoomed in

I'll use the title line to store the name of the DSO and Thread and the 
help line to state that to zoom out, press -> + zoom out, and I think
that it is a good idea to use 'd' and 'D' to zoom in/out of DSOs and 't'
and 'T' to zoom in/out of DSOs.
 
>  - there's no help screen and no help line for people to see what can be 
>    done on a given screen. While it's good that the intuitive things work
>    by default (arrow keys, escape, enter, etc.), there should also be additional
>    visual information about what can be done.

F1 and textboxes with a short description of what can be done given for
the first time or till the user presses "Suppress these info boxes" will
be added.
 
>  - i think double escape should exit, right now it stays at the 'are you sure'
>    screen

Here I thought that something had to be done to avoid that accidentally
pressing ESC two times or having "Yes" as default option, trowing away
possibly a long processed session, what do others think about it?

I think that ESC + "Yes" as a default may be ok, as two keys need to be
pressed (ESC + Enter), enough warning/confirmation, I gues, right?

> 	Ingo
