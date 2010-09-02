Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0IBPMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:12:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:59471 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0IBPMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:12:39 -0400
Subject: Re: [RFD][checkpatch] warnings on space in front of labels
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1283438614.2356.141.camel@gandalf.stny.rr.com>
References: <1283437098.2356.135.camel@gandalf.stny.rr.com>
	 <1283437867.2012.213.camel@laptop>
	 <1283438614.2356.141.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 02 Sep 2010 17:12:28 +0200
Message-ID: <1283440348.2012.282.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 10:43 -0400, Steven Rostedt wrote:
> On Thu, 2010-09-02 at 16:31 +0200, Peter Zijlstra wrote:
> 
> > > What do others think?
> > 
> > I'd prefer to run a script over the kernel and remove all those silly spaces.
> 
> Until we get a diff option of --ignore-labels as a standard distro diff,
> I'd NAK that patch ;-)

For kicks, try:
  export QUILT_DIFF_OPTS="-F ^[[:alpha:]$_].*[^:]$"

and try again.
