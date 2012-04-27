Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab2D0RrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:47:02 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:48042 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760440Ab2D0Rq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:46:59 -0400
Date: Fri, 27 Apr 2012 10:46:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.3.4
Message-ID: <20120427174654.GA26740@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.3.4 kernel.

All users of the 3.3 kernel series must upgrade.

The updated 3.3.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.3.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                       |    2=20
 arch/arm/mach-at91/board-sam9261ek.c           |    5 -
 arch/arm/mach-omap1/timer.c                    |    4 -
 arch/arm/mach-omap2/serial.c                   |    8 ++
 crypto/sha512_generic.c                        |    2=20
 drivers/bluetooth/ath3k.c                      |    2=20
 drivers/bluetooth/btusb.c                      |    1=20
 drivers/md/md.c                                |    7 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c      |   25 +++++++
 drivers/media/dvb/frontends/drxk_hard.c        |    6 +
 drivers/media/rc/winbond-cir.c                 |    1=20
 drivers/mmc/card/block.c                       |   54 +++++++++++-----
 drivers/mmc/card/queue.c                       |    2=20
 drivers/mmc/core/core.c                        |    9 +-
 drivers/mmc/host/sdhci-esdhc-imx.c             |    3=20
 drivers/mmc/host/sdhci.c                       |    2=20
 drivers/net/bonding/bond_main.c                |    6 +
 drivers/net/dummy.c                            |    6 -
 drivers/net/ethernet/atheros/atlx/atl1.c       |   12 +--
 drivers/net/ethernet/atheros/atlx/atl1.h       |    3=20
 drivers/net/ethernet/atheros/atlx/atlx.c       |    2=20
 drivers/net/ethernet/micrel/ks8851_mll.c       |    2=20
 drivers/net/ethernet/micrel/ksz884x.c          |    2=20
 drivers/net/ethernet/realtek/8139cp.c          |   10 ++-
 drivers/net/ethernet/smsc/smsc911x.c           |   14 +---
 drivers/net/ethernet/ti/davinci_mdio.c         |    5 +
 drivers/net/phy/icplus.c                       |    3=20
 drivers/net/ppp/ppp_generic.c                  |    3=20
 drivers/net/usb/smsc75xx.c                     |    1=20
 drivers/net/wimax/i2400m/netdev.c              |    3=20
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    8 ++
 drivers/net/wireless/mwifiex/pcie.h            |   18 ++---
 drivers/pci/quirks.c                           |   34 ++++++++++
 drivers/platform/x86/dell-laptop.c             |   28 ++++++++
 drivers/staging/rtl8712/os_intfs.c             |    3=20
 drivers/staging/rtl8712/usb_intf.c             |    5 +
 drivers/tty/amiserial.c                        |    4 -
 drivers/tty/serial/clps711x.c                  |   14 ++--
 drivers/tty/serial/pch_uart.c                  |    4 -
 drivers/usb/core/hub.c                         |    3=20
 drivers/usb/core/message.c                     |    6 -
 drivers/usb/dwc3/ep0.c                         |    3=20
 drivers/usb/gadget/f_fs.c                      |    2=20
 drivers/usb/gadget/udc-core.c                  |    6 +
 drivers/usb/host/ehci-hcd.c                    |    9 ++
 drivers/usb/misc/yurex.c                       |   10 ---
 drivers/usb/musb/omap2430.c                    |    9 +-
 drivers/usb/serial/cp210x.c                    |    9 +-
 drivers/usb/serial/sierra.c                    |    6 +
 drivers/uwb/hwa-rc.c                           |    3=20
 drivers/uwb/neh.c                              |   12 +++
 drivers/xen/gntdev.c                           |    2=20
 drivers/xen/xenbus/xenbus_probe_frontend.c     |   69 ++++++++++++++++-----
 fs/btrfs/ctree.h                               |    2=20
 fs/ext4/extents.c                              |    2=20
 fs/jbd2/commit.c                               |    4 -
 fs/lockd/clnt4xdr.c                            |    2=20
 fs/lockd/clntxdr.c                             |    2=20
 fs/nfsd/nfs3xdr.c                              |   22 ++----
 fs/nfsd/nfs4proc.c                             |    7 +-
 fs/nfsd/nfs4state.c                            |   23 ++-----
 fs/nfsd/nfs4xdr.c                              |    2=20
 fs/ocfs2/alloc.c                               |    2=20
 fs/ocfs2/refcounttree.c                        |   12 +--
 fs/ocfs2/suballoc.c                            |    4 -
 fs/splice.c                                    |    5 +
 include/linux/kvm_host.h                       |    6 +
 include/linux/netdevice.h                      |    2=20
 include/linux/skbuff.h                         |   13 ++++
 include/linux/socket.h                         |    2=20
 mm/memblock.c                                  |    7 +-
 mm/swap_state.c                                |    2=20
 net/ax25/af_ax25.c                             |    9 +-
 net/bridge/br_multicast.c                      |   81 --------------------=
