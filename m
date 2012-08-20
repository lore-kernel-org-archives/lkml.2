Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2HTMUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:20:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:51558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab2HTMUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:20:34 -0400
Message-ID: <1345465225.23018.39.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, dhowells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 14:20:25 +0200
In-Reply-To: <1345465141.5069.0.camel@gandalf.local.home>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
	 <1345463458.23018.37.camel@twins>
	 <1345465141.5069.0.camel@gandalf.local.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 08:19 -0400, Steven Rostedt wrote:
> 
> > > +       for (;;) {
> > > +               if (entry == &dead)
> 
> But your compiler likes "entry == &dead"? ;-)
> 
Yes, fancy as GCC is these days, it doesn't quite bother with the
meta-physical questions just yet.
