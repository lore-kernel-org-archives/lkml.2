Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1BGMPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:15:39 -0500
Received: from nm6-vm1.bullet.mail.ac4.yahoo.com ([98.139.52.71]:39539 "HELO
	nm6-vm1.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753628Ab1BGMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:15:38 -0500
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 187300.98309.bm@omp1055.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=5mwm/hNSAoCGSYGo2pTuwUBpJnnp1cls29eksWM1dLEoz+8sIGgxy8mFiWsPmqMZbmMbPR84O6ZgqIeWeCv38VijlLjvptbNIjrgVfm36CI8XFY66LALWpADAUI4cw9IeVTOKa4AvISio6E2KsiILwCr/AI+oGZz8+qaL1plmD8=;
Message-ID: <75114.47266.qm@web55907.mail.re3.yahoo.com>
X-YMail-OSG: IWQlbnwVM1kcWSrkDsw7joUi4KOfkkHGN7SK8Nn8uA08uxd
 JHYmAsFDeFnAbbvTAAMUf05jTVEWSp3E5Y0S5wBLLvffAyjpQUXmccTOw2nK
 Ry0ZI0hnrKH9iHicA4YTTY_jW6BxQc7ZF3hl0kythkTp.RpzHKB0bsm7HBev
 ktGceC2fB6.VvFaCayEPiCOGrV2mgw.w6_R5HkETKCSJC6fdjpcnkdXjQb7_
 UlYh313MtnAF0yFlPab5MkDMbPNr2TC0k.HJtSdOOS3U.NPCNXgWzev1PFhS
 mIFb0Df8IPsmS92euCrS9LFcpSZLTdaVkHu.F
X-Mailer: YahooMailRC/555 YahooMailWebService/0.8.108.291010
Date: Mon, 7 Feb 2011 04:15:37 -0800 (PST)
From: Eugene Markow <ejmarkow@yahoo.com>
Subject: Unknown hardware: "HDA-Intel" "Intel Cantiga HDMI" bootup warning as of Kernel 2.6.38 +
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following appears during the bootup process from kernels 2.6.38-rc1 to 
2.6.38-rc3-git5 (Does not appear in 2.6.37 stable):


-------------------------------------------
:: Restoring ALSA Levels
Unknown hardware: "HDA-Intel" "Intel Cantiga HDMI" "HDA 
14f15051,103c360b,00100000, HDA:00062802,00060101,00100000" "0x103c" "0x360b"
Hardware is initialized using a guess method
/usr/sbin/alsactl: set_control:1255: failed to obtain info for control #3 (No 
such file or directory)
/usr/sbin/alsactl: set_control:1255: failed to obtain info for control #4 (No 
such file or directory)
-------------------------------------------


Regardless, sound DOES function properly.


System info:

-------------------------------------------
Linux Galicja 2.6.38-rc3-git5-ARCHMOD #1 PREEMPT Mon Feb 7 10:15:08 CET 2011 
x86_64 Genuine Intel(R) CPU 575 @ 2.00GHz GenuineIntel GNU/Linux
 
Gnu C                  4.5.2
Gnu make               3.81
binutils               2.21.0.20101217
util-linux             2.18
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.14
jfsutils               1.1.14
reiserfsprogs          3.6.21
xfsprogs               3.1.4
pcmciautils            017
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Linux C++ Library      6.0.14
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.10
wireless-tools         29
Modules Loaded         ipv6 xt_HL iptable_mangle ipt_REJECT ipt_LOG xt_limit 
xt_tcpudp xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables ntfs joydev 
arc4 snd_hda_codec_hdmi ecb snd_hda_codec_conexant snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device asix usbnet snd_pcm_oss snd_mixer_oss 
snd_hda_intel snd_hda_codec snd_hwdep ath5k snd_pcm ath snd_timer mac80211 
hp_wmi snd sparse_keymap uhci_hcd ehci_hcd cfg80211 coretemp fuse sg soundcore 
snd_page_alloc battery r8169 rfkill psmouse wmi ac evdev thermal processor 
usbcore mii iTCO_wdt iTCO_vendor_support i2c_i801 serio_raw pcspkr i915 
drm_kms_helper drm i2c_algo_bit button i2c_core video intel_agp intel_gtt 
rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sd_mod sr_mod cdrom ahci 
libahci libata scsi_mod
-------------------------------------------

I wish to be personally CC'ed the answers/comments posted to the list in 
response to my posting.

Thanks,

Eugene Markow


      