-----
 net/bridge/br_private.h                        |    4 -
 net/core/dev.c                                 |   58 ++++-------------
 net/core/dev_addr_lists.c                      |    3=20
 net/core/net_namespace.c                       |   33 +++++-----
 net/core/skbuff.c                              |    8 +-
 net/ipv4/tcp.c                                 |   13 +---
 net/ipv4/tcp_input.c                           |    8 +-
 net/ipv4/tcp_output.c                          |    3=20
 net/ipv6/mcast.c                               |    2=20
 net/ipv6/tcp_ipv6.c                            |    4 +
 net/mac80211/ibss.c                            |    4 -
 net/netlink/af_netlink.c                       |   24 ++++---
 net/phonet/pep.c                               |    3=20
 net/sched/sch_gred.c                           |    7 --
 net/sctp/socket.c                              |    5 -
 net/socket.c                                   |    6 -
 net/wireless/util.c                            |    2=20
 scripts/mod/file2alias.c                       |    4 +
 sound/pci/hda/patch_conexant.c                 |   37 +++++++++--
 tools/perf/util/hist.c                         |    4 -
 virt/kvm/iommu.c                               |    7 +-
 virt/kvm/kvm_main.c                            |    5 -
 96 files changed, 545 insertions(+), 382 deletions(-)

AceLan Kao (3):
      dell-laptop: add 3 machines that has touchpad LED
      dell-laptop: touchpad LED should persist its status after S3
      Bluetooth: Add support for Atheros [04ca:3005]

Adrian Hunter (2):
      mmc: fixes for eMMC v4.5 discard operation
      mmc: fixes for eMMC v4.5 sanitize operation

Al Viro (11):
      ext4: fix endianness breakage in ext4_split_extent_at()
      nfsd: fix b0rken error value for setattr on read-only mount
      nfsd: fix error values returned by nfsd4_lockt() when nfsd_open() fai=
ls
      nfsd: fix endianness breakage in TEST_STATEID handling
      nfsd: fix compose_entry_fh() failure exits
      btrfs: btrfs_root_readonly() broken on big-endian
      ocfs2: ->l_next_free_req breakage on big-endian
      ocfs: ->rl_used breakage on big-endian
      ocfs2: ->rl_count endianness breakage
      ocfs2: ->e_leaf_clusters endianness breakage
      lockd: fix the endianness bug

Alan Stern (3):
      EHCI: fix criterion for resuming the root hub
      EHCI: always clear the STS_FLR status bit
      USB: fix deadlock in bConfigurationValue attribute method

Alex Williamson (1):
      KVM: unmap pages from the iommu when slots are removed

Alexander Shiyan (1):
      ARM: clps711x: serial driver hungs are a result of call disable_irq w=
ithin ISR

Alexey Khoroshilov (1):
      media: drxk: Does not unlock mutex if sanity check failed in scu_comm=
and()

Andrzej Pietrasiewicz (1):
      usb: gadget: eliminate NULL pointer dereference (bugfix)

Arend van Spriel (1):
      brcm80211: smac: resume transmit fifo upon receiving frames

Bing Zhao (1):
      mwifiex: update pcie8766 scratch register addresses

Bj=F8rn Mork (1):
      USB: sierra: avoid QMI/wwan interface on MC77xx

Christian Riesch (1):
      davinci_mdio: Fix MDIO timeout check

Dan Carpenter (1):
      ksz884x: don't copy too much in netdev_set_mac_address()

Daniel Drake (1):
      mmc: sdhci: refine non-removable card checking for card detection

David H=E4rdeman (1):
      media: rc-core: set mode for winbond-cir

David Miller (1):
      Fix modpost failures in fedora 17

David Ward (1):
      net_sched: gred: Fix oops in gred_dump() in WRED mode

David Woodhouse (1):
      ppp: Don't stop and restart queue on every TX packet

Davide Ciminaghi (1):
      net/ethernet: ks8851_mll fix rx frame buffer overflow

Eric B=E9nard (1):
      mmc: unbreak sdhci-esdhc-imx on i.MX25

Eric Dumazet (8):
      net: fix /proc/net/dev regression
      tcp: allow splice() to build full TSO packets
      netlink: fix races after skb queueing
      net: fix a race in sock_queue_err_skb()
      tcp: restore correct limit
      tcp: fix tcp_grow_window() for large incoming frames
      net: allow pskb_expand_head() to get maximum tailroom
      tcp: avoid order-1 allocations on wifi and tx path

Eric W. Biederman (1):
      net ax25: Reorder ax25_exit to remove races.

Felipe Balbi (2):
      usb: gadget: udc-core: stop UDC on device-initiated disconnect
      usb: dwc3: ep0: increment "actual" on bounced ep0 case

Felix Fietkau (1):
      mac80211: fix logic error in ibss channel type check

Greg Kroah-Hartman (1):
      Linux 3.3.4

Herbert Xu (1):
      bridge: Do not send queries on multicast group leaves

Hiroaki SHIMODA (1):
      dummy: Add ndo_uninit().

Hugh Dickins (1):
      mm: fix s390 BUG by __set_page_dirty_no_writeback on swap

Jason Wang (1):
      8139cp: set intr mask after its handler is registered

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix at91sam9261ek Ethernet dm9000 irq

