Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0DQRIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 13:08:16 -0400
Received: from THUNK.ORG ([69.25.196.29]:56522 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0DQRIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 13:08:15 -0400
Date: Sat, 17 Apr 2010 13:08:08 -0400
From: tytso@mit.edu
To: Peter Zijlstra <peterz@infradead.org>
Cc: Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
Message-ID: <20100417170808.GE32634@thunk.org>
Mail-Followup-To: tytso@mit.edu, Peter Zijlstra <peterz@infradead.org>,
	Salman <sqazi@google.com>, mingo@elte.hu,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	svaidy@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
	arjan@infradead.org, csadler@google.com, ranjitm@google.com,
	kenchen@google.com, dawnchen@google.com
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
 <1271317886.32749.69.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271317886.32749.69.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 09:51:26AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-04-13 at 17:08 -0700, Salman wrote:
> > As we discussed earlier this year, Google has an implementation that it
> > would like to share.  I have finally gotten around to porting it to
> > v2.6.33 and cleaning up the interfaces.  It is provided in the following
> > messages for your review.  I realize that when we first discussed this
> > idea, a lot of ideas were presented for enhancing it.  Thanks alot for
> > your suggestions.  I haven't gotten around to implementing any of them.
> 
> .33 is way too old to submit patches against.

But it's not too old for review purposes; as Salman said, they were
sent to LKML for comments and review.  I think it's well understood
that when these patches are ready to be merged, they need to be
submitted right before the merge window opens, against a recent -rc
kernel.

					- Ted
