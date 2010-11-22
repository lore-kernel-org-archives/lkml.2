Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0KVTUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:20:08 -0500
Received: from kroah.org ([198.145.64.141]:55823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab0KVTUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:20:06 -0500
Date: Mon, 22 Nov 2010 11:15:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.56
Message-ID: <20101122191500.GA4340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.56 kernel.

All users of the 2.6.27 kernel series must upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 +-
 drivers/char/pcmcia/synclink_cs.c |    2 ++
 drivers/scsi/gdth.c               |    8 ++++++++
 drivers/scsi/libsas/sas_ata.c     |    1 +
 drivers/scsi/scsi_sysfs.c         |    3 ++-
 kernel/sched.c                    |    7 +++----
 6 files changed, 17 insertions(+), 6 deletions(-)

Christof Schmitt (1):
      Fix race when removing SCSI devices

Dan Carpenter (1):
      gdth: integer overflow in ioctl

David Milburn (1):
      libsas: fix NCQ mixing with non-NCQ

Greg Kroah-Hartman (1):
      Linux 2.6.27.56

Mathieu Desnoyers (1):
      sched: Fix string comparison in /proc/sched_features

Vasiliy Kulikov (1):
      pcmcia: synclink_cs: fix information leak to userland

