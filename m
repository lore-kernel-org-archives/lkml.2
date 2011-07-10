Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1GJKz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:55:28 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:50203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1GJKzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:55:21 -0400
Subject: Re: 3.0-rc6-git6: Reported regressions from 2.6.39
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
In-Reply-To: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera> (sfid-20110710_124712_285053_7BCF3183)
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
	 (sfid-20110710_124712_285053_7BCF3183)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 12:54:37 +0200
Message-ID: <1310295277.3942.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-10 at 12:19 +0200, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38702
> Subject		: 3.0.0-rc4-git6 - INFO: possible circular locking dependency detected - (&rdev->mtx){+.+.+.}, at: [<ffffffffa00e27e0>] cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
> Submitter	: Miles Lane <miles.lane@gmail.com>
> Date		: 2011-06-26 21:54 (15 days old)
> Message-ID	: <BANLkTikztsFnPkJZ7VxRC-zsitwCCvVmeg@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=130912559804336&w=2

Should be fixed by c10841ca722a0bc960dc541c51582773f9a24f98 which was
part of John's latest pull request and is in net-2.6 now on its way up.

johannes

