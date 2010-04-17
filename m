Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0DQRz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 13:55:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:59712 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0DQRz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 13:55:58 -0400
Date: Sat, 17 Apr 2010 10:57:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: tytso@mit.edu
Cc: Peter Zijlstra <peterz@infradead.org>, Salman <sqazi@google.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       svaidy@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
Message-ID: <20100417105721.63d48577@infradead.org>
In-Reply-To: <20100417170808.GE32634@thunk.org>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	<1271317886.32749.69.camel@laptop>
	<20100417170808.GE32634@thunk.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Apr 2010 13:08:08 -0400
tytso@mit.edu wrote:

> On Thu, Apr 15, 2010 at 09:51:26AM +0200, Peter Zijlstra wrote:
> > On Tue, 2010-04-13 at 17:08 -0700, Salman wrote:
> > > As we discussed earlier this year, Google has an implementation
> > > that it would like to share.  I have finally gotten around to
> > > porting it to v2.6.33 and cleaning up the interfaces.  It is
> > > provided in the following messages for your review.  I realize
> > > that when we first discussed this idea, a lot of ideas were
> > > presented for enhancing it.  Thanks alot for your suggestions.  I
> > > haven't gotten around to implementing any of them.
> > 
> > .33 is way too old to submit patches against.
> 
> But it's not too old for review purposes; as Salman said, they were
> sent to LKML for comments and review.  I think it's well understood
> that when these patches are ready to be merged, they need to be
> submitted right before the merge window opens, against a recent -rc
> kernel.

s/submitted/refreshed/ ;-)




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
