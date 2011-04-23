Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1DWRzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 13:55:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46104 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1DWRzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 13:55:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Two power management fixes for 2.6.39
Date: Sat, 23 Apr 2011 19:55:43 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <201104212211.03185.rjw@sisk.pl>
In-Reply-To: <201104212211.03185.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104231955.44001.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 21, 2011, Rafael J. Wysocki wrote:
> Hi Linus,
> 
> Please pull two power management fixes for 2.6.39 from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes
> 
> They fix bugs related to syscore_ops introduced earlier in this cycle.

Well, I guess I should have said they fixed regressions related to the introduction
of syscore_ops.  At least the second commit fixes real breakage (the error code
paths should not be broken as well, but they aren't executed too often).

Anyway, next week I'm going to have more regression fixes ready, so I'll send
a new pull request at that time.

>  arch/x86/kernel/apm_32.c |    5 +++++
>  drivers/base/syscore.c   |    2 ++
>  drivers/xen/manage.c     |    9 ++++++++-
>  kernel/kexec.c           |    7 +++++++
>  kernel/power/hibernate.c |   10 ++++++++--
>  kernel/power/suspend.c   |    5 ++++-
>  6 files changed, 34 insertions(+), 4 deletions(-)
> 
> ---------------
> 
> Rafael J. Wysocki (2):
>       PM: Fix error code paths executed after failing syscore_suspend()
>       PM: Add missing syscore_suspend() and syscore_resume() calls

Thanks,
Rafael
