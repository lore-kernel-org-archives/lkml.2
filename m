Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270Ab2JXSb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:31:57 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:46889 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965105Ab2JXSbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:31:55 -0400
Date: Wed, 24 Oct 2012 18:34:45 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 155/193] init: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024183445.GA11417@mail.hallyn.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-156-git-send-email-keescook@chromium.org>
 <20121024134831.GB7217@sergelap>
 <CAGXu5jJZxY4k2Xpg=nuUn6p6V8NqYBPmvAt4Y35eogZfYWSM+g@mail.gmail.com>
 <20121024171723.GA7698@sergelap>
 <CAGXu5j+H8rLx_o4FV6hmZ3mx0L3ct1Gz_4-5NixamN7Q_-AzfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+H8rLx_o4FV6hmZ3mx0L3ct1Gz_4-5NixamN7Q_-AzfA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> On Wed, Oct 24, 2012 at 10:17 AM, Serge Hallyn
> <serge.hallyn@canonical.com> wrote:
> > Quoting Kees Cook (keescook@chromium.org):
> >> On Wed, Oct 24, 2012 at 6:48 AM, Serge Hallyn
> >> <serge.hallyn@canonical.com> wrote:
> >> > Quoting Kees Cook (keescook@chromium.org):
> >> >> This config item has not carried much meaning for a while now and is
> >> >> almost always enabled by default. As agreed during the Linux kernel
> >> >> summit, remove it.
> >> >>
> >> >> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> >> >> CC: Serge Hallyn <serge.hallyn@canonical.com>
> >> >> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >> >> CC: Andrew Morton <akpm@linux-foundation.org>
> >> >> CC: Frederic Weisbecker <fweisbec@gmail.com>
> >> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> >> ---
> >> >>  init/Kconfig |   23 ++++++++++-------------
> >> >>  1 file changed, 10 insertions(+), 13 deletions(-)
> >> >>
> >> >> diff --git a/init/Kconfig b/init/Kconfig
> >> >> index 2bf7b83..4b65c1c 100644
> >> >> --- a/init/Kconfig
> >> >> +++ b/init/Kconfig
> >> >> @@ -220,7 +220,7 @@ config SYSVIPC_SYSCTL
> >> >>
> >> >>  config POSIX_MQUEUE
> >> >>       bool "POSIX Message Queues"
> >> >> -     depends on NET && EXPERIMENTAL
> >> >> +     depends on NET
> >> >>       ---help---
> >> >>         POSIX variant of message queues is a part of IPC. In POSIX message
> >> >>         queues every message has a priority which decides about succession
> >> >> @@ -366,7 +366,7 @@ config BSD_PROCESS_ACCT_V3
> >> >>         at <http://www.gnu.org/software/acct/>.
> >> >>
> >> >>  config TASKSTATS
> >> >> -     bool "Export task/process statistics through netlink (EXPERIMENTAL)"
> >> >> +     bool "Export task/process statistics through netlink"
> >> >
> >> > In these cases, should we keep the '(EXPERIMENTAL)' text since it is just
> >> > a hint to anyone running make menuconfig?  I think removing the 'depends on
> >> > EXPERIMENTAL's is fine, but cases we should leave it (or replace it) as
> >> > a textual hint, except in cases where we're sure that is no longer the case.
> >>
> >> I covered this in the 000 intro email (https://lkml.org/lkml/2012/10/23/580):
> >
> > intro email is an appreciated courtesy, but should not take the place of
> > info in the individual patch changelogs, especially as the intro emails
> > won't go into git history.
> >
> >> Some patches remove "(EXPERIMENTAL)" from Kconfig titles when there was
> >> no "depends on EXPERIMENTAL". I've removed the cases of these where I
> >
> > Hm, I was under the impression that taskstats are not quite trusted yet,
> > but I could be way out of date with that.
> 
> I'm happy to leave the taskstats title alone. Shall I?

Heh, no, sounds like I'm just way out of date.  Thanks Kees!

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

thanks,
-serge
