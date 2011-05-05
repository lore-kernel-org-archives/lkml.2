Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1EEBe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 21:34:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:33060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1EEBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 21:34:25 -0400
Date: Wed, 4 May 2011 22:34:06 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110505013406.GB14297@ghostprotocols.net>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
 <20110503072302.GC18979@aftab>
 <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
 <20110504065843.GC20828@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301C53C9B31@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301C53C9B31@orsmsx505.amr.corp.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 04, 2011 at 02:40:37PM -0700, Luck, Tony escreveu:
> > Yes, i definitely think a gateway to printk would be useful, so that the system 
> > can log MCE events the syslog way as well. This probably makes sense for 
> > persistent events in general, not just MCE events.
> 
> s/as well/instead/ ??? If the persistent event mechanism is correctly feeding
> data to a mart daemon, I don't think we need any printk() chatter. It is only
> if this is not working that we'd want to see some console logging.
> 
> I agree that this isn't just a property of the MCE persistent event - other
> persistent events would very likely want a way to shout for help if the events
> are piling up with no listener.
> 
> > printk itself could become a persistent event. (Transparently and without 
> > breaking compatible syslogd/klogd functionality.)
> 
> Someone from Google was very skeptical of printk() remaining stable from
> release to release ... a big issue when you have some heavy duty infrastructure
> trying to parse and consume these messages.  We should really consider such
> stuff a user visible ABI, and thus not subject to random breakage - which
> is a radical departure from our current attitude to printk().

what is the problem with adding free form additional info to whatever
turns into heavenly for ever unchanged dogma? :-)

- Arnaldo
