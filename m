Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1GJLMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:12:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42549 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab1GJLML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:12:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: 3.0-rc6-git6: Reported regressions from 2.6.39
Date: Sun, 10 Jul 2011 13:10:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Steve <stefan.bosak@gmail.com>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera> <CAOJsxLEzUC9k0Y2PNxQpCs0WCjQBmP0O2dDxTzPzhGEcvQVDeQ@mail.gmail.com>
In-Reply-To: <CAOJsxLEzUC9k0Y2PNxQpCs0WCjQBmP0O2dDxTzPzhGEcvQVDeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107101310.16556.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 10, 2011, Pekka Enberg wrote:
> On Sun, Jul 10, 2011 at 1:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38672
> > Subject         : KVM guest boot crashed
> > Submitter       : Steve <stefan.bosak@gmail.com>
> > Date            : 2011-07-02 06:56 (9 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/6506e4f995967b1a48cc34418c77b318df92ce35
> 
> That URL gives me "404 - Unknown commit object"

Indeed, sorry.

> and Bugzilla comments give me the impression it's actually a QEMU bug. Hmm?

You're right, it appears to be a qemu bug, I have closed it.

Thanks,
Rafael
