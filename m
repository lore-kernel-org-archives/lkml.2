Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0HDRz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:55:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40540 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab0HDRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:55:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C59A90B.8040403@s5r6.in-berlin.de>
Date: Wed, 04 Aug 2010 19:53:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [GIT PULL] workqueue for v2.6.36
References: <4C596D21.4080101@kernel.org> <1280939168.21608.10.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1280939168.21608.10.camel@c-dwalke-linux.qualcomm.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> I haven't seen anything that shows your adding back the same
> expressiveness that your removing .. So I still don't think this should
> be merged.

Do you mean by expressiveness the ability to hack around a suboptimally
working driver in userland (by requiring the administrator to play with
kernel thread priorities of dedicated worker threads)?  Is it known
whether this driver/ these drivers still require this hack after Tejun's
patch set is applied?  If yes, how about finding someone to fix this
driver for good.  Meanwhile, let's gets rid of the problem of having
both too few and too many workers in countless present usages of the
workqueue API please.
-- 
Stefan Richter
-=====-==-=- =--- --=--
http://arcgraph.de/sr/
