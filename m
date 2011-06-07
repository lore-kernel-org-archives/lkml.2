Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1FGSb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:31:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57097 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab1FGSb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:31:27 -0400
Date: Tue, 7 Jun 2011 11:30:45 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
Message-ID: <20110607183044.GA1603@noexit.corp.google.com>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
	Shawn Bohrer <sbohrer@rgmadvisors.com>,
	Zachary Vonler <zvonler@rgmadvisors.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Hugh Dickins <hughd@google.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
 <1307373819.3098.40.camel@edumazet-laptop>
 <1307376672.2322.167.camel@twins>
 <1307376989.2322.171.camel@twins>
 <1307377349.3098.65.camel@edumazet-laptop>
 <1307377782.2322.183.camel@twins>
 <1307378564.3098.67.camel@edumazet-laptop>
 <4DED1421.5000300@linux.intel.com>
 <1307383898.3098.90.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307383898.3098.90.camel@edumazet-laptop>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 08:11:38PM +0200, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
> > 
> 
> > If I understand the problem correctly, RO private mapping really doesn't
> > make any sense and we should probably explicitly not support it, while
> > special casing the RO shared mapping in support of David's scenario.
> > 
> 
> We supported them in 2.6.18 kernels, apparently. This might sounds
> stupid but who knows ?

	Trying to come up with a strawman for this sort of operation.
What about a process that creates a private mapping and then creates
threads with CLONE_VM?  Would we CoW in that case?

Joel

-- 

	Pitchers and catchers report.

			http://www.jlbec.org/
			jlbec@evilplan.org
