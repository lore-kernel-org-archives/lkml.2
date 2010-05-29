Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0E2Neh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:34:37 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38421 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab0E2Nee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:34:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=DXwkYONeYjwvPbbh8/jz+hQiyJQjhTQCMo5uSf6Sote0FrDprIh1g/6ZXQe6aMexXg
         /sLUXGjFTi3/FAergeAE9D0qy7oJn6cmNCdOw2m5KslfuFcvVysqvtvydyMxvNpFGfhr
         EE+BUW/aSANDPzlbdVciCr7KutVmpqmBmeQlY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20100528180952.GC2405@tuxdriver.com>
References: <20100528180952.GC2405@tuxdriver.com>
Date: Sat, 29 May 2010 15:34:31 +0200
Message-ID: <AANLkTil8SLseSeq1M_Xg7P4AqMy3V_0jxc7by2Xuaqnb@mail.gmail.com>
Subject: Re: pull request: wireless-2.6 2010-05-28
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jiajia.zheng@intel.com, Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have pulled wireless-2.6 GIT (master-2010-05-28) into Linus-tree
(2.6.34-git15) [0] and Intel Linux-Wireless Bug #2208 is present.

Two people confirmed the patch in [2] fixes:
1. iwlwifi-2.6 GIT master (commit f10a237c95abd6d64a3a24553bd1d3bcddd9108b)
2. compat-wireless (2010-05-21)

And it fixes also the above mentionned combination.

As a suggestion:
What about "copying" bug-reports (incl. its history) from IWL-BTS into
linux-wireless ML?
For example (dri-devel related) bug-reports from
bugzilla.freedesktop.org are "copied" into dri-devel ML.

Hope [2] gets quickly into wireless-2.6 GIT.

Kind Regards,
- Sedat -

References:
------------------
[0] commit 24010e460454ec0d2f4f0213b667b4349cbdb8e1:
Merge branch 'drm-linus' of git://git./linux/kernel/git/airlied/drm-2.6
[1] http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208
[2] http://bugzilla.intellinuxwireless.org/attachment.cgi?id=2447
[3] http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208#c8
[4] http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208#c9

