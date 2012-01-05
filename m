Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab2AELxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:53:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43151 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab2AELxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:53:31 -0500
Date: Thu, 5 Jan 2012 12:53:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Jeff Layton <jlayton@redhat.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Miles Lane <miles.lane@gmail.com>, linux-fsdevel@vger.kernel.org
Subject: Re: Freezing of tasks failed after 20.01 seconds in 3.2.0-rc4+
 (Linus GIT af968e2)
Message-ID: <20120105115330.GA29569@atrey.karlin.mff.cuni.cz>
References: <CAHFgRy_AdA7iKzCwNvXiE3pR1dqdkuKPgT0soWjw8E_TcLjJtA@mail.gmail.com>
 <4EFAAFEF.6070503@linux.vnet.ibm.com>
 <201112282303.26978.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112282303.26978.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > 
> > Miles Lane (in CC) hit freezing failures in 3.2.0-rc4+ (Linus GIT af968e2)
> > while trying to suspend the machine.
> 
> Well, ext3 seems to be involved.  I don't see any problems with suspending
> those kernels on my test machines, but I don't use ext3 on them any more.
> 
> It would be good to rule out ext3 somehow.

I still use ext3 here, and suspend works in recent kernels.

Is it reproducible for Miles?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
