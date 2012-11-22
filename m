Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab2KVWEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:04:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:49646 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab2KVSkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/83] 3.6.8-stable review
Date: Wed, 21 Nov 2012 16:41:22 -0800
Message-Id: <20121122004212.371862690@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.6.8 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Nov 24 00:41:25 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.6.8-rc1

Theodore Ts'o <tytso@mit.edu>
    ext4: fix metadata checksum calculation for the superblock

Felipe Balbi <balbi@ti.com>
    Revert "serial: omap: fix software flow control"

Igor Murzov <e-mail@date.by>
    ACPI video: Ignore errors after _DOD evaluation.

Dave Jones <davej@redhat.com>
    selinux: fix sel_netnode_insert() suspicious rcu dereference

Alex Williamson <alex.williamson@redhat.com>
    intel-iommu: Fix lookup in add device

Jan Kara <jack@suse.cz>
    reiserfs: Protect reiserfs_quota_write() with write lock

Jan Kara <jack@suse.cz>
    reiserfs: Move quota calls out of write lock

Jan Kara <jack@suse.cz>
    reiserfs: Protect reiserfs_quota_on() with write lock

Jan Kara <jack@suse.cz>
    reiserfs: Fix lock ordering during remount

Szymon Janc <szymon.janc@tieto.com>
    NFC: Use dynamic initialization for rwlocks

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/signal: set correct address space control

Julian Anastasov <ja@ssi.bg>
    netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper

Eric Dumazet <eric.dumazet@gmail.com>
    netfilter: xt_TEE: don't use destination address found in header

Ulrich Weber <ulrich.weber@sophos.com>
    netfilter: nf_nat: don't check for port change on ICMP tuples

Nathan Walp <faceprint@faceprint.com>
    r8169: allow multicast packets on sub-8168f chipset.

Cyril Brulebois <kibi@debian.org>
    r8169: Fix WoL on RTL8168d/8111d.

Paul Gortmaker <paul.gortmaker@windriver.com>
    tg3: unconditionally select HWMON support when tg3 is enabled.

Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    SCSI: isci: Allow SSP tasks into the task management path.

Mojiong Qiu <qiumojiong@gmail.com>
    xen/events: fix RCU warning, or Call idle notifier after irq_enter()

Michal Schmidt <mschmidt@redhat.com>
    r8169: use unlimited DMA burst for TX

Benjamin Marzinski <bmarzins@redhat.com>
    GFS2: Don't call file_accessed() with a shared glock

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix crash at re-preparing the PCM stream

Hugh Dickins <hughd@google.com>
    tmpfs: change final i_blocks BUG to WARNING

Eric Dumazet <eric.dumazet@gmail.com>
    tcp: handle tcp_net_metrics_init() order-5 memory allocation failures

Andrew Vagin <avagin@openvz.org>
    tcp: fix retransmission in repair mode

Tom Herbert <therbert@google.com>
    net-rps: Fix brokeness causing OOO packets

Jiri Pirko <jiri@resnulli.us>
    net: correct check in dev_addr_del()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT) forgot to set return value

Saurabh Mohan <saurabh.mohan@vyatta.com>
    ipv4/ip_vti.c: VTI fix post-decryption forwarding

Xi Wang <xi.wang@gmail.com>
    ipv4: avoid undefined behavior in do_ip_setsockopt()

Andreas Schwab <schwab@linux-m68k.org>
    m68k: fix sigset_t accessor functions

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix having bogus entries in mgmt_read_index_list reply

Johannes Berg <johannes.berg@intel.com>
    wireless: allow 40 MHz on world roaming channels 12/13

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: handle DMA mapping failures

Hugh Dickins <hughd@google.com>
    memcg: fix hotplugged memory zone oops

Michal Hocko <mhocko@suse.cz>
    memcg: oom: fix totalpages calculation for memory.swappiness==0

Zhao Yakui <yakui.zhao@intel.com>
    ttm: Clear the ttm page allocated from high memory zone correctly

Takashi Iwai <tiwai@suse.de>
    KVM: x86: Fix invalid secondary exec controls in vmx_cpuid_update()

Hugh Dickins <hughd@google.com>
    tmpfs: fix shmem_getpage_gfp() VM_BUG_ON

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix logic error in atombios_encoders.c

Jani Nikula <jani.nikula@intel.com>
    drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures

Dan Williams <dcbw@redhat.com>
    USB: option: add Alcatel X220/X500D USB IDs

Dan Williams <dcbw@redhat.com>
    USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs

Johan Hovold <jhovold@gmail.com>
    USB: usb_wwan: fix bulk-urb allocation

Bjørn Mork <bjorn@mork.no>
    USB: keyspan: fix typo causing GPF on open

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/gup: add missing TASK_SIZE check to get_user_pages_fast()

Colin Cross <ccross@android.com>
    Revert "Staging: Android alarm: IOCTL command encoding fix"

