Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0HDQ00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:26:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1678 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0HDQ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:26:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6064"; a="49856884"
Subject: Re: [GIT PULL] workqueue for v2.6.36
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <4C596D21.4080101@kernel.org>
References: <4C596D21.4080101@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 09:26:08 -0700
Message-ID: <1280939168.21608.10.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 15:37 +0200, Tejun Heo wrote:
> Hello, Linus.
> 
> Please consider pulling from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus
> 
> to receive the concurrencey managed workqueue patches.  The branch
> contains 32 patches to prepare for and implement cmwq and 23 patches
> fixing bugs and converting libata, async, fscache and other slow-work
> users to workqueue and remove slow-work.
> 
> The following overview section gives a brief overview.  For more
> detailed information, please refer to the last posting of cmwq
> patchset.

I haven't seen anything that shows your adding back the same
expressiveness that your removing .. So I still don't think this should
be merged.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

