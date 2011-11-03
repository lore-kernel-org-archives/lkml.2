Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1KCWUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:20:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49782 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1KCWUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:20:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
Date: Thu, 3 Nov 2011 23:22:46 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
References: <20111101021511.GP18855@google.com> <201111032313.00082.rjw@sisk.pl> <CAOS58YMEjeJsS-J6ghrVO3W9CyUHLOZ=V-C-Y=xH14QfLUtvsw@mail.gmail.com>
In-Reply-To: <CAOS58YMEjeJsS-J6ghrVO3W9CyUHLOZ=V-C-Y=xH14QfLUtvsw@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111032322.46197.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 03, 2011, you wrote:
> Hello,
> 
> On Thu, Nov 3, 2011 at 3:12 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Can you repost these two with new changelogs so that there's no confusion
> > about what they are doing and why exactly, pretty please?
> 
> Will do. :)

Great, thanks!

> >> for-next
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-fix-wait_freezable
> >
> > Good.  I'll put them into a separate branch and merge them into my linux-next
> > branch when 3.2-rc1 is out.
> 
> Can you please hold fifteen minutes?  I'm updating the series to
> reflect Srivatsa's review.  I'll send pull request soon.

OK, no problem.

Thanks,
Rafael
