Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0LMNMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:12:45 -0500
Received: from canuck.infradead.org ([134.117.69.58]:48184 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab0LMNMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:12:43 -0500
Date: Mon, 13 Dec 2010 11:12:18 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, mingo@redhat.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, yakui.zhao@intel.com, fweisbec@gmail.com,
        ling.ma@intel.com, rostedt@goodmis.org, miaox@cn.fujitsu.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: perf monitoring triggers Was: Re: [tip:perf/core] perf bench:
 Print both of prefaulted and no prefaulted results by default
Message-ID: <20101213131218.GC5407@ghostprotocols.net>
References: <1290668693-27068-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <tip-49ce8fc651794878189fd5f273228832cdfb5be9@git.kernel.org>
 <4D03B1AD.7000606@dcl.info.waseda.ac.jp>
 <20101212134657.GA19166@ghostprotocols.net>
 <1292238873.6803.183.camel@twins>
 <20101213123810.GA5407@ghostprotocols.net>
 <1292244059.6803.203.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292244059.6803.203.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 13, 2010 at 01:40:59PM +0100, Peter Zijlstra escreveu:
> On Mon, 2010-12-13 at 10:38 -0200, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Dec 13, 2010 at 12:14:33PM +0100, Peter Zijlstra escreveu:
> > > Sounds to me like you want something like a library with self-monitoring
> > > stuff.

> > Yeah, that could be a way, an LD_PRELOAD thingy that would intercept
> > library calls, setup counters, start a monitoring thread, etc.

> > To make it easier we could move the counter setup we have in record/top
> > to a library, etc.
> 
> Nah, I was more thinking of something along the lines of libPAPI and
> libpfmon. A library that contains the needed building blocks for apps to
> profile themselves.

Ok, you mean for the case where you can modify the app, I was thinking
about when you can't.

In both cases its good to move the counter creation, etc routines from
record/top to a lib, that then could be used in the way you mention, and
in the way I mention too. Two different usecases :-)

- Arnaldo