[  446.893181] BUG: unable to handle kernel NULL pointer dereference at (null)
[  446.893192] IP: [<f8e9eb54>]
iwl3945_get_channels_for_scan+0xb4/0x315 [iwl3945]
[  446.893214] *pde = 00000000
[  446.893220] Oops: 0000 [#1] PREEMPT SMP
[  446.893228] last sysfs file:
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
[  446.893233] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs
reiserfs ext2 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
acpi_cpufreq mperf cpufreq_ondemand cpufreq_stats freq_table
cpufreq_performance cpufreq_conservative cpufreq_powersave sco bridge
stp bnep rfcomm l2cap bluetooth aes_i586 aes_generic ppdev lp
kvm_intel kvm binfmt_misc ipv6 af_packet fuse ext4 jbd2 crc16
snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi arc4 snd_rawmidi ecb snd_seq_midi_event iwl3945 iwlcore
snd_seq snd_timer snd_seq_device sierra usbserial snd parport_pc
mac80211 hp_wmi parport soundcore snd_page_alloc cfg80211 rfkill
joydev pcmcia irda pcspkr intel_agp tifm_7xx1 tifm_core rng_core
iTCO_wdt iTCO_vendor_support hp_accel yenta_socket pcmcia_rsrc
pcmcia_core psmouse evdev tpm_infineon crc_ccitt wmi video output
serio_raw lis3lv02d container battery rtc_cmos tpm_tis tpm rtc_core
tpm_bios rtc_lib input_polldev ac processor button ext3 jbd mbcache
dm_mod usbhid hid sg sr_mod cdrom sd_mod fan pata_acpi ata_generic
sdhci_pci sdhci ata_piix uhci_hcd ahci libahci mmc_core led_class
ehci_hcd tg3 libata thermal scsi_mod usbcore nls_base [last unloaded:
i2c_core]
[  446.893460]
[  446.893466] Pid: 1312, comm: iwl3945 Not tainted
2.6.34-git15.sd.1-iniza-686-kms #1 30AC/HP Compaq nc6400 (RH572EA#ABD)
[  446.893473] EIP: 0060:[<f8e9eb54>] EFLAGS: 00010283 CPU: 0
[  446.893488] EIP is at iwl3945_get_channels_for_scan+0xb4/0x315 [iwl3945]
[  446.893494] EAX: f712a000 EBX: f0548ae0 ECX: 00000000 EDX: 00000000
[  446.893500] ESI: f05c00f2 EDI: 00000058 EBP: 00000000 ESP: f6bc5ecc
[  446.893505]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  446.893511] Process iwl3945 (pid: 1312, ti=f6bc4000 task=f04c79c0
task.ti=f6bc4000)
[  446.893516] Stack:
[  446.893519]  00000067 f04c79ec 00000000 00000000 00000000 00210001
c10272fc c13b0401
[  446.893532] <0> c1225b2d c13b0400 f054f0f0 0002ff00 00000058
00000021 0057f0f0 f0548ae0
[  446.893546] <0> 00000000 00000005 f05c0000 f8ea1cc1 00000000
f05c00f2 00000000 c1071393
[  446.893561] Call Trace:
[  446.893572]  [<c10272fc>] ? add_preempt_count+0x8f/0x91
[  446.893581]  [<c1225b2d>] ? _raw_spin_lock_irqsave+0x1c/0x35
[  446.893598]  [<f8ea1cc1>] ? iwl3945_request_scan+0x697/0x799 [iwl3945]
[  446.893607]  [<c1071393>] ? perf_event_task_sched_in+0xe/0x71
[  446.893614]  [<c1225cf8>] ? _raw_spin_unlock_irq+0x1e/0x28
[  446.893631]  [<f8e62768>] ? iwl_bg_start_internal_scan+0x280/0x299 [iwlcore]
[  446.893639]  [<c103c530>] ? run_workqueue+0x65/0xe1
[  446.893654]  [<f8e624e8>] ? iwl_bg_start_internal_scan+0x0/0x299 [iwlcore]
[  446.893661]  [<c103c65b>] ? worker_thread+0xaf/0xbb
[  446.893669]  [<c103f22a>] ? autoremove_wake_function+0x0/0x29
[  446.893676]  [<c103c5ac>] ? worker_thread+0x0/0xbb
[  446.893683]  [<c103ef3f>] ? kthread+0x5f/0x64
[  446.893690]  [<c103eee0>] ? kthread+0x0/0x64
[  446.893698]  [<c10033b6>] ? kernel_thread_helper+0x6/0x10
[  446.893702] Code: 88 44 24 1c 83 e8 02 88 44 24 2d 8d 4f ff 0f b7
c7 89 44 24 30 66 89 4c 24 3a e9 ea 01 00 00 8b 54 24 10 8b 4c 24 08
8b 6c 90 20 <39> 4d 00 0f 85 d1 01 00 00 66 8b 4d 06 89 d8 88 4e 01 8b
54 24
[  446.893784] EIP: [<f8e9eb54>]
iwl3945_get_channels_for_scan+0xb4/0x315 [iwl3945] SS:ESP
0068:f6bc5ecc
[  446.893801] CR2: 0000000000000000
[  446.893812] ---[ end trace 7a6cdfd823c4f035 ]---


