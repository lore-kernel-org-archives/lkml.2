Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1GALfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:35:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44448 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1GALfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:35:44 -0400
Date: Fri, 1 Jul 2011 15:35:33 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Ingo Molnar <mingo@elte.hu>, solar@openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC] ipc: introduce shm_rmid_forced sysctl
Message-ID: <20110701113533.GA19945@albatros>
References: <20110622152514.GA9521@albatros>
 <20110629151436.9be479fb.akpm@linux-foundation.org>
 <20110701112534.GG20990@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701112534.GG20990@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 13:25 +0200, Ingo Molnar wrote:
> Furthermore, if testing shows that this is not actually breaking 
> anything in a serious way we could also in theory simplify the patch 
> and just make this the default behavior with no runtime ability to 
> switch it off.

I'm afraid it's impossible.  From -ow readme:

"Of course, this breaks the way things are defined, so some applications
might stop working. In particular, expect most commercial databases to
break. Apache and PostgreSQL are known to work, though. :-)"

http://www.openwall.com/linux/README.shtml

But as it was written in days of Linux 2.4.x, the situation could have
changed.  A desktop system seems to work.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
