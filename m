Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1F0Pp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:45:56 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37178 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752168Ab1F0Ppx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:45:53 -0400
Message-Id: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
        Brent Casavant <bcasavan@sgi.com>, David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Grundler <grundler@parisc-linux.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jaroslav Kysela <perex@perex.cz>, Richard Purdie <rpurdie@rpsys.net>,
        Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
        Tejun Heo <tj@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-scsi@vger.kernel.org,
        linux-serial@vger.kernel.org, netdev@vger.kernel.org
Date: Sun, 26 Jun 2011 12:19:54 +0100
Subject: [PATCH 00/12] Fix various section mismatches and build errors.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting screen and screens full of section mismatches from my test
builds of the current kernel to the point where it's sometimes more
meaningful messages get hidden by the bulk of mismatches.  This is the
first round of fixes with more to come.

  Ralf

 drivers/gpu/drm/radeon/radeon_clocks.c |    4 ++--
 drivers/leds/leds-lp5521.c             |    4 ++--
 drivers/leds/leds-lp5523.c             |    4 ++--
 drivers/misc/ioc4.c                    |    2 +-
 drivers/net/3c509.c                    |    2 +-
 drivers/net/3c59x.c                    |    2 +-
 drivers/net/depca.c                    |   25 +++++++++++++------------
 drivers/net/hp100.c                    |    2 +-
 drivers/net/ne3210.c                   |   12 +++++++-----
 drivers/net/tulip/de4x5.c              |    2 +-
 drivers/scsi/sim710.c                  |    2 +-
 drivers/tty/serial/Kconfig             |    2 +-
 12 files changed, 33 insertions(+), 30 deletions(-)

