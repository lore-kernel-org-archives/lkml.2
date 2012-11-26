Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2KZUZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:25:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:60660 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab2KZUZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:25:42 -0500
Date: Mon, 26 Nov 2012 12:25:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.20
Message-ID: <20121126202534.GA25269@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.20 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/cgroups/memory.txt              |    4=20
 Makefile                                      |    2=20
 arch/arm/plat-omap/include/plat/omap-serial.h |    4=20
 arch/m68k/include/asm/signal.h                |    6=20
 arch/s390/include/asm/compat.h                |    2=20
 arch/s390/include/asm/ptrace.h                |    4=20
 arch/s390/kernel/compat_signal.c              |   14=20
 arch/s390/kernel/signal.c                     |   14=20
 arch/s390/mm/gup.c                            |    2=20
 crypto/cryptd.c                               |   11=20
 drivers/acpi/video.c                          |   11=20
 drivers/block/rbd.c                           |   37=20
 drivers/gpu/drm/i915/intel_overlay.c          |   14=20
 drivers/gpu/drm/radeon/atombios_encoders.c    |    2=20
 drivers/gpu/drm/ttm/ttm_page_alloc.c          |    5=20
 drivers/net/ethernet/marvell/sky2.c           |    4=20
 drivers/net/ethernet/realtek/r8169.c          |    7=20
 drivers/staging/android/android_alarm.h       |    4=20
 drivers/tty/serial/omap-serial.c              |   12=20
 drivers/usb/serial/option.c                   |    9=20
 drivers/usb/serial/usb-serial.c               |    6=20
 drivers/xen/events.c                          |    2=20
 fs/ceph/addr.c                                |   32=20
 fs/ceph/debugfs.c                             |    1=20
 fs/ceph/mds_client.c                          |   67 -
 fs/ceph/mds_client.h                          |    5=20
 fs/cifs/cifsacl.c                             |   49 -
 fs/ecryptfs/main.c                            |   23=20
 fs/nfs/nfs4proc.c                             |    3=20
 fs/notify/fanotify/fanotify.c                 |    1=20
 fs/reiserfs/inode.c                           |   10=20
 fs/reiserfs/stree.c                           |    4=20
 fs/reiserfs/super.c                           |   60 +
 fs/ubifs/find.c                               |   12=20
 fs/ubifs/lprops.c                             |    6=20
 fs/ubifs/ubifs.h                              |    3=20
 fs/xfs/xfs_buf.c                              |   14=20
 include/linux/ceph/auth.h                     |   12=20
 include/linux/ceph/libceph.h                  |    2=20
 include/linux/ceph/messenger.h                |   78 -
 include/linux/ceph/mon_client.h               |    2=20
 include/linux/ceph/msgpool.h                  |    3=20
 include/linux/ceph/osd_client.h               |   13=20
 include/linux/ceph/osdmap.h                   |    6=20
 include/linux/crush/crush.h                   |    7=20
 include/linux/crush/mapper.h                  |    6=20
 kernel/module.c                               |   27=20
 mm/memcontrol.c                               |   21=20
 mm/shmem.c                                    |    2=20
 mm/vmscan.c                                   |    2=20
 net/ceph/auth_none.c                          |   15=20
 net/ceph/auth_x.c                             |   15=20
 net/ceph/ceph_common.c                        |   28=20
 net/ceph/crush/crush.c                        |   14=20
 net/ceph/crush/mapper.c                       |   66 -
 net/ceph/crypto.c                             |    1=20
 net/ceph/crypto.h                             |    3=20
 net/ceph/debugfs.c                            |    4=20
 net/ceph/messenger.c                          | 1103 ++++++++++++++++-----=
