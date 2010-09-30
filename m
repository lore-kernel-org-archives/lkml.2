Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0I3Lmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:42:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:56416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0I3Lmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:42:50 -0400
Subject: Re: kgdb segv in the latest tip due to perf ctx changes
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20100927154750.GA5346@nowhere>
References: <20100924180417.GC1818@jolsa.brq.redhat.com>
	 <4C9D0A82.5020406@windriver.com> <1285374560.2275.1054.camel@laptop>
	 <20100925135532.GA5349@nowhere>
	 <20100927081216.GC1829@jolsa.brq.redhat.com>
	 <20100927154750.GA5346@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 13:42:38 +0200
Message-ID: <1285846958.2144.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 17:47 +0200, Frederic Weisbecker wrote:
> 
> Actually I'm just realizing that, after the recent perf changes,
> it does not only concern the early kgdb needs but every breakpoints
> now that the context is found/allocated after the event gets initialized.
> 
> So I need to do a good bunch of changes in the breakpoints to fix that.
> 
> I'll come back with something. 

Right, disregard my email from a minute ago then ;-)
