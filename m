Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab1CDTA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:00:57 -0500
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:62364 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759918Ab1CDTAz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:00:55 -0500
X-AuditID: 1209190f-b7c1dae000000a2b-a0-4d7136e724d7
Subject: Re: [LTP] [ANNOUNCE] The Linux Test Project has been released for FEBRUARY 2011.
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <1469445745.266603.1299117157337.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Date: Fri, 4 Mar 2011 13:58:45 -0500
Cc: subrata@linux.vnet.ibm.com, ltp-list@lists.sf.net, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org,
        Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6AFCFCC5-DBC2-403E-9EED-D2A85FFCB21C@mit.edu>
References: <1469445745.266603.1299117157337.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
To: CAI Qian <caiqian@redhat.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 2, 2011, at 8:52 PM, CAI Qian wrote:

> Those days, there just too many tests and testing projects for kernel like
> LTP, autotest, xfstests and so on. Why not have somewhere to collabrate and
> then to extract the best?

Part of the problem is that every single testing project has different goals and
priorities.   For example xfstests is maintained by the XFS folks, as well as people
from some of the other file system development efforts (the ext4 one in particular,
thanks to people like Eric Sandeen), to test file systems.

At least at one point, I had heard a complaint that LTP was more focused on 
increasing test coverage as measured by a code coverage tool in the kernel
than it was about about covering edge conditions, or races.  There's nothing 
wrong with that, per se, and I don't know if it was true then or now, but it's a very
different focus from one which is focused increasing the data reliability of file
systems, quickly and efficiently.

And then there's the LSB test suites, which is really code at testing correctness
from a standards perspective, which is a different focus yet again from the LTP
and xfstests approach.

Bottom line, I'm a big fan of having different test suites, with different philosophies.
Each philosophy has its strengths and blind spots, and so a problem that might
be missed by one test suite might get caught by another.

The only real problem is an operational one.   There are some programs which
are used by both LTP and xfstests, and changes that is made in one, don't 
necessarily get propagated to the other unless someone manually does it.
But I think we can solve that without trying to merge all of these tests into a
single Grand Unified Test Suite.

-- Ted