Julia Lawall (1):
      drivers/tty/amiserial.c: add missing tty_unlock

Julian Anastasov (1):
      netns: do not leak net_generic data on failed init

Kent Yoder (1):
      crypto: sha512 - Fix byte counter overflow in SHA-512

Kishon Vijay Abraham I (2):
      usb: gadget: udc-core: fix asymmetric calls in remove_driver
      usb: musb: omap: fix crash when musb glue (omap) gets initialized

Konrad Rzeszutek Wilk (1):
      xen/xenbus: Add quirk to deal with misconfigured backends.

Larry Finger (1):
      staging: r8712u: Fix regression caused by commit 8c213fa

Lukasz Kucharczyk (1):
      cfg80211: fix interface combinations check.

Mauro Carvalho Chehab (1):
      media: dvb_frontend: Fix a regression when switching back to DVB-S

Neal Cardwell (2):
      tcp: fix tcp_rcv_rtt_update() use of an unscaled RTT sample
      tcp: fix TCP_MAXSEG for established IPv6 passive sockets

NeilBrown (2):
      md: don't call ->add_disk unless there is good reason.
      md: fix possible corruption of array metadata on shutdown.

Oliver Neukum (2):
      uwb: fix use of del_timer_sync() in interrupt
      uwb: fix error handling

Paul Walmsley (1):
      ARM: OMAP1: DMTIMER: fix broken timer clock source selection

Phil Sutter (1):
      wimax: i2400m - prevent a possible kernel bug due to missing fw_name =
string

RongQing.Li (1):
      ipv6: fix array index in ip6_mc_add_src()

Santosh Shilimkar (1):
      ARM: OMAP: serial: Fix the ocp smart idlemode handling bug

Sasha Levin (1):
      phonet: Check input from user before allocating

Shaohua Li (1):
      jbd2: use GFP_NOFS for blkdev_issue_flush

Shubhrajyoti D (1):
      usb: musb: omap: fix the error check for pm_runtime_get_sync

Srinivas Kandagatla (1):
      phy:icplus:fix Auto Power Saving in ip101a_config_init.

Stefano Stabellini (1):
      xen/gntdev: do not set VM_PFNMAP

Stephane Fillod (1):
      net: usb: smsc75xx: fix mtu

Takashi Iwai (2):
      ALSA: hda/conexant - Don't set HP pin-control bit unconditionally
      ALSA: hda/conexant - Set up the missing docking-station pins

Tejun Heo (1):
      memblock: memblock should be able to handle zero length operations

Thomas Graf (1):
      sctp: Allow struct sctp_event_subscribe to grow without breaking bina=
ries

Thomas Jarosch (1):
      PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs

Tomoki Sekiyama (2):
      USB: yurex: Remove allocation of coherent buffer for setup-packet buf=
fer
      USB: yurex: Fix missing URB_NO_TRANSFER_DMA_MAP flag in urb

Tomoya MORINAGA (1):
      pch_uart: Fix dma channel unallocated issue

Tony Zelenoff (1):
      atl1: fix kernel panic in case of DMA errors

Veaceslav Falico (1):
      bonding: properly unset current_arp_slave on slave link up

Will Deacon (1):
      net: smsc911x: fix skb handling in receive path

Yuri Matylitski (1):
      USB: serial: cp210x: Fixed usb_control_msg timeout values

Zeev Tarantov (1):
      Perf: fix build breakage


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPmtuOAAoJEDjbvchgkmk+93kQAKA8p+klzy6oTqyj1zRNTs6x
vjJGULDVp9YRo4yvy6Wx1127GuVQOrVPKdnJb8huuW+95dWXFOyIJuMbPc2KrBCw
24aXxnv9iHN/NRuJZsJYwnTmwKYSFsz2QuxwrzaYLZqBkuycix78y82yq7LOmQqe
iGXMFLYxo9ZqjkSjcI9ESutO7N0WLW2UWCfzJUMqb/45JMyY+EkLARZQ3ejb/lgf
+bEz0rdg38Et8Y+zJyVrnSMADnzl+oH3/N6EJOk9xCa4C7X0AbmxQDSGwee8UYDn
mvNHybqGmruD7UBI3StBZ31MbCf7uR38GLDlLyjL7tJ7yuo9Xg69kovTCRxi7UOH
bfAxkXMOLQQcikFv26qbk0aG7qviWPtXjrL/JnhlXhi0q5AKqJxPKwieFEzootim
FD3NltEQdUbQdu7QjLgsrpTncgBu9GkrdexgGTqaXNp/y6ZFD7HsNasdAYFD4yU2
utjsshMvAZoTk92pF3LgQr/gxaWGX8CzN1r+uGL7S6SVlHUBfU6RmChXg0XaRtEI
jj9SNp5IEYcC6XRbajFWdtbP9/n6zGHUKa1qHrlBvAXwHftoHHcKyNusT4BjEjoU
jpfFWL+joFX7yGCc5PBaOXOzXsb3xaXnh+llXWKl8of+pmiCJzZZFMGdMI0VdQ7U
xkczL/WAtTl/fJhlXKcg
=CvOR
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
