Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342Ab2CMAjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:39:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971Ab2CMAYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 0/6] PM / Domains: System suspend fixes and "always on" flag
Date: Tue, 13 Mar 2012 01:23:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130123.16268.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following patches fix system suspend/resume and hibernation device
callback routines in the generic PM domains code and add an "always on" flag
for devices allowing their drivers to protect them from surprise power
removals.

[1/6] - Fix system resume of devices involved in system wakeup.
[2/6] - Fix hibernation restore of devices.
[3/6] - Introduce "always on" flag for "special" devices in PM domains.
[4/6] - Make TMU clocksource driver use the "always on" flag.
[5/6] - Make CMT clocksource driver use the "always on" flag.
[6/6] - Make MTU2 clocksource driver use the "always on" flag.

All of them are v3.4 material if there are no objections.

Thanks,
Rafael
