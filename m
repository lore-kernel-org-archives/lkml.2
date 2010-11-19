Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab0KSVee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:34:34 -0500
Received: from kroah.org ([198.145.64.141]:44433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab0KSVed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:34:33 -0500
Date: Fri, 19 Nov 2010 13:33:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/5] 2.6.27.56-stable review
Message-ID: <20101119213300.GA4637@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.56 release.
There are 5 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, November 22, 2010, 12:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.56-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                          |    2 +-
 drivers/char/pcmcia/synclink_cs.c |    2 ++
 drivers/scsi/gdth.c               |    8 ++++++++
 drivers/scsi/libsas/sas_ata.c     |    1 +
 drivers/scsi/scsi_sysfs.c         |    3 ++-
 kernel/sched.c                    |    7 +++----
 6 files changed, 17 insertions(+), 6 deletions(-)
