Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab1KRXbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:31:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51707 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab1KRXbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:31:01 -0500
Date: Fri, 18 Nov 2011 15:30:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
 given pids
Message-ID: <20111118233055.GA29378@google.com>
References: <4EC4F2FB.408@parallels.com>
 <20111117154936.GB12325@redhat.com>
 <4EC52FBF.1010407@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC52FBF.1010407@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 17, 2011 at 08:01:03PM +0400, Pavel Emelyanov wrote:
> > Yes, personally I'd prefer /proc/set_last_pid (or something similar) which
> > simply writes to pid_ns->last_pid. Perhaps it is less convenient from the
> > user-space pov (serialization, security) but it is much simpler.
> 
> Yes, this is also possible. I have a working prototype of /proc/sys/kernel/ns_last_pid
> with the security issue solved, but setting sysctl then cloning seems more obfuscating
> to me than just passing an array of pids to clone.

Do you mind sharing the patch?  It doesn't have to be perfect.  I'm
just curious how it looks.  IMHO the suggested pid array passing is
good enough and not too intrusive but, if there's something simpler
from kernel side, given that this is a very specialized interface, I
think we definitely need to consider that.

Thank you.

-- 
tejun