On Fri, May 28, 2010 at 8:09 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Dave,
>
> Here are a few small fixes intended for 2.6.35.  Included are a null
> pointer dereference fix, and a use-after-free fix, as well as some more
> minor stuff.  It also include the revert of a earlier patch that I
> inadvertantly merged out of order, effectively creating a bug rather
> than fixing one.  The reverted patch will now be pointed at 2.6.36
> instead.
>
> Please let me know if there are problems!
>
> Thanks,
>
> John
>
> ---
>
> The following changes since commit 045de01a174d9f0734f657eb4b3313d89b4fd5ad:
>  Scott Feldman (1):
>        netlink: bug fix: wrong size was calculated for vfinfo list blob
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master
>
> Christian Lamparter (1):
>      ar9170usb: fix read from freed driver context
>
> Christoph Fritz (1):
>      ssb: fix NULL ptr deref when pcihost_wrapper is used
>
> Johannes Berg (1):
>      mac80211: make a function static
>
> John W. Linville (1):
>      Revert "rt2x00: Fix rt2800usb TX descriptor writing."
>
> Justin P. Mattock (1):
>      ath9k: Fix ath_print in xmit for hardware reset.
>
> Prarit Bhargava (1):
>      libertas: fix uninitialized variable warning
>
> Vasanthakumar Thiagarajan (1):
>      ath9k: Fix bug in the way "bf_tx_aborted" of struct ath_buf is used
>
>  drivers/net/wireless/ath/ar9170/usb.c   |   14 ++++++++++++--
>  drivers/net/wireless/ath/ath9k/xmit.c   |    6 ++++--
>  drivers/net/wireless/libertas/rx.c      |    5 ++---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>  drivers/ssb/pci.c                       |    9 ++++++---
>  drivers/ssb/sprom.c                     |    1 +
>  net/mac80211/chan.c                     |    2 +-
>  7 files changed, 27 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
> index 82ab532..a93dc18 100644
> --- a/drivers/net/wireless/ath/ar9170/usb.c
> +++ b/drivers/net/wireless/ath/ar9170/usb.c
> @@ -739,17 +739,27 @@ err_out:
>  static void ar9170_usb_firmware_failed(struct ar9170_usb *aru)
>  {
>        struct device *parent = aru->udev->dev.parent;
> +       struct usb_device *udev;
> +
> +       /*
> +        * Store a copy of the usb_device pointer locally.
> +        * This is because device_release_driver initiates
> +        * ar9170_usb_disconnect, which in turn frees our
> +        * driver context (aru).
> +        */
> +       udev = aru->udev;
>
>        complete(&aru->firmware_loading_complete);
>
>        /* unbind anything failed */
>        if (parent)
>                device_lock(parent);
> -       device_release_driver(&aru->udev->dev);
> +
> +       device_release_driver(&udev->dev);
>        if (parent)
>                device_unlock(parent);
>
> -       usb_put_dev(aru->udev);
> +       usb_put_dev(udev);
>  }
>
>  static void ar9170_usb_firmware_finish(const struct firmware *fw, void *context)
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3db1917..859aa4a 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>                int r;
>
>                ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to stop TxDMA. Reset HAL!\n");
> +                         "Failed to stop TX DMA. Resetting hardware!\n");
>
>                spin_lock_bh(&sc->sc_resetlock);
>                r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
> @@ -1728,6 +1728,8 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
>        } else
>                bf->bf_isnullfunc = false;
>
> +       bf->bf_tx_aborted = false;
> +
>        return 0;
>  }
>
> @@ -1989,7 +1991,7 @@ static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
>        int nbad = 0;
>        int isaggr = 0;
>
> -       if (bf->bf_tx_aborted)
> +       if (bf->bf_lastbf->bf_tx_aborted)
>                return 0;
>
>        isaggr = bf_isaggr(bf);
> diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
> index a115bfa..7a377f5 100644
> --- a/drivers/net/wireless/libertas/rx.c
> +++ b/drivers/net/wireless/libertas/rx.c
> @@ -329,9 +329,8 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
>        /* create the exported radio header */
>
>        /* radiotap header */
> -       radiotap_hdr.hdr.it_version = 0;
> -       /* XXX must check this value for pad */
> -       radiotap_hdr.hdr.it_pad = 0;
> +       memset(&radiotap_hdr, 0, sizeof(radiotap_hdr));
> +       /* XXX must check radiotap_hdr.hdr.it_pad for pad */
>        radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
>        radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
>        radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 6991613..0f8b84b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -413,7 +413,7 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>         */
>        rt2x00_desc_read(txi, 0, &word);
>        rt2x00_set_field32(&word, TXINFO_W0_USB_DMA_TX_PKT_LEN,
> -                          skb->len - TXINFO_DESC_SIZE);
> +                          skb->len + TXWI_DESC_SIZE);
>        rt2x00_set_field32(&word, TXINFO_W0_WIV,
>                           !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
>        rt2x00_set_field32(&word, TXINFO_W0_QSEL, 2);
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 989e275..6dcda86 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -625,9 +625,12 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
>                ssb_printk(KERN_ERR PFX "No SPROM available!\n");
>                return -ENODEV;
>        }
> -
> -       bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
> -               SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
> +       if (bus->chipco.dev) {  /* can be unavailible! */
> +               bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
> +                       SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
> +       } else {
> +               bus->sprom_offset = SSB_SPROM_BASE1;
> +       }
>
>        buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
>        if (!buf)
> diff --git a/drivers/ssb/sprom.c b/drivers/ssb/sprom.c
> index 007bc3a..4f7cc8d 100644
> --- a/drivers/ssb/sprom.c
> +++ b/drivers/ssb/sprom.c
> @@ -185,6 +185,7 @@ bool ssb_is_sprom_available(struct ssb_bus *bus)
>        /* this routine differs from specs as we do not access SPROM directly
>           on PCMCIA */
>        if (bus->bustype == SSB_BUSTYPE_PCI &&
> +           bus->chipco.dev &&  /* can be unavailible! */
>            bus->chipco.dev->id.revision >= 31)
>                return bus->chipco.capabilities & SSB_CHIPCO_CAP_SPROM;
>
> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index 5d218c5..32be11e 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -5,7 +5,7 @@
>  #include <linux/nl80211.h>
>  #include "ieee80211_i.h"
>
> -enum ieee80211_chan_mode
> +static enum ieee80211_chan_mode
>  __ieee80211_get_channel_mode(struct ieee80211_local *local,
>                             struct ieee80211_sub_if_data *ignore)
>  {
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
