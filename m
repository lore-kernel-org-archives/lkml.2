Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1AMVnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:43:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab1AMVnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:43:45 -0500
Date: Thu, 13 Jan 2011 21:43:08 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alasdair G Kergon <agk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block bits for 2.6.38
Message-ID: <20110113214308.GA18104@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4D2F03A7.2030809@fusionio.com> <20110113192152.GA18217@agk-dp.fab.redhat.com> <AANLkTin8icx0cir8czy9snZ0wg=QovJ4HSZru4jYUoea@mail.gmail.com> <4D2F5353.3000400@fusionio.com> <AANLkTi=VaaJr1b37yabEj-XTe1pRzcEg6OHLb1HbEES0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=VaaJr1b37yabEj-XTe1pRzcEg6OHLb1HbEES0@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 09:05:40PM +0100, Tejun Heo wrote:
> On Thu, Jan 13, 2011 at 8:32 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> > I see Tejun already posted a fix, but Milan says it does not work.
> > Tejun, any  updates?
> 
> Hmmm... seems like I missed something.  Unfortunately, it's already a
> bit too late here.  I'll get back to it tomorrow afternoon.  The issue
> is mostly cosmetic so if it can wait a day or two I don't think
> reverting is necessary.
 
It's only cosmetic if your system is not relying upon userspace programs
that rely upon it:)   My vote would be for reverting the patch for now
so we can be sure the existing userspace functionality continues to work
in -rc1.

Alasdair

