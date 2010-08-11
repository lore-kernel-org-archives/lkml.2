Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab0HKXtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:49:52 -0400
Received: from kroah.org ([198.145.64.141]:57496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab0HKXtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:49:50 -0400
Date: Wed, 11 Aug 2010 16:48:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/11] 2.6.27.51-stable review
Message-ID: <20100811234809.GA676@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.51 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, August 13, 2010, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.51-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                 |    2 +-
 arch/x86/xen/enlighten.c |    2 +-
 arch/x86/xen/time.c      |   43 +----------------------
 arch/x86/xen/xen-ops.h   |    3 +-
 drivers/char/nvram.c     |   14 +++++--
 drivers/md/raid10.c      |   18 +++++++++
 drivers/pci/quirks.c     |    1 +
 fs/ecryptfs/file.c       |   60 +++++++++++++++++++------------
 fs/jfs/xattr.c           |   87 ++++++++++++++++++++--------------------------
 fs/signalfd.c            |    2 +
 fs/splice.c              |   12 +------
 mm/backing-dev.c         |    3 ++
 12 files changed, 115 insertions(+), 132 deletions(-)