-----
 net/ceph/mon_client.c                         |  135 ++-
 net/ceph/msgpool.c                            |    7=20
 net/ceph/osd_client.c                         |  175 ++--
 net/ceph/osdmap.c                             |   44 -
 net/core/dev.c                                |    4=20
 net/core/dev_addr_lists.c                     |    3=20
 net/ipv4/ip_sockglue.c                        |   35=20
 net/ipv4/netfilter/nf_nat_standalone.c        |    6=20
 net/ipv6/ipv6_sockglue.c                      |    1=20
 net/mac80211/ieee80211_i.h                    |    2=20
 net/mac80211/sta_info.c                       |   11=20
 net/mac80211/status.c                         |    9=20
 net/mac80211/tx.c                             |    9=20
 net/mac80211/util.c                           |    2=20
 net/netfilter/nf_conntrack_proto_tcp.c        |   29=20
 net/wireless/reg.c                            |    5=20
 security/selinux/netnode.c                    |    3=20
 sound/pci/hda/patch_analog.c                  |    1=20
 sound/pci/hda/patch_cirrus.c                  |   16=20
 sound/pci/hda/patch_realtek.c                 |    3=20
 sound/pci/hda/patch_via.c                     |   25=20
 sound/soc/codecs/wm8978.c                     |    2=20
 sound/soc/soc-dapm.c                          |    2=20
 82 files changed, 1487 insertions(+), 938 deletions(-)

Alex Deucher (1):
      drm/radeon: fix logic error in atombios_encoders.c

Alex Elder (60):
      ceph: osd_client: fix endianness bug in osd_req_encode_op()
      ceph: messenger: use read_partial() in read_partial_message()
      ceph: messenger: update "to" in read_partial() caller
      ceph: messenger: change read_partial() to take "end" arg
      libceph: don't reset kvec in prepare_write_banner()
      ceph: messenger: reset connection kvec caller
      ceph: messenger: send banner in process_connect()
      ceph: drop msgr argument from prepare_write_connect()
      ceph: don't set WRITE_PENDING too early
      ceph: messenger: check prepare_write_connect() result
      ceph: messenger: rework prepare_connect_authorizer()
      ceph: messenger: check return from get_authorizer
      ceph: define ceph_auth_handshake type
      ceph: messenger: reduce args to create_authorizer
      ceph: ensure auth ops are defined before use
      ceph: have get_authorizer methods return pointers
      ceph: use info returned by get_authorizer
      ceph: return pointer from prepare_connect_authorizer()
      ceph: rename prepare_connect_authorizer()
      ceph: add auth buf in prepare_write_connect()
      libceph: osd_client: don't drop reply reference too early
      rbd: don't hold spinlock during messenger flush
      libceph: eliminate connection state "DEAD"
      libceph: kill bad_proto ceph connection op
      libceph: rename socket callbacks
      libceph: rename kvec_reset and kvec_add functions
      libceph: embed ceph messenger structure in ceph_client
      libceph: start separating connection flags from state
      libceph: start tracking connection socket state
      libceph: provide osd number when creating osd
      libceph: set CLOSED state bit in con_init
      libceph: embed ceph connection structure in mon_client
      libceph: init monitor connection when opening
      libceph: fully initialize connection in con_init()
      libceph: tweak ceph_alloc_msg()
      libceph: have messages point to their connection
      libceph: have messages take a connection reference
      libceph: make ceph_con_revoke() a msg operation
      libceph: make ceph_con_revoke_message() a msg op
      libceph: encapsulate out message data setup
      libceph: encapsulate advancing msg page
      libceph: don't mark footer complete before it is
      libceph: move init_bio_*() functions up
      libceph: move init of bio_iter
      libceph: don't use bio_iter as a flag
      libceph: SOCK_CLOSED is a flag, not a state
      libceph: don't change socket state on sock event
      libceph: just set SOCK_CLOSED when state changes
      libceph: don't touch con state in con_close_socket()
      libceph: clear CONNECTING in ceph_con_close()
      libceph: clear NEGOTIATING when done
      libceph: define and use an explicit CONNECTED state
      libceph: separate banner and connect writes
      libceph: distinguish two phases of connect sequence
      libceph: small changes to messenger.c
      libceph: add some fine ASCII art
      libceph: only kunmap kmapped pages
      rbd: reset BACKOFF if unable to re-queue
      ceph: avoid 32-bit page index overflow
      libceph: drop declaration of ceph_con_get()

Alexander Stein (1):
      ALSA: hda: Cirrus: Fix coefficient index for beep configuration

Andreas Schwab (1):
      m68k: fix sigset_t accessor functions

Arik Nemtsov (1):
      mac80211: sync acccess to tx_filtered/ps_tx_buf queues

Artem Bityutskiy (2):
      UBIFS: fix mounting problems after power cuts
      UBIFS: introduce categorized lprops counter

