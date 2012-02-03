Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2BCSBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:01:11 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34194 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab2BCSBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:01:09 -0500
Date: Fri, 3 Feb 2012 10:00:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 01/41] rcu: Bring RTFP.txt up to date.
Message-ID: <20120203180047.GE2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202001814.GA29058@leaf>
 <20120202013305.GT2382@linux.vnet.ibm.com>
 <20120202020100.GK29058@leaf>
 <20120202164725.GL2518@linux.vnet.ibm.com>
 <20120202223236.GD9279@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202223236.GD9279@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020318-7182-0000-0000-000000ACF7E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:32:36PM -0800, Josh Triplett wrote:
> On Thu, Feb 02, 2012 at 08:47:25AM -0800, Paul E. McKenney wrote:

[ . . . ]

> > > Not in this case, though.  This one should have the year as either 2008
> > > or 2010 depending on which date you count.
> > 
> > Odd.  Color me confused.  This is 7,426,511, which was filed in 2004 and
> > granted in 2008.  Fixed.  I think, anyway.  I am -so- confused!  ;-)
> 
> I think I can clear up the confusion here.  Three different relevant
> patents exist:
> 
> - Patent 7,426,511, titled "Efficient support of consistent cyclic
>   search with read-copy-update", filed 2004-03-08 and granted
>   2008-09-16.
> 
> - Patent 7,814,082, a continuation of 7,426,511, *also* titled
>   "Efficient support of consistent cyclic search with read-copy-update",
>   filed 2008-03-18 and granted 2010-10-12.  I grabbed the text of
>   7,426,511 and this one, and ran them through git diff --no-index
>   --color-words; it looks like 7,814,082 contains some very minor text
>   revisions (not semantically significant), plus a change to the types
>   of the claims (to claim a system and a computer program product,
>   rather than a method).
> 
> - Patent 7,953,778, titled "Efficient support of consistent cyclic
>   search with read-copy update and parallel updates", filed 2008-05-20
>   and granted 2011-05-31.  As suggested by the title, this one adds
>   parallel updates.
> 
> Your patch added citations for the first and third of those, 7,426,511
> and 7,953,778, with BibTeX tags PaulEMcKenney2011cyclicRCU and
> PaulEMcKenney2011cyclicparallelRCU.  I think you probably want to
> replace the citation to 7,426,511 with a citation to 7,814,082, or cite
> all three and annotate 7,426,511 as superseded by 7,814,082.  In any
> case, you'll want to either drop or fix the years in the BibTeX tags.

Sad that I needed your help with this, but thank you for providing it!
I am leaving #1 and #3, but with the correct dates.

							Thanx, Paul

