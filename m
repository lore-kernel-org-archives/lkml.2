Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2BPVkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:40:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56552 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab2BPVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:40:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Fox <pgf@laptop.org>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is not empty.
Date: Thu, 16 Feb 2012 22:44:00 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
References: <1327112659-31145-1-git-send-email-arve@android.com> <201202160030.26503.rjw@sisk.pl> <20867.1329357211@foxharp.boston.ma.us>
In-Reply-To: <20867.1329357211@foxharp.boston.ma.us>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202162244.00267.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 16, 2012, Paul Fox wrote:
> rafael j. wysocki wrote:
>  > On Tuesday, February 14, 2012, NeilBrown wrote:
>  > 
>  > > (or just keep this stuff out of the kernel and let a user-space daemon make
>  > > those decisions).
>  > 
>  > Which is never going to really work, IMHO.
>  > 
>  > Realistically, do you know of any distro, vendor, whoever, who tried to
>  > actually do that in a released product (or even in a release candidate,
>  > or milestone, or whatever different from a prototype running only on one's
>  > personal desktop)?  I don't.
> 
> well, depending on your decision of "that", there are something like
> 2.5 million OLPC XO laptops that do it.  do they count?  ;-)
> 
> we're still in the middle of converting our 2.6-era home-grown power
> management mechanisms to the 3.0-era level, using the
> .../power/wakeup[_count] and /sys/power/wakeup_count mechanisms. 
> (change comes slowly to shipping products.)  but we do have a
> user-level suspend manager.
> 
> to the real point of your question:  no, i don't think it does what
> you're talking about yet -- i.e., control by applications over whether
> suspend should be permitted or not exists, but isn't nearly as
> reliable or as foolproof as any of the mechanisms discussed here
> recently.

OK, cool!

I was wrong then, but good to hear that. :-)

Thanks,
Rafael
