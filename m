Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab0DWQIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:08:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940Ab0DWQIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:08:15 -0400
Date: Fri, 23 Apr 2010 09:05:25 -0700
From: Greg KH <gregkh@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [170/197] lockdep: fix incorrect percpu usage
Message-ID: <20100423160525.GC8048@suse.de>
References: <20100422191857.GA13268@kroah.com>
 <20100422190922.618832798@kvm.kroah.org>
 <20100422210840.GB6856@nik-comp.linuxbox.cz>
 <20100422220249.GB15195@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422220249.GB15195@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 06:02:49PM -0400, Mathieu Desnoyers wrote:
> * Nikola Ciprich (nikola.ciprich@linuxbox.cz) wrote:
> > Hi,
> > hmm,
> > this one seems to break compilation for me:
> > kernel/lockdep.c: In function ‘static_obj’:
> > kernel/lockdep.c:595: error: invalid use of array with unspecified bounds
> > kernel/lockdep.c:595: error: invalid use of array with unspecified bounds
> > make[1]: *** [kernel/lockdep.o] Error 1
> > 
> > I'm using gcc-4.1.2
> > regards
> > nik
> > 
> 
> Oh, you are right. I tweaked a few config options and got your error. Here is an
> updated patch.
> 
> Greg, this v2 should replace the original patch you have. Sorry about the
> trouble.

No problem, I've fixed it up now.

thanks,

greg k-h
