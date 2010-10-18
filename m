Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0JRPAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:00:04 -0400
Received: from thunk.org ([69.25.196.29]:32969 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab0JRPAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:00:02 -0400
Date: Mon, 18 Oct 2010 10:59:30 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, Eric Paris <eparis@parisplace.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-ID: <20101018145930.GE4120@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>,
	Eric Paris <eparis@redhat.com>, Eric Paris <eparis@parisplace.org>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
	devel@lists.fedoraprojet.org
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <1287295077.3020.83.camel@localhost.localdomain>
 <1287313332.1998.172.camel@laptop>
 <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
 <1287323960.1998.360.camel@laptop>
 <1287324983.2530.35.camel@localhost.localdomain>
 <1287403048.29097.1553.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287403048.29097.1553.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 01:57:28PM +0200, Peter Zijlstra wrote:
> Well, you could use the actual freezer to freeze luserspace and then
> simply iterate all open files, I mean, those few sods who actually want
> this enabled can either pass a boot option to enable from boot or suffer
> the overhead on enable, right?

I'm a little confused why anyone would want to turn on IMA at any time
other than right away at boot?  If you haven't been doing integrity
management checking from the very beginning of the boot process, what
does turning on IMA after the system has booted buy you in the way of
security protections?

In other words, turning on IMA via a boot option seems to be the only
thing that makes any sense at all.

      	   	 				- Ted