Pritesh Raithatha <praithatha@nvidia.com>
    ARM: dt: tegra: fix length of pad control and mux registers

Christoph Fritz <chf.fritz@googlemail.com>
    ARM: imx: ehci: fix host power mask bit

Guenter Roeck <linux@roeck-us.net>
    i2c-mux-pinctrl: Fix probe error path

Marek Szyprowski <m.szyprowski@samsung.com>
    regulator: fix voltage check in regulator_is_supported_voltage()

Colin Ian King <colin.king@canonical.com>
    pstore: Fix NULL pointer dereference in console writes

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: introduce categorized lprops counter

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: fix mounting problems after power cuts

Mukund Navada <navada@ti.com>
    ASoC: core: Double control update err for snd_soc_put_volsw_sx

Misael Lopez Cruz <misael.lopez@ti.com>
    ASoC: dapm: Use card_list during DAPM shutdown

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    ASoC: cs42l52: fix the return value of cs42l52_set_fmt()

Eric Millbrandt <emillbrandt@dekaresearch.com>
    ASoC: wm8978: pll incorrectly configured when codec is master

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a missing quirk entry for iMac 9,1

Kailang Yang <kailang@realtek.com>
    ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)

Kailang Yang <kailang@realtek.com>
    ALSA: hda - Improve HP depop when system enter to S3

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix invalid connections in VT1802 codec

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix empty DAC filling in patch_via.c

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Force to reset IEC958 status bits for AD codecs

Daniel J Blueman <daniel@quora.org>
    ALSA: HDA: Fix digital microphone on CS420x

Alexander Stein <alexander.stein@systec-electronic.com>
    ALSA: hda: Cirrus: Fix coefficient index for beep configuration

Jacob Keller <jacob.e.keller@intel.com>
    ptp: update adjfreq callback description

Nicolas Royer <nicolas@eukrea.com>
    ARM: at91/AT91SAM9G45: fix crypto peripherals irq issue due to sparse irq support

Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption

Sachin Prabhu <sprabhu@redhat.com>
    cifs: Do not lookup hashed negative dentry in cifs_atomic_open

Jeff Layton <jlayton@redhat.com>
    cifs: fix potential buffer overrun in cifs.idmap handling code

Cornelia Huck <cornelia.huck@de.ibm.com>
    virtio: Don't access index after unregister.

Rusty Russell <rusty@rustcorp.com.au>
    module: fix out-by-one error in kallsyms

Eric Paris <eparis@redhat.com>
    fanotify: fix missing break

Huang Ying <ying.huang@intel.com>
    PCI/PM: Fix proc config reg access for D3cold and bridge suspending

Huang Ying <ying.huang@intel.com>
    PCI/PM: Resume device before shutdown

Huang Ying <ying.huang@intel.com>
    PCI/PM: Fix deadlock when unbinding device if parent in D3cold

Felix Fietkau <nbd@openwrt.org>
    mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't send null data packet when not associated

Arik Nemtsov <arik@wizery.com>
    mac80211: sync acccess to tx_filtered/ps_tx_buf queues

Dave Chinner <dchinner@redhat.com>
    xfs: drop buffer io reference when a bad bio is built

Aaron Lu <aaron.lu@intel.com>
    libata-acpi: Fix NULL ptr derference in ata_acpi_dev_handle

Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
    mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()


-------------

