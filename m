Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0G3RD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:03:29 -0400
Received: from kroah.org ([198.145.64.141]:35476 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0G3RD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:27 -0400
Date: Fri, 30 Jul 2010 10:00:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/17] 2.6.27.49-rc1 stable review
Message-ID: <20100730170054.GA7736@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.27.49 release.
There are 17 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by August 1, 2010, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.49-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                  |    2 +-
 arch/x86/kernel/pci-calgary_64.c          |   17 +++++++++------
 drivers/char/agp/amd64-agp.c              |   27 +++++++++++++----------
 drivers/hwmon/coretemp.c                  |   32 +++++++++++++++++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    4 +-
 drivers/net/bonding/bond_main.c           |    1 +
 drivers/net/cpmac.c                       |    3 +-
 drivers/net/sky2.c                        |   19 ++++++++++++----
 drivers/net/wireless/hostap/hostap_cs.c   |   10 +++++++++
 drivers/net/wireless/hostap/hostap_hw.c   |   13 +++++++++++
 drivers/net/wireless/hostap/hostap_wlan.h |    2 +-
 drivers/scsi/aacraid/commctrl.c           |    4 +-
 fs/cifs/cifssmb.c                         |   16 ++++++++++++++
 fs/cifs/sess.c                            |   10 +--------
 fs/ecryptfs/messaging.c                   |   17 ++++++++-------
 include/math-emu/op-common.h              |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c          |    6 +++-
 scripts/mod/modpost.c                     |    2 +-
 18 files changed, 133 insertions(+), 54 deletions(-)
