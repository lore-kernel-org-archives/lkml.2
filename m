Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2AEMLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:11:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61234 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab2AEML2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:11:28 -0500
References: <CAHFgRy_AdA7iKzCwNvXiE3pR1dqdkuKPgT0soWjw8E_TcLjJtA@mail.gmail.com> <4EFAAFEF.6070503@linux.vnet.ibm.com> <201112282303.26978.rjw@sisk.pl> <20120105115330.GA29569@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20120105115330.GA29569@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <3BA6B994-29A1-44E6-AF10-C9331F3BB521@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Jeff Layton <jlayton@redhat.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
X-Mailer: iPhone Mail (9A405)
From: Miles Lane <miles.lane@gmail.com>
Subject: Re: Freezing of tasks failed after 20.01 seconds in 3.2.0-rc4+ (Linus GIT af968e2)
Date: Thu, 5 Jan 2012 07:11:21 -0500
To: Pavel Machek <pavel@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 5, 2012, at 6:53 AM, Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
>>> 
>>> Miles Lane (in CC) hit freezing failures in 3.2.0-rc4+ (Linus GIT af968e2)
>>> while trying to suspend the machine.
>> 
>> Well, ext3 seems to be involved.  I don't see any problems with suspending
>> those kernels on my test machines, but I don't use ext3 on them any more.
>> 
>> It would be good to rule out ext3 somehow.
> 
> I still use ext3 here, and suspend works in recent kernels.
> 
> Is it reproducible for Miles?

It was a one time event, sorry.

All the best.