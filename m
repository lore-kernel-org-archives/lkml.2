Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1CKUmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:42:10 -0500
Received: from kroah.org ([198.145.64.141]:37215 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab1CKUmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:42:08 -0500
Date: Fri, 11 Mar 2011 12:41:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/17] 2.6.32.33-longterm review
Message-ID: <20110311204126.GA7223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.33 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, March 13, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.33-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                        |    2 +-
 arch/powerpc/include/asm/hvcall.h               |    1 +
 arch/powerpc/kernel/crash.c                     |   11 +++++-
 arch/powerpc/kernel/machine_kexec_64.c          |   25 +++++++++++++++
 arch/powerpc/kernel/setup_64.c                  |   17 ++++++++--
 arch/powerpc/platforms/pseries/hvCall.S         |   38 +++++++++++++++++++++++
 arch/powerpc/platforms/pseries/lpar.c           |   35 ++++++++++++--------
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 +++++++++++
 drivers/net/ixgbe/ixgbe_main.c                  |    4 ++
 drivers/net/r8169.c                             |    6 ++-
 drivers/s390/char/keyboard.c                    |    3 +-
 drivers/staging/comedi/drivers/jr3_pci.c        |    7 +++-
 fs/nfsd/nfs4xdr.c                               |    4 +-
 include/keys/rxrpc-type.h                       |    1 -
 include/linux/netdevice.h                       |    4 ++
 kernel/cpuset.c                                 |    7 +++-
 mm/mremap.c                                     |    4 +--
 net/core/dev.c                                  |   12 ++++++-
 net/ipv4/ip_gre.c                               |    1 +
 net/ipv4/ipip.c                                 |    1 +
 net/ipv6/sit.c                                  |    2 +-
 net/netfilter/nf_log.c                          |    4 ++
 22 files changed, 170 insertions(+), 37 deletions(-)
