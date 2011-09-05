Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1IEUfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:35:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1IEUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:35:46 -0400
Date: Mon, 5 Sep 2011 13:39:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sched: share task comm length value to userspace
Message-ID: <20110905133903.76cd3a61@infradead.org>
In-Reply-To: <4E652E41.1030308@mleia.com>
References: <1315247881-31597-1-git-send-email-vz@mleia.com>
	<20110905124726.28b24db4@infradead.org>
	<4E652E41.1030308@mleia.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Sep 2011 23:17:05 +0300
Vladimir Zapolskiy <vz@mleia.com> wrote:

> but eventually having that value in
> userspace is really desirable. However in assumption that this value
> is preserved fixed and won't be changed in reasonable perspective,
> the presented approach becomes the most evident and simple.

yeah if it would never change, your change would be the most simple.
but I really don't want to pin that thing down....

> 
> >
> > If we need to export this, we should export it in /proc or /sys
> > somewhere as a dynamic value.....
> >
> Let's do it in a proper way. What's the common practice to export
> such limit values? I suppose via /proc/sys/kernel, please correct me,
> if I'm wrong.

that or /sys/kernel

personally I like /proc/sys/kernel for this kind of thing more, but...
... others might disagree.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
