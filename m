Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1GJLFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:05:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42454 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab1GJLFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:05:49 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Miles Lane" <miles.lane@gmail.com>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
In-Reply-To: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XNkIyhV6dgF.A.IjG.ACYGOB@chimera>
Subject: [Bug #38702] 3.0.0-rc4-git6 - INFO: possible circular locking dependency detected - (&rdev->mtx){+.+.+.}, at: [<ffffffffa00e27e0>] cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jul 2011 12:38:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38702
Subject		: 3.0.0-rc4-git6 - INFO: possible circular locking dependency detected - (&rdev->mtx){+.+.+.}, at: [<ffffffffa00e27e0>] cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2011-06-26 21:54 (15 days old)
Message-ID	: <BANLkTikztsFnPkJZ7VxRC-zsitwCCvVmeg@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=130912559804336&w=2


