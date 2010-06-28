Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0F1Q4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:56:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0F1Q4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:56:45 -0400
Date: Mon, 28 Jun 2010 18:56:43 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: futex: race in lock and unlock&exit for robust futex with PI?
Message-ID: <20100628165643.GE24127@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
 <4C2417AA.4030306@us.ibm.com>
 <20100625082711.GA32765@tiehlicka.suse.cz>
 <4C24ED34.9040808@us.ibm.com>
 <4C253D32.6040304@us.ibm.com>
 <20100628144246.GA14201@tiehlicka.suse.cz>
 <20100628153214.GA24127@tiehlicka.suse.cz>
 <20100628155845.GC24127@tiehlicka.suse.cz>
 <20100628163952.GD24127@tiehlicka.suse.cz>
 <1277743550.3561.136.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277743550.3561.136.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-06-10 18:45:50, Peter Zijlstra wrote:
> On Mon, 2010-06-28 at 18:39 +0200, Michal Hocko wrote:
> 
> > [I am sorry for bombarding you with emails]
> 
> You can lessen the burden on all of us by trimming your emails more
> aggressively. 

OK.

> Your last one has 4 dead tails in it.

I just wanted to have all tracing patches in there, but you are right I
should have removed that they are not helpful anymore. Sorry about that.

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
