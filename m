Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab1KGAIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 19:08:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1KGAIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 19:08:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/7] PM / Domains: Per-device callbacks and PM QoS
Date: Mon, 7 Nov 2011 01:01:33 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111070101.33960.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset makes it possible to define device-specific PM domain
callbacks, allowing device drivers to be designed to support generic PM domains
and work without them as well, and introduces governor functions deciding
whether or not it is beneficial to put devices into low-power states.  The new
code is designed to be backwards compatible, as far as necessary.

[1/7] - Make it possible to defing per-device start/stop routines.
[2/7] - Make it possible to defing per-device .active_wakeup() callbacks.
[3/7] - Introduce "save/restore state" device callbacks.
[4/7] - Introduce per-device PM domain callbacks for system suspend.
[5/7] - Add device "stop governor".
[6/7] - Add domain "power off governor".
[7/7] - Automatically update overoptimistic latency information.

Please refer to the changelogs for more information.

The patches haven't been fully tested yet, so most likely there still are some
rough edges here and there.

Thanks,
Rafael

