Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0CZVzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:55:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56273 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab0CZVzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:55:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Bug #15319] [BUG]: Possibe recursive locking detected in sysfs
Date: Fri, 26 Mar 2010 22:58:18 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "John Kacur" <jkacur@redhat.com>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.iYE.FPopLB@chimera> <m1vdcjohr1.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdcjohr1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003262258.18590.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 March 2010, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.32 and 2.6.33.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15319
> > Subject		: [BUG]: Possibe recursive locking detected in sysfs
> > Submitter	: John Kacur <jkacur@redhat.com>
> > Date		: 2010-02-11 17:11 (39 days old)
> > Message-ID	: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=126590832432598&w=2
> > Handled-By	: Eric Biederman <ebiederm@aristanetworks.com>
> 
> The false positives I introduced should be fixed as of 2.6.34-rc2.
> If this bug still shows up in 2.6.34-rcX it indicates a real bug.

Thanks, closed.

Rafael
