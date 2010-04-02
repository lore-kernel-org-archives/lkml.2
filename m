Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0DBPbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:31:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0DBPbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:31:14 -0400
Date: Fri, 2 Apr 2010 17:29:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [2.6.31 and later] "struct pid" leak.
Message-ID: <20100402152922.GA17727@redhat.com>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp> <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com> <20100331151719.8a92b302.akpm@linux-foundation.org> <20100401165247.GB19551@redhat.com> <20100401172120.GA3111@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401172120.GA3111@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge, Catalin, thanks a lot for the debugging output you sent
me privately ;)

On 04/01, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> >
> > Oh. It is hardly possibly to find the unbalanced get_pid() via grep.
>
> Looking through vt_ioctl.c,

Yes, my first reaction was "it must be tty" too ;)

I seem to understand what happens. If I am right, it is possible
to leak the pid even without X.

I'll try to check my theory and send the patch soon...

Oleg.

