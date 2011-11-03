Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1KCWK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:10:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49749 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab1KCWKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:10:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
Date: Thu, 3 Nov 2011 23:12:59 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org
References: <20111101021511.GP18855@google.com> <201111031143.13836.rjw@sisk.pl> <20111103150708.GC4417@google.com>
In-Reply-To: <20111103150708.GC4417@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111032313.00082.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 03, 2011, Tejun Heo wrote:
> Hello, Rafael.
> 
> On Thu, Nov 03, 2011 at 11:43:13AM +0100, Rafael J. Wysocki wrote:
> > On Thursday, November 03, 2011, Tejun Heo wrote:
> > > Hello,
> > > 
> > > On Wed, Nov 2, 2011 at 6:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > OK, so I guess I should drop it from my linux-next branch?
> > > 
> > > Hmmm... yes, the preceding patches should be applied first and then
> > > this one. Any problems with earlier ones?
> > 
> > The only problem I currently have is to figure out what patches to apply
> > and in which order.  Care to help? ;-)
> 
> Heh, sorry about that, so to sum up the outstanding patches.
> 
> for-fixes (current merge window)
> 
>  [1] wait_event_freezekillable: use freezer_do_not_count/freezer_count
>  [2] freezer: revert 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"
> 
>   It would be a good idea to note that the first patch makes thes
>   change made by commit 27920651fe and thus reverting is safe.

OK

Can you repost these two with new changelogs so that there's no confusion
about what they are doing and why exactly, pretty please?

> for-next
> 
>  [3] freezer: fix various bugs and simplify implementation, take#2
>  [4] usb_storage: don't use set_freezable_with_signal()
>  [5] freezer: kill unused set_freezable_with_signal()
>  [6] freezer: fix wait_event_freezable/__thaw_task races
> 
> All the for-next patches are in the following git branch in the above
> order.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-fix-wait_freezable

Good.  I'll put them into a separate branch and merge them into my linux-next
branch when 3.2-rc1 is out.

Thanks,
Rafael
