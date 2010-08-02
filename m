Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0HBTDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:03:14 -0400
Received: from kroah.org ([198.145.64.141]:36998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab0HBTDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:03:12 -0400
Date: Mon, 2 Aug 2010 12:00:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.49
Message-ID: <20100802190010.GA17098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.49 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 arch/x86/kernel/pci-calgary_64.c          |   17 +++++++++------
 drivers/char/agp/amd64-agp.c              |   27 ++++++++++++++-----------
 drivers/hwmon/coretemp.c                  |   32 ++++++++++++++++++++++++++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    4 +--
 drivers/net/bonding/bond_main.c           |    1 
 drivers/net/cpmac.c                       |    3 +-
 drivers/net/sky2.c                        |   19 +++++++++++++----
 drivers/net/wireless/hostap/hostap_cs.c   |   10 +++++++++
 drivers/net/wireless/hostap/hostap_hw.c   |   13 ++++++++++++
 drivers/net/wireless/hostap/hostap_wlan.h |    2 -
 drivers/scsi/aacraid/commctrl.c           |    4 +--
 fs/cifs/cifssmb.c                         |   16 +++++++++++++++
 fs/cifs/sess.c                            |   10 ---------
 fs/ecryptfs/messaging.c                   |   17 ++++++++-------
 include/math-emu/op-common.h              |    2 -
 net/ipv6/netfilter/ip6t_REJECT.c          |    6 +++--
 scripts/mod/modpost.c                     |    2 -
 18 files changed, 133 insertions(+), 54 deletions(-)

Andre Osterhues (1):
      ecryptfs: Bugfix for error related to ecryptfs_hash_buckets

Ben Hutchings (1):
      amd64-agp: Probe unknown AGP devices the right way

Brandon Philips (1):
      sky2: enable rx/tx in sky2_phy_reinit()

Darrick J. Wong (2):
      x86, Calgary: Increase max PHB number
      x86, Calgary: Limit the max PHB number to 256

Eric Dumazet (1):
      netfilter: ip6t_REJECT: fix a dst leak in ipv6 REJECT

Florian Fainelli (1):
      cpmac: do not leak struct net_device on phy_connect errors

Greg Kroah-Hartman (1):
      Linux 2.6.27.49

Jean Delvare (2):
      hwmon: (coretemp) Properly label the sensors
      hwmon: (coretemp) Skip duplicate CPU entries

Jeff Layton (1):
      cifs: remove bogus first_time check in NTLMv2 session setup code

Jiri Pirko (1):
      bonding: select current active slave when enslaving device for mode tlb and alb

Julia Lawall (1):
      SCSI: aacraid: Eliminate use after free

Krzysztof Halasa (1):
      kbuild: Fix modpost segfault

Mikael Pettersson (1):
      math-emu: correct test for downshifting fraction in _FP_FROM_INT()

Or Gerlitz (1):
      IPoIB: Fix world-writable child interface control sysfs attributes

Suresh Jayaraman (1):
      cifs: Fix a kernel BUG with remote OS/2 server (try #3)

Tim Gardner (1):
      hostap: Protect against initialization interrupt

