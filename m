Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0ERVNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:13:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab0ERVNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:13:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Tue, 18 May 2010 23:14:08 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Brian Swetland <swetland@google.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1273810273-3039-1-git-send-email-arve@android.com> <201005182138.04610.rjw@sisk.pl> <AANLkTileYiu6pL4eX3lpvpYLuu76A8auZp4xrcDX94BQ@mail.gmail.com>
In-Reply-To: <AANLkTileYiu6pL4eX3lpvpYLuu76A8auZp4xrcDX94BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005182314.08761.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 May 2010, Arve Hjønnevåg wrote:
> 2010/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Tuesday 18 May 2010, Arve Hjønnevåg wrote:
> >> On Mon, May 17, 2010 at 2:44 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Monday 17 May 2010, Brian Swetland wrote:
> >> >> On Mon, May 17, 2010 at 1:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >> > On Monday 17 May 2010, Arve Hjønnevåg wrote:
> >> >> >>
...
> 
> > Now, to make it more "user-friendly", we can simply use
> > queue_delayed_work() with a reasonable delay instead of queue_work() to queue
> > the suspend work (the delay may be configurable via sysfs).
> >
> 
> I can add a delay (and the timeout support code does add a delay as an
> optimization) to the unknown wakeup case, but this does not fix the
> problem of a user turning on opportunistic suspend with a user space
> framework that does not use suspend blockers. If the kernel uses
> suspend blockers to make sure the wakeup event makes it to user space,
> but user space does not block suspend, then the system will suspend
> before the event is processed.

But the user can still manually write to /sys/power/state. :-)

Rafael
