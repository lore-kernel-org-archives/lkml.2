Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1KSOA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 09:00:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47346 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1KSOAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 09:00:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update 2x][PATCH 0/7] PM / Domains: Per-device callbacks and PM QoS
Date: Sat, 19 Nov 2011 14:56:40 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl> <201111140122.27328.rjw@sisk.pl>
In-Reply-To: <201111140122.27328.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111191456.40453.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the third iteration of the patchset introducing per-device callbacks
and PM QoS support to PM domains.

All patches have been updated due to minor problems found since the previous
iteration.  Patch [7/7] now prints diagnostic messages when updating the
latency values.

On Monday, November 14, 2011, Rafael J. Wysocki wrote:
[...] 
> [1/7] - Make it possible to define per-device start/stop and .active_wakeup()
>         routines.
> 
> [2/7] - Introduce "save/restore state" device callbacks.
> 
> [3/7] - Introduce per-device PM domain callbacks for system suspend.
> 
> [4/7] - Make runtime PM core take device PM QoS constraints into account.
> 
> [5/7] - Add device "stop governor".
> 
> [6/7] - Add domain "power off governor".
> 
> [7/7] - Automatically update overoptimistic latency information.
> 
> The patchset have been tested for backwards compatibility, but it still needs
> some testing for the new features it adds.

If there are no objections, I'm going to queue up this patchset in linux-next
for the 3.3 merge window.

Thanks,
Rafael

