Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2KTDqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:46:14 -0500
Received: from tundra.namei.org ([65.99.196.166]:46766 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab2KTDqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:46:13 -0500
Date: Tue, 20 Nov 2012 14:46:35 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        John Johansen <john.johansen@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Yama: remove locking from delete path
In-Reply-To: <CAGXu5jJe0-nu2e+QAGeYGiufumXd7JR-z_JCt+OCHVKhmnvN1Q@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1211201445410.1844@tundra.namei.org>
References: <20121119233459.GA9524@www.outflux.net> <alpine.LRH.2.02.1211201323170.1407@tundra.namei.org> <CAGXu5jJe0-nu2e+QAGeYGiufumXd7JR-z_JCt+OCHVKhmnvN1Q@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012, Kees Cook wrote:

> On Mon, Nov 19, 2012 at 6:23 PM, James Morris <jmorris@namei.org> wrote:
> > On Mon, 19 Nov 2012, Kees Cook wrote:
> >
> >> Instead of locking the list during a delete, mark entries as invalid
> >> and trigger a workqueue to clean them up. This lets us easily handle
> >> task_free from interrupt context.
> >>
> >> Cc: Sasha Levin <sasha.levin@oracle.com>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > This doesn't apply cleanly to my -next branch.
> 
> Did you already apply this from last week?
> https://lkml.org/lkml/2012/11/13/808

Nope.

> 
> > Kees: can you think about using git to push changes to me for Yama?
> 
> If this pace of changes keeps up, sure thing.

In any case, please check that your patches apply cleanly to my -next 
branch.


- James
-- 
James Morris
<jmorris@namei.org>
