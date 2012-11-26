Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2KZU03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:26:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:60723 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab2KZU01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:26:27 -0500
Date: Mon, 26 Nov 2012 12:26:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.8
Message-ID: <20121126202624.GA3274@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.8 kernel.

All users of the 3.6 kernel series must upgrade.

The updated 3.6.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.6.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/cgroups/memory.txt              |    4 +
 Makefile                                      |    2=20
 arch/arm/boot/dts/tegra30.dtsi                |    4 -
 arch/arm/mach-at91/at91sam9g45_devices.c      |   12 ++--
 arch/arm/mach-imx/ehci-imx25.c                |    2=20
 arch/arm/mach-imx/ehci-imx35.c                |    2=20
 arch/arm/plat-omap/include/plat/omap-serial.h |    4 -
 arch/m68k/include/asm/signal.h                |    6 +-
 arch/s390/include/asm/compat.h                |    2=20
 arch/s390/include/asm/ptrace.h                |    4 -
 arch/s390/kernel/compat_signal.c              |   14 ++++-
 arch/s390/kernel/signal.c                     |   14 ++++-
 arch/s390/mm/gup.c                            |    2=20
 arch/x86/kvm/vmx.c                            |   11 ++--
 crypto/cryptd.c                               |   11 +++-
 drivers/acpi/video.c                          |   11 ++--
 drivers/ata/libata-acpi.c                     |   11 +++-
 drivers/gpu/drm/i915/intel_sdvo.c             |   22 +++++++-
 drivers/gpu/drm/radeon/atombios_encoders.c    |    2=20
 drivers/gpu/drm/ttm/ttm_page_alloc.c          |    5 +
 drivers/i2c/muxes/i2c-mux-pinctrl.c           |    2=20
 drivers/iommu/intel-iommu.c                   |    4 -
 drivers/net/ethernet/broadcom/Kconfig         |    1=20
 drivers/net/ethernet/broadcom/tg3.c           |    9 ---
 drivers/net/ethernet/realtek/r8169.c          |    7 ++
 drivers/net/wireless/iwlwifi/pcie/rx.c        |   23 ++++++++
 drivers/pci/pci-driver.c                      |   12 ----
 drivers/pci/pci-sysfs.c                       |   34 -------------
 drivers/pci/pci.c                             |   32 ++++++++++++
 drivers/pci/pci.h                             |    2=20
 drivers/pci/proc.c                            |    8 +++
 drivers/regulator/core.c                      |    2=20
 drivers/scsi/isci/host.c                      |   10 ++-
 drivers/staging/android/android_alarm.h       |    4 -
 drivers/tty/serial/omap-serial.c              |   12 ++--
 drivers/usb/serial/keyspan.c                  |    3 -
 drivers/usb/serial/option.c                   |    9 +++
 drivers/usb/serial/usb_wwan.c                 |   10 +--
 drivers/virtio/virtio.c                       |    4 +
 drivers/xen/events.c                          |    2=20
 fs/cifs/cifsacl.c                             |   49 +++++++------------
 fs/cifs/dir.c                                 |   11 +++-
 fs/ext4/ext4.h                                |    3 -
 fs/ext4/ext4_jbd2.c                           |    8 ---
 fs/ext4/resize.c                              |    2=20
 fs/ext4/super.c                               |    7 +-
 fs/gfs2/file.c                                |   12 +---
 fs/gfs2/super.c                               |    3 -
 fs/notify/fanotify/fanotify.c                 |    1=20
 fs/pstore/platform.c                          |    3 -
 fs/reiserfs/inode.c                           |   10 ++-
 fs/reiserfs/stree.c                           |    4 +
 fs/reiserfs/super.c                           |   60 +++++++++++++++++----=
--
 fs/ubifs/find.c                               |   12 +++-
 fs/ubifs/lprops.c                             |    6 ++
 fs/ubifs/ubifs.h                              |    3 +
 fs/xfs/xfs_buf.c                              |   14 ++++-
 include/linux/mmzone.h                        |    2=20
 include/linux/ptp_clock_kernel.h              |    3 -
 kernel/module.c                               |   27 ++++++----
 mm/memcontrol.c                               |   67 +++++++++++++++++++--=
