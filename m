Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0GARxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:53:06 -0400
Received: from kroah.org ([198.145.64.141]:41021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab0GARwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:52:16 -0400
Date: Thu, 1 Jul 2010 10:51:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/23] 2.6.27.48 stable review
Message-ID: <20100701175134.GA2098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701175100.GA2078@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.27.48 release.
There are 23 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
me know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sat, July 3, 17:00:00 UTC UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.48-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                              |    2 +-
 arch/parisc/math-emu/decode_exc.c     |    1 +
 arch/powerpc/lib/string.S             |    4 +-
 arch/powerpc/oprofile/op_model_cell.c |    2 +-
 arch/powerpc/platforms/pseries/smp.c  |    6 +
 drivers/ata/libata-core.c             |    7 +-
 drivers/char/ipmi/ipmi_si_intf.c      |   11 +-
 drivers/md/md.c                       |   29 ++++
 drivers/md/raid1.c                    |    9 +-
 drivers/md/raid10.c                   |    2 +-
 drivers/net/arcnet/com20020-pci.c     |    4 +-
 fs/ext4/inode.c                       |  240 ++++++++++++++++++++++++++------
 fs/ext4/resize.c                      |    3 +-
 fs/namespace.c                        |    9 +-
 fs/nfsd/nfssvc.c                      |    2 +-
 include/linux/fs.h                    |    2 +
 include/net/sctp/structs.h            |    1 +
 mm/filemap.c                          |    6 +
 net/sctp/sm_make_chunk.c              |   62 ++++++++-
 net/tipc/bearer.c                     |   37 +-----
 net/tipc/bearer.h                     |    2 +-
 net/tipc/net.c                        |   25 +---
 scripts/kconfig/Makefile              |    2 +-
 security/keys/keyring.c               |   18 ++--
 security/keys/process_keys.c          |    6 +-
 25 files changed, 359 insertions(+), 133 deletions(-)
