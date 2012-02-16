Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2BPCDC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:03:02 -0500
Received: from colo.foxharp.net ([166.84.7.52]:35588 "EHLO colo.foxharp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040Ab2BPCC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:02:57 -0500
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Feb 2012 21:02:57 EST
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is not empty.
From: Paul Fox <pgf@laptop.org>
cc: NeilBrown <neilb@suse.de>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
In-reply-to: <201202160030.26503.rjw@sisk.pl> (sfid-20120215_182725_824505_3D84E0E2)
References: <1327112659-31145-1-git-send-email-arve@android.com> <20120214142540.04de41df@notabene.brown> <201202160030.26503.rjw@sisk.pl> (sfid-20120215_182725_824505_3D84E0E2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20864.1329357211.1@foxharp.boston.ma.us>
Date: Wed, 15 Feb 2012 20:53:31 -0500
Message-ID: <20867.1329357211@foxharp.boston.ma.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rafael j. wysocki wrote:
 > On Tuesday, February 14, 2012, NeilBrown wrote:
 > 
 > > (or just keep this stuff out of the kernel and let a user-space daemon make
 > > those decisions).
 > 
 > Which is never going to really work, IMHO.
 > 
 > Realistically, do you know of any distro, vendor, whoever, who tried to
 > actually do that in a released product (or even in a release candidate,
 > or milestone, or whatever different from a prototype running only on one's
 > personal desktop)?  I don't.

well, depending on your decision of "that", there are something like
2.5 million OLPC XO laptops that do it.  do they count?  ;-)

we're still in the middle of converting our 2.6-era home-grown power
management mechanisms to the 3.0-era level, using the
.../power/wakeup[_count] and /sys/power/wakeup_count mechanisms. 
(change comes slowly to shipping products.)  but we do have a
user-level suspend manager.

to the real point of your question:  no, i don't think it does what
you're talking about yet -- i.e., control by applications over whether
suspend should be permitted or not exists, but isn't nearly as
reliable or as foolproof as any of the mechanisms discussed here
recently.

paul
=---------------------
 paul fox, pgf@laptop.org
