Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0IJMGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 08:06:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:44903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0IJMGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 08:06:36 -0400
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Nico Schottelius <nico-nospam@schottelius.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Pritz <flo@xssn.at>, Suresh Siddha <suresh.b.siddha@intel.com>,
        stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
        "Brown, Len" <lenb@kernel.org>
In-Reply-To: <AANLkTinBwfLXi0Bv0_gzSWRsdDPzHFQFZFwEYjbwkNs4@mail.gmail.com>
References: <Pine.LNX.4.64.1009101324280.3056@boston.corp.fedex.com>
	 <1284104920.402.21.camel@laptop>
	 <AANLkTinBwfLXi0Bv0_gzSWRsdDPzHFQFZFwEYjbwkNs4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 14:05:53 +0200
Message-ID: <1284120353.402.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 19:53 +0800, Jeff Chua wrote:
> On Fri, Sep 10, 2010 at 3:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2010-09-10 at 13:36 +0800, Jeff Chua wrote:
> >>
> >> I've bisected and it's pointing to the following commit causing the
> >> errors after resume. Reverting the commit solves the problem.
> >"the errors" being those at the end of this email?
> 
> Yes (partial). Attached is the detailed kernel log that I just
> captured with the commit cd7240c0b900eb6d690ccee088a6c9b46dae815a
> applied.


Could you try again with CONFIG_FRAME_POINTER=y, these stacks are a
terrible mess.
