Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2LSSmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:42:50 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47420 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2LSSmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:42:42 -0500
Date: Wed, 19 Dec 2012 10:42:35 -0800
From: Kees Cook <kees@outflux.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: [RESEND][GIT PULL] CONFIG_EXPERIMENTAL removal for 3.8
Message-ID: <20121219184235.GA11109@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this tree of CONFIG_EXPERIMENTAL removals for 3.8. These
are the Acked subset of patches of my larger "drop-experimental" tree
that other maintainers asked me to carry for them in linux-next.

There are some conflicts that have cropped up during the merge window,
but they're all pretty trivial: take what ever is most recent and delete
"EXPERIMENTAL". :)

Thanks!

-Kees

The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:

  Linux 3.7 (2012-12-10 19:30:57 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/for-linus-3.8

for you to fetch changes up to 6b81c0f59cf689e81f80d8a601b08c5316b96a1f:

  tools/lguest: remove depends on CONFIG_EXPERIMENTAL (2012-12-11 16:38:26 -0800)

----------------------------------------------------------------
Initial batch of CONFIG_EXPERIMENTAL removals for 3.8.

----------------------------------------------------------------
Kees Cook (81):
      make CONFIG_EXPERIMENTAL invisible and default
      Documentation: remove depends on CONFIG_EXPERIMENTAL
      arch/alpha: remove depends on CONFIG_EXPERIMENTAL
      arch/cris/arch-v32/drivers: remove depends on CONFIG_EXPERIMENTAL
      arch/ia64/kvm: remove depends on CONFIG_EXPERIMENTAL
      arch/ia64: remove depends on CONFIG_EXPERIMENTAL
      arch/ia64/xen: remove depends on CONFIG_EXPERIMENTAL
      arch/powerpc/platforms/ps3: remove depends on CONFIG_EXPERIMENTAL
      arch/s390: remove depends on CONFIG_EXPERIMENTAL
      arch/s390/kvm: remove depends on CONFIG_EXPERIMENTAL
      arch/um: remove depends on CONFIG_EXPERIMENTAL
      arch/x86: remove depends on CONFIG_EXPERIMENTAL
      arch/x86/um: remove depends on CONFIG_EXPERIMENTAL
      crypto: remove depends on CONFIG_EXPERIMENTAL
      drivers/cpufreq: remove depends on CONFIG_EXPERIMENTAL
      drivers/gpu/drm/udl: remove depends on CONFIG_EXPERIMENTAL
      drivers/i2c/muxes: remove depends on CONFIG_EXPERIMENTAL
      drivers/ide: remove depends on CONFIG_EXPERIMENTAL
      drivers/lguest: remove depends on CONFIG_EXPERIMENTAL
      drivers/mmc/core: remove depends on CONFIG_EXPERIMENTAL
      drivers/mmc/host: remove depends on CONFIG_EXPERIMENTAL
      drivers/media: remove depends on CONFIG_EXPERIMENTAL
      drivers/media/video/cx25821: remove depends on CONFIG_EXPERIMENTAL
      drivers/media/video/pvrusb2: remove depends on CONFIG_EXPERIMENTAL
      drivers/media/video/s5p-fimc: remove depends on CONFIG_EXPERIMENTAL
      drivers/media/video/s5p-tv: remove depends on CONFIG_EXPERIMENTAL
      drivers/mtd: remove depends on CONFIG_EXPERIMENTAL
      drivers/mtd/chips: remove depends on CONFIG_EXPERIMENTAL
      drivers/mtd/devices: remove depends on CONFIG_EXPERIMENTAL
      drivers/mtd/nand: remove depends on CONFIG_EXPERIMENTAL
      drivers/net: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/8390: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/atheros: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/dec/tulip: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/i825xx: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/intel: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/natsemi: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/packetengines: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/realtek: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/silan: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/ti: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/team: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wan: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/usb: remove depends on CONFIG_EXPERIMENTAL
      drivers/pcmcia: remove depends on CONFIG_EXPERIMENTAL
      drivers/ptp: remove depends on CONFIG_EXPERIMENTAL
      drivers/rpmsg: remove depends on CONFIG_EXPERIMENTAL
      drivers/sbus/char: remove depends on CONFIG_EXPERIMENTAL
      drivers/virtio: remove depends on CONFIG_EXPERIMENTAL
      fs/ceph: remove depends on CONFIG_EXPERIMENTAL
      fs/ecryptfs: remove depends on CONFIG_EXPERIMENTAL
      fs/nilfs2: remove depends on CONFIG_EXPERIMENTAL
      fs/xfs: remove depends on CONFIG_EXPERIMENTAL
      init: remove depends on CONFIG_EXPERIMENTAL
      kernel/gcov: remove depends on CONFIG_EXPERIMENTAL
      net: remove depends on CONFIG_EXPERIMENTAL
      net/9p: remove depends on CONFIG_EXPERIMENTAL
      net/ceph: remove depends on CONFIG_EXPERIMENTAL
      net/dccp/ccids: remove depends on CONFIG_EXPERIMENTAL
      net/dccp: remove depends on CONFIG_EXPERIMENTAL
      net/decnet/netfilter: remove depends on CONFIG_EXPERIMENTAL
      net/decnet: remove depends on CONFIG_EXPERIMENTAL
      net/dsa: remove depends on CONFIG_EXPERIMENTAL
      net/ieee802154: remove depends on CONFIG_EXPERIMENTAL
      net/ipv4/netfilter: remove depends on CONFIG_EXPERIMENTAL
      net/ipv4: remove depends on CONFIG_EXPERIMENTAL
      net/ipv6: remove depends on CONFIG_EXPERIMENTAL
      net/l2tp: remove depends on CONFIG_EXPERIMENTAL
      net/lapb: remove depends on CONFIG_EXPERIMENTAL
      net/mac80211: remove depends on CONFIG_EXPERIMENTAL
      net/mac802154: remove depends on CONFIG_EXPERIMENTAL
      net/netfilter: remove depends on CONFIG_EXPERIMENTAL
      net/rds: remove depends on CONFIG_EXPERIMENTAL
      net/rxrpc: remove depends on CONFIG_EXPERIMENTAL
      net/sctp: remove depends on CONFIG_EXPERIMENTAL
      net/sunrpc: remove depends on CONFIG_EXPERIMENTAL
      net/tipc: remove depends on CONFIG_EXPERIMENTAL
      net/wanrouter: remove depends on CONFIG_EXPERIMENTAL
      net/x25: remove depends on CONFIG_EXPERIMENTAL
      net/xfrm: remove depends on CONFIG_EXPERIMENTAL
      tools/lguest: remove depends on CONFIG_EXPERIMENTAL

 Documentation/CodingStyle                  |   10 +-----
 Documentation/DocBook/kernel-hacking.tmpl  |    7 ----
 Documentation/DocBook/kgdb.tmpl            |    6 ++--
 Documentation/intel_txt.txt                |    2 +-
 Documentation/zh_CN/CodingStyle            |    7 ----
 arch/alpha/Kconfig                         |    3 +-
 arch/cris/arch-v32/drivers/Kconfig         |    4 +--
 arch/ia64/Kconfig                          |    8 ++---
 arch/ia64/kvm/Kconfig                      |    2 +-
 arch/ia64/xen/Kconfig                      |    2 +-
 arch/powerpc/platforms/ps3/Kconfig         |    2 +-
 arch/s390/Kconfig                          |    4 +--
 arch/s390/kvm/Kconfig                      |    2 +-
 arch/um/Kconfig.net                        |    2 +-
 arch/um/Kconfig.um                         |    8 ++---
 arch/x86/Kconfig                           |   22 ++++++------
 arch/x86/um/Kconfig                        |    3 +-
 crypto/Kconfig                             |   15 +++-----
 drivers/cpufreq/Kconfig.arm                |    4 +--
 drivers/cpufreq/Kconfig.x86                |    6 ++--
 drivers/gpu/drm/udl/Kconfig                |    2 +-
 drivers/i2c/muxes/Kconfig                  |    2 --
 drivers/ide/Kconfig                        |    8 ++---
 drivers/lguest/Kconfig                     |    2 +-
 drivers/media/Kconfig                      |    7 ++--
 drivers/media/pci/cx25821/Kconfig          |    2 +-
 drivers/media/platform/s5p-fimc/Kconfig    |    1 -
 drivers/media/platform/s5p-tv/Kconfig      |    3 +-
 drivers/media/usb/pvrusb2/Kconfig          |    8 ++---
 drivers/mmc/core/Kconfig                   |    3 +-
 drivers/mmc/host/Kconfig                   |   20 +++++------
 drivers/mtd/Kconfig                        |    2 +-
 drivers/mtd/chips/Kconfig                  |    2 +-
 drivers/mtd/devices/Kconfig                |    4 +--
 drivers/mtd/nand/Kconfig                   |    7 ++--
 drivers/net/Kconfig                        |    9 +++--
 drivers/net/ethernet/8390/Kconfig          |   21 +++++------
 drivers/net/ethernet/atheros/Kconfig       |    8 ++---
 drivers/net/ethernet/dec/tulip/Kconfig     |    4 +--
 drivers/net/ethernet/i825xx/Kconfig        |   12 +++----
 drivers/net/ethernet/intel/Kconfig         |    9 ++---
 drivers/net/ethernet/natsemi/Kconfig       |    3 --
 drivers/net/ethernet/packetengines/Kconfig |    4 +--
 drivers/net/ethernet/realtek/Kconfig       |    4 +--
 drivers/net/ethernet/silan/Kconfig         |    6 ++--
 drivers/net/ethernet/ti/Kconfig            |    4 +--
 drivers/net/team/Kconfig                   |    3 +-
 drivers/net/usb/Kconfig                    |   16 ++++-----
 drivers/net/wan/Kconfig                    |    8 ++---
 drivers/pcmcia/Kconfig                     |    4 +--
 drivers/ptp/Kconfig                        |    1 -
 drivers/rpmsg/Kconfig                      |    3 +-
 drivers/sbus/char/Kconfig                  |    7 ++--
 drivers/virtio/Kconfig                     |    8 ++---
 fs/ceph/Kconfig                            |    4 +--
 fs/ecryptfs/Kconfig                        |    4 +--
 fs/nilfs2/Kconfig                          |    3 +-
 fs/xfs/Kconfig                             |    4 +--
 init/Kconfig                               |   54 +++++++---------------------
 kernel/gcov/Kconfig                        |    2 +-
 net/9p/Kconfig                             |    2 +-
 net/Kconfig                                |    5 ++-
 net/ceph/Kconfig                           |    4 +--
 net/dccp/Kconfig                           |    4 +--
 net/dccp/ccids/Kconfig                     |    5 ++-
 net/decnet/Kconfig                         |    4 +--
 net/decnet/netfilter/Kconfig               |    2 +-
 net/dsa/Kconfig                            |    2 +-
 net/ieee802154/Kconfig                     |    3 +-
 net/ipv4/Kconfig                           |   11 +-----
 net/ipv4/netfilter/Kconfig                 |    4 +--
 net/ipv6/Kconfig                           |   24 ++++++-------
 net/l2tp/Kconfig                           |    4 +--
 net/lapb/Kconfig                           |    3 +-
 net/mac80211/Kconfig                       |    2 +-
 net/mac802154/Kconfig                      |    2 +-
 net/netfilter/Kconfig                      |   24 +++++--------
 net/rds/Kconfig                            |    4 +--
 net/rxrpc/Kconfig                          |    2 +-
 net/sctp/Kconfig                           |    4 +--
 net/sunrpc/Kconfig                         |    2 +-
 net/tipc/Kconfig                           |    4 +--
 net/wanrouter/Kconfig                      |    1 -
 net/x25/Kconfig                            |    3 +-
 net/xfrm/Kconfig                           |   16 ++++-----
 tools/lguest/lguest.txt                    |    8 ++---
 86 files changed, 209 insertions(+), 337 deletions(-)

-- 
Kees Cook
Chrome OS Security
