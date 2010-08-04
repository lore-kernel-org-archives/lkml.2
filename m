Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0HDSDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:03:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44489 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab0HDSDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:03:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6064"; a="49869148"
Subject: Re: [GIT PULL] workqueue for v2.6.36
From: Daniel Walker <dwalker@codeaurora.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jeff@garzik.org>,
        David Howells <dhowells@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Steve French <sfrench@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andy Walls <awalls@radix.net>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <4C59A90B.8040403@s5r6.in-berlin.de>
References: <4C596D21.4080101@kernel.org>
	 <1280939168.21608.10.camel@c-dwalke-linux.qualcomm.com>
	 <4C59A90B.8040403@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 11:03:07 -0700
Message-ID: <1280944987.21608.53.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 19:53 +0200, Stefan Richter wrote:
> Daniel Walker wrote:
> > I haven't seen anything that shows your adding back the same
> > expressiveness that your removing .. So I still don't think this should
> > be merged.
> 
> Do you mean by expressiveness the ability to hack around a suboptimally
> working driver in userland (by requiring the administrator to play with
> kernel thread priorities of dedicated worker threads)?  Is it known
> whether this driver/ these drivers still require this hack after Tejun's
> patch set is applied?  If yes, how about finding someone to fix this
> driver for good.  Meanwhile, let's gets rid of the problem of having
> both too few and too many workers in countless present usages of the
> workqueue API please.

I mean by expressiveness the fact that a user can prioritize their
system more fully in the current system.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