Diffstat:

 Documentation/cgroups/memory.txt              |  4 +++
 Makefile                                      |  4 +--
 arch/arm/boot/dts/tegra30.dtsi                |  4 +--
 arch/arm/mach-at91/at91sam9g45_devices.c      | 12 ++++----
 arch/arm/mach-imx/ehci-imx25.c                |  2 +-
 arch/arm/mach-imx/ehci-imx35.c                |  2 +-
 arch/arm/plat-omap/include/plat/omap-serial.h |  4 +--
 arch/m68k/include/asm/signal.h                |  6 ++--
 arch/s390/include/asm/compat.h                |  2 +-
 arch/s390/include/asm/ptrace.h                |  4 +--
 arch/s390/kernel/compat_signal.c              | 14 +++++++--
 arch/s390/kernel/signal.c                     | 14 +++++++--
 arch/s390/mm/gup.c                            |  2 +-
 arch/x86/kvm/vmx.c                            | 11 ++++---
 crypto/cryptd.c                               | 11 +++++--
 drivers/acpi/video.c                          | 11 ++++---
 drivers/ata/libata-acpi.c                     | 11 +++++--
 drivers/gpu/drm/i915/intel_sdvo.c             | 22 ++++++++++++--
 drivers/gpu/drm/radeon/atombios_encoders.c    |  2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c          |  5 ++-
 drivers/i2c/muxes/i2c-mux-pinctrl.c           |  2 +-
 drivers/iommu/intel-iommu.c                   |  4 +--
 drivers/net/ethernet/broadcom/Kconfig         |  1 +
 drivers/net/ethernet/broadcom/tg3.c           |  9 ------
 drivers/net/ethernet/realtek/r8169.c          |  7 ++++-
 drivers/net/wireless/iwlwifi/pcie/rx.c        | 23 ++++++++++++--
 drivers/pci/bus.c                             |  3 --
 drivers/pci/pci-driver.c                      | 12 ++------
 drivers/pci/pci-sysfs.c                       | 34 ---------------------
 drivers/pci/pci.c                             | 32 ++++++++++++++++++++
 drivers/pci/pci.h                             |  2 ++
 drivers/pci/pcie/aer/aerdrv_core.c            | 20 +++++++++---
 drivers/pci/proc.c                            |  8 +++++
 drivers/regulator/core.c                      |  2 +-
 drivers/scsi/isci/host.c                      | 10 +++---
 drivers/staging/android/android_alarm.h       |  4 +--
 drivers/tty/serial/omap-serial.c              | 12 ++++----
 drivers/usb/serial/keyspan.c                  |  3 +-
 drivers/usb/serial/option.c                   |  9 ++++++
 drivers/usb/serial/usb_wwan.c                 | 10 +++---
 drivers/virtio/virtio.c                       |  4 ++-
 drivers/xen/events.c                          |  2 +-
 fs/cifs/cifsacl.c                             | 49 ++++++++++++------------------
 fs/cifs/dir.c                                 | 11 ++++++-
 fs/ext4/ext4.h                                |  3 +-
 fs/ext4/ext4_jbd2.c                           |  8 ++---
 fs/ext4/resize.c                              |  2 +-
 fs/ext4/super.c                               |  7 +++--
 fs/gfs2/file.c                                | 12 +++-----
 fs/gfs2/super.c                               |  3 +-
 fs/notify/fanotify/fanotify.c                 |  1 +
 fs/pstore/platform.c                          |  3 +-
 fs/reiserfs/inode.c                           | 10 ++++--
 fs/reiserfs/stree.c                           |  4 +++
 fs/reiserfs/super.c                           | 60 +++++++++++++++++++++++++++---------
 fs/ubifs/find.c                               | 12 ++++++--
 fs/ubifs/lprops.c                             |  6 ++++
 fs/ubifs/ubifs.h                              |  3 ++
 fs/xfs/xfs_buf.c                              | 14 +++++++--
 include/linux/mmzone.h                        |  2 +-
 include/linux/ptp_clock_kernel.h              |  3 +-
 kernel/module.c                               | 27 ++++++++++-------
 mm/memcontrol.c                               | 67 ++++++++++++++++++++++++++++++-----------
 mm/mmzone.c                                   |  6 +---
 mm/page_alloc.c                               |  2 +-
 mm/shmem.c                                    | 18 +++++++++--
 mm/vmscan.c                                   |  2 ++
 net/bluetooth/mgmt.c                          | 11 ++++---
 net/core/dev.c                                |  4 ++-
 net/core/dev_addr_lists.c                     |  3 +-
 net/ipv4/ip_sockglue.c                        | 35 +++++++++++++--------
 net/ipv4/ip_vti.c                             |  5 +++
 net/ipv4/netfilter/nf_nat_standalone.c        |  6 ++--
 net/ipv4/tcp.c                                |  4 +--
 net/ipv4/tcp_metrics.c                        | 12 ++++++--
 net/ipv4/tcp_output.c                         |  4 +++
 net/ipv6/ipv6_sockglue.c                      |  1 +
 net/mac80211/ieee80211_i.h                    |  2 ++
 net/mac80211/sta_info.c                       | 11 +++++--
 net/mac80211/status.c                         |  9 ++++++
 net/mac80211/tx.c                             |  9 ++++--
 net/mac80211/util.c                           |  2 ++
 net/netfilter/nf_conntrack_h323_main.c        |  3 +-
 net/netfilter/xt_TEE.c                        |  1 +
 net/nfc/llcp/llcp.c                           |  4 +--
 net/wireless/reg.c                            |  5 ++-
 security/selinux/netnode.c                    |  3 +-
 sound/pci/hda/patch_analog.c                  |  1 +
 sound/pci/hda/patch_cirrus.c                  | 16 ++++++----
 sound/pci/hda/patch_realtek.c                 | 27 +++++++++--------
 sound/pci/hda/patch_via.c                     | 25 ++++++++++-----
 sound/soc/codecs/cs42l52.c                    |  3 +-
 sound/soc/codecs/wm8978.c                     |  2 +-
 sound/soc/soc-core.c                          |  5 +--
 sound/soc/soc-dapm.c                          |  2 +-
 sound/usb/endpoint.c                          | 13 ++++++++
 sound/usb/endpoint.h                          |  1 +
 sound/usb/pcm.c                               |  3 ++
 98 files changed, 611 insertions(+), 316 deletions(-)