Bryan Schumaker (1):
      NFS: Wait for session recovery to finish before returning

Colin Cross (1):
      Revert "Staging: Android alarm: IOCTL command encoding fix"

Cyril Brulebois (1):
      r8169: Fix WoL on RTL8168d/8111d.

Dan Carpenter (1):
      libceph: fix NULL dereference in reset_connection()

Dan Williams (2):
      USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
      USB: option: add Alcatel X220/X500D USB IDs

Daniel J Blueman (1):
      ALSA: HDA: Fix digital microphone on CS420x

Daniel Vetter (1):
      drm/i915: fix overlay on i830M

Dave Chinner (1):
      xfs: drop buffer io reference when a bad bio is built

Dave Jones (1):
      selinux: fix sel_netnode_insert() suspicious rcu dereference

Eric Millbrandt (1):
      ASoC: wm8978: pll incorrectly configured when codec is master

Eric Paris (1):
      fanotify: fix missing break

Felipe Balbi (1):
      Revert "serial: omap: fix software flow control"

Felix Fietkau (1):
      mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queu=
e_purge

Greg Kroah-Hartman (1):
      Linux 3.4.20

Guanjun He (1):
      libceph: prevent the race of incoming work during teardown

Hannes Frederic Sowa (1):
      ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT) forgot to set retu=
rn value

Heiko Carstens (1):
      s390/gup: add missing TASK_SIZE check to get_user_pages_fast()

Hugh Dickins (1):
      tmpfs: change final i_blocks BUG to WARNING

Igor Murzov (1):
      ACPI video: Ignore errors after _DOD evaluation.

Jan Kara (4):
      reiserfs: Fix lock ordering during remount
      reiserfs: Protect reiserfs_quota_on() with write lock
      reiserfs: Move quota calls out of write lock
      reiserfs: Protect reiserfs_quota_write() with write lock

Jan Safrata (1):
      usb: use usb_serial_put in usb_serial_probe errors

Jeff Layton (1):
      cifs: fix potential buffer overrun in cifs.idmap handling code

Jim Schutt (1):
      libceph: avoid truncation due to racing banners

Jiri Pirko (1):
      net: correct check in dev_addr_del()

Johannes Berg (2):
      mac80211: don't send null data packet when not associated
      wireless: allow 40 MHz on world roaming channels 12/13

Josh Durgin (2):
      rbd: protect read of snapshot sequence number
      rbd: store snapshot id instead of index

Jozsef Kadlecsik (2):
      netfilter: Validate the sequence number of dataless ACK packets as we=
ll
      netfilter: Mark SYN/ACK packets as invalid from original direction

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent d=
ata corruption

Kailang Yang (1):
      ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)

Martin Schwidefsky (1):
      s390/signal: set correct address space control

Michal Hocko (1):
      memcg: oom: fix totalpages calculation for memory.swappiness=3D=3D0

Michal Schmidt (1):
      r8169: use unlimited DMA burst for TX

Mirko Lindner (1):
      sky2: Fix for interrupt handler

Misael Lopez Cruz (1):
      ASoC: dapm: Use card_list during DAPM shutdown

Mojiong Qiu (1):
      xen/events: fix RCU warning, or Call idle notifier after irq_enter()

Nathan Walp (1):
      r8169: allow multicast packets on sub-8168f chipset.

Rusty Russell (1):
      module: fix out-by-one error in kallsyms

