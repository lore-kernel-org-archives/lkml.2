Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0GHJux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:50:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:41657 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0GHJuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:50:51 -0400
Date: Thu, 8 Jul 2010 11:50:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH] futex: futex_find_get_task remove credentails check
Message-ID: <20100708095050.GA7171@tiehlicka.suse.cz>
References: <1277743748.3561.139.camel@laptop>
 <20100629084230.GE6215@tiehlicka.suse.cz>
 <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com>
 <20100630070115.GB3890@tiehlicka.suse.cz>
 <20100630095525.GA5840@tiehlicka.suse.cz>
 <4C2B742F.6050403@us.ibm.com>
 <20100708092819.GB4925@tiehlicka.suse.cz>
 <20100708093241.GB6057@elte.hu>
 <20100708093919.GC4925@tiehlicka.suse.cz>
 <1278582233.1900.22.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278582233.1900.22.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 08-07-10 11:43:53, Peter Zijlstra wrote:
> On Thu, 2010-07-08 at 11:39 +0200, Michal Hocko wrote:
> > OK, so do you need an ACK from Thomas, or can you grab the patch and
> > push it through one of your trees?
> > 
> Have a look at Linus' tree.

Ahh, you mean 7a0ea09ad5352efce8fe79ed853150449903b9f5. I didn't get any
email about the committing.

Thanks!

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
