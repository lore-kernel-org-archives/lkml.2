Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2FKNvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:51:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34746 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab2FKNvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:51:45 -0400
Date: Mon, 11 Jun 2012 15:51:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Zhouping Liu <zliu@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, hi3766691@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Kernel panic - not syncing: Attempted to kill the idle task!
Message-ID: <20120611135140.GA3913@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Zhouping Liu <zliu@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Hillf Danton <dhillf@gmail.com>, hi3766691@gmail.com,
	LKML <linux-kernel@vger.kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <cfc29313-7fe7-4140-b9e6-053d925b4897@zmail13.collab.prod.int.phx2.redhat.com>
 <1339421268.30462.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339421268.30462.15.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 03:27:48PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-06-08 at 21:38 -0400, Zhouping Liu wrote:
> > # cat /sys/devices/system/node/node*/distance
> > 10 17 17 24 24 24 30 30
> > 18 10 30 18 18 24 24 24
> > 18 24 10 24 24 17 30 30
> > 24 18 23 10 24 17 17 30
> > 24 17 24 24 10 18 30 18
> > 31 24 17 18 18 10 24 24
> > 30 24 30 17 24 24 10 18
> > 30 24 30 24 17 24 17 10 
> 
> You have to be kidding me right? That thing is a complete trainwreck,
> what idiot vendor did this?

HP ProLiant DL785 G6

http://www.sanweiying.org/download/debug_kernel/kernel_panic_48d212a2eecaca

contains dmesg and there's some serious fun with how the box boots:

node 0, cpus: 0, 8, 16...
node 1, cpus: 1, 9, 17...

> If you boot that machine again, does it have the same stupid table or
> are we staring at white-noise?

I'll bet it does.

-- 
Regards/Gruss,
Boris.
