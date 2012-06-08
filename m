Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab2FHPCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab2FHPCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:02:01 -0400
Date: Fri, 8 Jun 2012 11:01:53 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608150153.GE1711@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
References: <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <1339064814.23343.14.camel@twins>
 <CA+55aFycTypSSvjOB-KXzpK86ALifGbrO2s4HRc69CqyoX=qJA@mail.gmail.com>
 <1339140698.23343.26.camel@twins>
 <20120608143829.GD1711@redhat.com>
 <1339167065.2507.38.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339167065.2507.38.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:51:05PM +0200, Peter Zijlstra wrote:
 
 > >  > Now also compile tested with CONFIG_LOCK_STAT...
 > > 
 > > Doesn't apply against Linus' current tree.
 > > 
 > > $ cat ../lock| patch -p1
 > > patching file include/linux/lockdep.h
 > > Hunk #1 FAILED at 211.
 > > Hunk #2 FAILED at 254.
 > > Hunk #3 FAILED at 363.
 > > Hunk #4 FAILED at 414.
 > > 4 out of 4 hunks FAILED -- saving rejects to file include/linux/lockdep.h.rej
 > > patching file include/trace/events/lock.h
 > > Hunk #1 FAILED at 61.
 > > Hunk #2 FAILED at 78.
 > > 2 out of 2 hunks FAILED -- saving rejects to file include/trace/events/lock.h.rej
 > > patching file kernel/lockdep.c
 > > Hunk #1 FAILED at 541.
 > > Hunk #2 succeeded at 556 with fuzz 2.
 > > Hunk #3 FAILED at 3093.
 > > patch: **** malformed patch at line 268: ck,
 > 
 > weird:

gaah, it's quoted-printable damaged. When I save that in mutt, I get a file that contains crap like

-       lock->cpu =3D cpu;
-       lock->ip =3D ip;


	Dave