-----
 mm/mmzone.c                                   |    6 --
 mm/page_alloc.c                               |    2=20
 mm/shmem.c                                    |   18 +++++-
 mm/vmscan.c                                   |    2=20
 net/bluetooth/mgmt.c                          |   11 ++--
 net/core/dev.c                                |    4 +
 net/core/dev_addr_lists.c                     |    3 -
 net/ipv4/ip_sockglue.c                        |   35 ++++++++-----
 net/ipv4/ip_vti.c                             |    5 +
 net/ipv4/netfilter/nf_nat_standalone.c        |    6 +-
 net/ipv4/tcp.c                                |    4 -
 net/ipv4/tcp_metrics.c                        |   12 +++-
 net/ipv4/tcp_output.c                         |    4 +
 net/ipv6/ipv6_sockglue.c                      |    1=20
 net/mac80211/ieee80211_i.h                    |    2=20
 net/mac80211/sta_info.c                       |   11 +++-
 net/mac80211/status.c                         |    9 +++
 net/mac80211/tx.c                             |    9 ++-
 net/mac80211/util.c                           |    2=20
 net/netfilter/nf_conntrack_h323_main.c        |    3 -
 net/netfilter/xt_TEE.c                        |    1=20
 net/nfc/llcp/llcp.c                           |    4 -
 net/wireless/reg.c                            |    5 -
 security/selinux/netnode.c                    |    3 -
 sound/pci/hda/patch_analog.c                  |    1=20
 sound/pci/hda/patch_cirrus.c                  |   16 +++---
 sound/pci/hda/patch_realtek.c                 |   27 +++++-----
 sound/pci/hda/patch_via.c                     |   25 ++++++---
 sound/soc/codecs/cs42l52.c                    |    3 -
 sound/soc/codecs/wm8978.c                     |    2=20
 sound/soc/soc-core.c                          |    5 +
 sound/soc/soc-dapm.c                          |    2=20
 sound/usb/endpoint.c                          |   13 +++++
 sound/usb/endpoint.h                          |    1=20
 sound/usb/pcm.c                               |    3 +
 96 files changed, 594 insertions(+), 308 deletions(-)

Aaron Lu (1):
      libata-acpi: Fix NULL ptr derference in ata_acpi_dev_handle

Alex Deucher (1):
      drm/radeon: fix logic error in atombios_encoders.c

Alex Williamson (1):
      intel-iommu: Fix lookup in add device

Alexander Stein (1):
      ALSA: hda: Cirrus: Fix coefficient index for beep configuration

Andreas Schwab (1):
      m68k: fix sigset_t accessor functions

Andrew Vagin (1):
      tcp: fix retransmission in repair mode

Arik Nemtsov (1):
      mac80211: sync acccess to tx_filtered/ps_tx_buf queues

Artem Bityutskiy (2):
      UBIFS: fix mounting problems after power cuts
      UBIFS: introduce categorized lprops counter

Benjamin Marzinski (1):
      GFS2: Don't call file_accessed() with a shared glock

Bj=F8rn Mork (1):
      USB: keyspan: fix typo causing GPF on open

Christoph Fritz (1):
      ARM: imx: ehci: fix host power mask bit

Colin Cross (1):
      Revert "Staging: Android alarm: IOCTL command encoding fix"

Colin Ian King (1):
      pstore: Fix NULL pointer dereference in console writes

Cornelia Huck (1):
      virtio: Don't access index after unregister.

Cyril Brulebois (1):
      r8169: Fix WoL on RTL8168d/8111d.

Dan Williams (2):
      USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
      USB: option: add Alcatel X220/X500D USB IDs

Daniel J Blueman (1):
      ALSA: HDA: Fix digital microphone on CS420x

Dave Chinner (1):
      xfs: drop buffer io reference when a bad bio is built

Dave Jones (1):
      selinux: fix sel_netnode_insert() suspicious rcu dereference

Eric Dumazet (2):
      tcp: handle tcp_net_metrics_init() order-5 memory allocation failures
      netfilter: xt_TEE: don't use destination address found in header

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
      Linux 3.6.8

Guenter Roeck (1):
      i2c-mux-pinctrl: Fix probe error path

Hannes Frederic Sowa (1):
      ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT) forgot to set retu=
rn value

Heiko Carstens (1):
      s390/gup: add missing TASK_SIZE check to get_user_pages_fast()

Huang Ying (2):
      PCI/PM: Resume device before shutdown
      PCI/PM: Fix proc config reg access for D3cold and bridge suspending

Hugh Dickins (3):
      tmpfs: fix shmem_getpage_gfp() VM_BUG_ON
      memcg: fix hotplugged memory zone oops
      tmpfs: change final i_blocks BUG to WARNING

Igor Murzov (1):
      ACPI video: Ignore errors after _DOD evaluation.

Jacob Keller (1):
      ptp: update adjfreq callback description

Jan Kara (4):
      reiserfs: Fix lock ordering during remount
      reiserfs: Protect reiserfs_quota_on() with write lock
      reiserfs: Move quota calls out of write lock
      reiserfs: Protect reiserfs_quota_write() with write lock

Jani Nikula (1):
      drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures

Jeff Layton (1):
      cifs: fix potential buffer overrun in cifs.idmap handling code

Jeff Skirvin (1):
      SCSI: isci: Allow SSP tasks into the task management path.

Jiri Pirko (1):
      net: correct check in dev_addr_del()

