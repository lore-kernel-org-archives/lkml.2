Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2ITNwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:52:47 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4989 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2ITNwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:52:45 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <505B1FA0.6030100@broadcom.com>
Date: Thu, 20 Sep 2012 15:52:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-Version: 1.0
To: "Nico Schottelius" <nico-kernel20120920@schottelius.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Out of memory on 3.5 kernels
X-WSS-ID: 7C45C0A13PS1011649-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Nico

 > just while running, I got the following brcmsmac related error:
 >
 > [17336.572558] WARNING: at 
drivers/net/wireless/brcm80211/brcmsmac/main.c:7968 
brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
 > [17336.572562] Hardware name: MacBookAir4,2
 > [17336.572565] Modules linked in: sha256_generic snd_hda_codec_hdmi 
snd_hda_codec_cirrus ext4 jbd2 mbcache arc4 uvcvideo brcmsmac 
videobuf2_vmalloc videobuf2_memops cordic brcmutil btusb bluetooth i915 
videobuf2_core mac80211 videodev crc16 acpi_cpufreq snd_hda_intel media 
i2c_algo_bit cfg80211 mperf drm_kms_helper snd_hda_codec rfkill joydev 
bcm5974 iTCO_wdt iTCO_vendor_support i2c_i801 intel_agp lpc_ich applesmc 
evdev microcode drm coretemp input_polldev pcspkr intel_gtt mfd_core 
i2c_core processor bcma snd_hwdep video button battery apple_bl mei ac 
snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore 
kvm_intel kvm nfs nfs_acl lockd auth_rpcgss sunrpc fscache autofs4 jfs 
xts gf128mul dm_crypt dm_mod sd_mod pata_acpi ata_generic hid_generic 
usb_storage hid_apple usbhid hid uhci_hcd aesni_intel aes_x86_64 
aes_generic ghash_clmulni_intel cryptd crc32c_intel ata_piix libata 
scsi_mod ehci_hcd usbcore usb_common
 > [17336.572716] Pid: 27714, comm: kworker/u:1 Not tainted 3.5.4-1-ARCH #1
 > [17336.572719] Call Trace:
 > [17336.572734]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0
 > [17336.572743]  [<ffffffff81051a9a>] warn_slowpath_null+0x1a/0x20
 > [17336.572759]  [<ffffffffa063bd29>] 
brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]
 > [17336.572769]  [<ffffffffa062e1bb>] brcms_ops_flush+0x3b/0x60 [brcmsmac]

This issue is bugging me for quite a while and some patch do patch up 
the issue, but it is still bleeding. Nasty one to get to the root cause 
of it, but I am testing my pitbull mentality on it ;-)

Gr. AvS

