Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2EBMle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:41:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2EBMld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:41:33 -0400
Date: Wed, 2 May 2012 14:40:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
Message-ID: <20120502124015.GA3657@redhat.com>
References: <1335604790.5995.22.camel@marge.simpson.net> <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org> <20120429165846.GA19054@redhat.com> <m11un5zzzb.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11un5zzzb.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 04/29, Eric W. Biederman wrote:
> >>
> >> There are crazy code paths like daemonize()
> >
> > Forget. It has no callers anymore, should be killed. A user-space process
> > should never use kernel_thread() and thus daemonize() is not needed.
>
> Good point.  Oleg do you think you can send in the patches to kill
> daemonize.

Yes, will do. I am waiting until the last user in arch/powerpc goes
away, the patch is already in mm.

Oleg.