Johan Hedberg (1):
      Bluetooth: Fix having bogus entries in mgmt_read_index_list reply

Johan Hovold (1):
      USB: usb_wwan: fix bulk-urb allocation

Johannes Berg (3):
      mac80211: don't send null data packet when not associated
      iwlwifi: handle DMA mapping failures
      wireless: allow 40 MHz on world roaming channels 12/13

Julian Anastasov (1):
      netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent d=
ata corruption

Kailang Yang (2):
      ALSA: hda - Improve HP depop when system enter to S3
      ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)

Marek Szyprowski (1):
      regulator: fix voltage check in regulator_is_supported_voltage()

Martin Schwidefsky (1):
      s390/signal: set correct address space control

Michal Hocko (1):
      memcg: oom: fix totalpages calculation for memory.swappiness=3D=3D0

Michal Schmidt (1):
      r8169: use unlimited DMA burst for TX

Misael Lopez Cruz (1):
      ASoC: dapm: Use card_list during DAPM shutdown

Mojiong Qiu (1):
      xen/events: fix RCU warning, or Call idle notifier after irq_enter()

Mukund Navada (1):
      ASoC: core: Double control update err for snd_soc_put_volsw_sx

Nathan Walp (1):
      r8169: allow multicast packets on sub-8168f chipset.

Nicolas Royer (1):
      ARM: at91/AT91SAM9G45: fix crypto peripherals irq issue due to sparse=
 irq support

Paul Gortmaker (1):
      tg3: unconditionally select HWMON support when tg3 is enabled.

Pritesh Raithatha (1):
      ARM: dt: tegra: fix length of pad control and mux registers

Rusty Russell (1):
      module: fix out-by-one error in kallsyms

Sachin Prabhu (1):
      cifs: Do not lookup hashed negative dentry in cifs_atomic_open

Saurabh Mohan (1):
      ipv4/ip_vti.c: VTI fix post-decryption forwarding

Szymon Janc (1):
      NFC: Use dynamic initialization for rwlocks

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning from k=
swapd()

Takashi Iwai (6):
      ALSA: hda - Force to reset IEC958 status bits for AD codecs
      ALSA: hda - Fix empty DAC filling in patch_via.c
      ALSA: hda - Fix invalid connections in VT1802 codec
      ALSA: hda - Add a missing quirk entry for iMac 9,1
      KVM: x86: Fix invalid secondary exec controls in vmx_cpuid_update()
      ALSA: usb-audio: Fix crash at re-preparing the PCM stream

Theodore Ts'o (1):
      ext4: fix metadata checksum calculation for the superblock

Tom Herbert (1):
      net-rps: Fix brokeness causing OOO packets

Ulrich Weber (1):
      netfilter: nf_nat: don't check for port change on ICMP tuples

Wei Yongjun (1):
      ASoC: cs42l52: fix the return value of cs42l52_set_fmt()

Xi Wang (1):
      ipv4: avoid undefined behavior in do_ip_setsockopt()

Zhao Yakui (1):
      ttm: Clear the ttm page allocated from high memory zone correctly


--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQs9BwAAoJEDjbvchgkmk+n/MP/0ftFRL5/6vztY6bp2b6EqjQ
bviYm7RtIxccVwQ9KtRipwofu1k8d+c0l7wawOAsBM8S/VjdbQeZFJh+ea5rl8lY
Zow2yxCZmPWG0qv2VReSoMMtVJvpi4FW1F5bATSpFruBfREfWqvQ7wQlGAf1rPX9
IPWv8LiNR44fFzOFADvT12c+EiSBGM6RNG53IImk5wffof/mHOpgUv7msjG8yf98
UEYFXRstScwpZlzBgsadzZPL96Aztm3rvOeaFMEGzEFThDU2c+YMBPHWkPX2s3Bj
8Axv6CIFSDZPB+xC2yshqtWV41JP/MerooYO1D0/PaWi3qDyL54A9GbvMfIFInKc
xUXls7MQl1LgNhGC0e5M4faLVfnhMNHOEbIygSFfe7TobvDeR2X8Ju8qEmYAGYnK
h3+zAGvOSZxMouPZMmwGEDsDwRwE6Q3a0g/vm1jBbTkPJKBtiXHXhcA/DuG1vTmE
/xx7ygFx8hSaeS2LNfldert2aW0qZo2gXIm/6fOO9SkQ6/qDPE51/Ar7qWwubSgY
ms5sRc1ebb+kGPsD3a12Dk6jTmtaCiCIvmpe9gywTGrfooWsh629HtnHOcY/SGZ8
ucNr4q2Rm26diedG8pjXE46dfy6uS1MaZUbmMd8lPzpBesPOvB/jJwAudLhixLJm
dA5Zu+Gi7uFKfH3hyzk0
=9H1N
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