Sage Weil (42):
      crush: clean up types, const-ness
      crush: adjust local retry threshold
      crush: be more tolerant of nonsensical crush maps
      crush: fix tree node weight lookup
      crush: fix memory leak when destroying tree buckets
      libceph: avoid unregistering osd request when not registered
      libceph: fix pg_temp updates
      libceph: use con get/put ops from osd_client
      libceph: flush msgr queue during mon_client shutdown
      libceph: fix messenger retry
      libceph: drop connection refcounting for mon_client
      libceph: transition socket state prior to actual connect
      libceph: use con get/put methods
      libceph: drop ceph_con_get/put helpers and nref member
      libceph: set peer name on con_open, not init
      libceph: initialize mon_client con only once
      libceph: allow sock transition from CONNECTING to CLOSED
      libceph: initialize msgpool message types
      libceph: report socket read/write error message
      libceph: fix mutex coverage for ceph_con_close
      libceph: resubmit linger ops when pg mapping changes
      libceph: (re)initialize bio_iter on start of message receive
      libceph: protect ceph_con_open() with mutex
      libceph: reset connection retry on successfully negotiation
      libceph: fix fault locking; close socket on lossy fault
      libceph: move msgr clear_standby under con mutex protection
      libceph: move ceph_con_send() closed check under the con mutex
      libceph: drop gratuitous socket close calls in con_work
      libceph: close socket directly from ceph_con_close()
      libceph: drop unnecessary CLOSED check in socket state change callback
      libceph: replace connection state bits with states
      libceph: clean up con flags
      libceph: clear all flags on con_close
      libceph: fix handling of immediate socket connect failure
      libceph: revoke mon_client messages on session restart
      libceph: verify state after retaking con lock after dispatch
      libceph: avoid dropping con mutex before fault
      libceph: change ceph_con_in_msg_alloc convention to be less weird
      libceph: recheck con state after allocating incoming message
      libceph: delay debugfs initialization until we learn global_id
      libceph: avoid NULL kref_put when osd reset races with alloc_msg
      libceph: check for invalid mapping

Sylvain Munaut (1):
      libceph: fix crypto key null deref, memory leak

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning from k=
swapd()

Takashi Iwai (4):
      ALSA: hda - Force to reset IEC958 status bits for AD codecs
      ALSA: hda - Fix empty DAC filling in patch_via.c
      ALSA: hda - Fix invalid connections in VT1802 codec
      ALSA: hda - Add a missing quirk entry for iMac 9,1

Tim Sally (1):
      eCryptfs: check for eCryptfs cipher support at mount

Tom Herbert (1):
      net-rps: Fix brokeness causing OOO packets

Tyler Hicks (1):
      eCryptfs: Copy up POSIX ACL and read-only flags from lower mount

Ulrich Weber (1):
      netfilter: nf_nat: don't check for port change on ICMP tuples

Xi Wang (4):
      ipv4: avoid undefined behavior in do_ip_setsockopt()
      libceph: fix overflow in __decode_pool_names()
      libceph: fix overflow in osdmap_decode()
      libceph: fix overflow in osdmap_apply_incremental()

Yan, Zheng (4):
      rbd: Clear ceph_msg->bio_iter for retransmitted message
      rbd: Fix ceph_snap_context size calculation
      ceph: check PG_Private flag before accessing page->private
      ceph: Fix oops when handling mdsmap that decreases max_mds

Zhao Yakui (1):
      ttm: Clear the ttm page allocated from high memory zone correctly


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQs9A+AAoJEDjbvchgkmk+MLYP+gLlAl4xTWADyCA3uMoay4lr
aooLW1ssPTIMNUQO5vWQezxowxS/hY/YvGyhjEj26vxYX+PZVx6UOAIhTLQid8se
GCVSaPN5UTi0ws/ylCWh3UtDA4khN2MVoHywZ/SH80hXXK7S7OJ05CuvTSdQjMhO
2VNaQlhCsSXlzNbAyXH8Pw/UxfPBVEJ0w8q81zGQT9Xb8gRmSDB+AgQmgTk3nodO
uwUXgaSWBoENrx6T7SqouNfnxtoIYBRSUH6R9SDVjrGJO0+XWWxNZNjR8fr3OiAG
1OE7VtRKndlllwxMbe0qjSQkKgroLLyJhq0Ur/jw20qmhptmYNjhuoIXCW87sHrI
1RF91kDRlEZtQS+rSIKJujT4kw239vrtdYkJo9jIHN7ldHpRPD4plvW8Gfx1djSg
NwZNVNVBePzYYc4ha5z9ziZrKT+bGp6D6obfChBVlQ2TLGa+1lhXbcDpkYGBaTqH
QxfOqmxoTKturXmsxbMEcNnYSUz1tkGSpdNtGXNRXeQBDlDuzmUJh5+6erC+aRvy
xa18gXByVqeaxhBRxZWNRYWoDXonh3c4Y2tJIaIwHnOOoQoWWDZlqn/+d/xKhOpe
lMqnAJewho3QtyQOVZ0fxHP6PImnVbpsUJNC53lHb833PWsvKrwpnaomft3bPvXo
AKBBF0G7yYJxoC8wYyqz
=Uzzb
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
