Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1K1K4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:56:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38380 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1K1K4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:56:24 -0500
Message-ID: <1322477770.2921.104.camel@twins>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Mon, 28 Nov 2011 11:56:10 +0100
In-Reply-To: <1322477485.2921.99.camel@twins>
References: <20111126014731.GA7030@quad> <1322475060.2921.95.camel@twins>
	 <1322477485.2921.99.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 11:51 +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 11:11 +0100, Peter Zijlstra wrote:
> > OK, I'll stick it in perf/urgent.. Thanks Stephane!
> 
> I'll use you as test-subject for my quilt2git script
> ( http://programming.kicks-ass.net/misc/quilt2git.sh )
> 
> My exploded quilt tree lives at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git

With a note that this tree is completely regenerated every time I run
this script, so its a complete rebase. Its only purpose in life is to
expose my quilt tree in git topic branch form for whoemever thinks this
is more convenient than grabbing my tarball and fiddling with quilt.

Also note that the master branch of the tree includes all topic master
branches, which in turn include all topic subject branches. IOW the
master branch contains my complete quilt tree of the moment (which might
or might not actually compile, eat your pet or cook you dinner).
