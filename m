Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1HVEPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 00:15:31 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:47560 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750905Ab1HVEP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 00:15:28 -0400
Date: Sun, 21 Aug 2011 21:15:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        container cgroup <containers@lists.linux-foundation.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] cgroups: update documentation on task moving
 restriction
Message-Id: <20110821211525.26e793c9.rdunlap@xenotime.net>
In-Reply-To: <CALdu-PC5_J2-Ss6se8LnoWDf5Ltt3Y9__RXKyTZUXvgBmv60Tg@mail.gmail.com>
References: <4E4C7E16.9090905@cn.fujitsu.com>
	<CALdu-PC5_J2-Ss6se8LnoWDf5Ltt3Y9__RXKyTZUXvgBmv60Tg@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 00:44:35 -0700 Paul Menage wrote:

> On Wed, Aug 17, 2011 at 7:51 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> > - ns cgroup has been removed.
> > - it's true moving a task to another cgroup can fail.
> >
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <paul@paulmenage.org>

Applied, thanks.


> > ---
> >  Documentation/cgroups/cgroups.txt |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> > index cd67e90..9c452ef 100644
> > --- a/Documentation/cgroups/cgroups.txt
> > +++ b/Documentation/cgroups/cgroups.txt
> > @@ -454,8 +454,8 @@ mounted hierarchy, to remove a task from its current cgroup you must
> >  move it into a new cgroup (possibly the root cgroup) by writing to the
> >  new cgroup's tasks file.
> >
> > -Note: If the ns cgroup is active, moving a process to another cgroup can
> > -fail.
> > +Note: Due to some restrictions enforced by some cgroup subsystems, moving
> > +a process to another cgroup can fail.
> >
> >  2.3 Mounting hierarchies by name
> >  --------------------------------
> > --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
