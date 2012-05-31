Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2EaPcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:32:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39071 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab2EaPb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:31:59 -0400
Date: Thu, 31 May 2012 12:31:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/22] perf tools: Backport of latest changes on
 trace-cmd's libparseevent
Message-ID: <20120531153153.GH13591@infradead.org>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
 <87hauwnash.fsf@sejong.aot.lge.com>
 <20120531145230.GF13591@infradead.org>
 <1338476986.13348.347.camel@gandalf.stny.rr.com>
 <20120531151356.GG13591@infradead.org>
 <20120531152242.GB27841@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120531152242.GB27841@somewhere.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 31, 2012 at 05:22:45PM +0200, Frederic Weisbecker escreveu:
> On Thu, May 31, 2012 at 12:13:56PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, May 31, 2012 at 11:09:46AM -0400, Steven Rostedt escreveu:
> > > On Thu, 2012-05-31 at 11:52 -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Thu, May 31, 2012 at 03:07:26PM +0900, Namhyung Kim escreveu:
> > > > > It'd be great if you set up a branch for this so that I can continue to
> > > > > work on it until fully-merged.

> > > > Have you had luck obtaining a git.kernel.org account? It would be better
> > > > if you used git and maintained such branch :-\

> > > Darn it! I wish I signed his key when I had the chance :-p

> > I did it, Frédéric too, so he should have no problem getting an account,
> > I think,
> 
> Except I haven't yet managed to get my korg account back and only Namhyung has
> signed my key. So I'm not going to be very helpful in this regard ;)

I just checked, he got other sigs, so your chain also should be good to
go ;-)

- Arnaldo
