Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0HXWqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:46:53 -0400
Received: from kroah.org ([198.145.64.141]:59767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab0HXWqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:46:48 -0400
Date: Tue, 24 Aug 2010 15:46:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/8] 2.6.27.53-stable review
Message-ID: <20100824224631.GA5458@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.53 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, August 26, 2010 22:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.53-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                      |   14 +++++++++++---
 arch/arm/include/asm/ptrace.h |   17 +++++++++++++----
 drivers/gpu/drm/drm_drv.c     |    4 +++-
 drivers/usb/serial/io_ti.c    |    2 +-
 drivers/usb/serial/navman.c   |    1 +
 firmware/Makefile             |    2 +-
 net/can/bcm.c                 |   38 +++++++++++++++++++++++++-------------
 scripts/mkmakefile            |    4 +++-
 security/selinux/hooks.c      |    2 +-
 9 files changed, 59 insertions(+), 25 deletions(-)
