Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1LVOfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:35:41 -0500
Received: from icf.org.ru ([91.193.236.10]:53135 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab1LVOfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:35:39 -0500
Date: Thu, 22 Dec 2011 18:00:25 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
In-Reply-To: <1324525237.5916.114.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.02.1112221759480.6601@icf.org.ru>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-375915274-1324562425=:6601"
X-Daemon-Classification: INNOCENT
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Dec 22 18:00:25 2011
X-DSPAM-Confidence: 0.9996
X-DSPAM-Improbability: 1 in 274308 chance of being spa
X-DSPAM-Probability: 0.0000(0)
X-DSPAM-Signature: 4ef337f921163537818587
X-DSPAM-Factors: 27,
	*MAILER-DAEMON+Thu, 0.00010,
	*From+#+Thu, 0.00010,
	*From+MAILER-DAEMON, 0.00010,
	ru+#+#+#+org, 0.00010,
	*From+#+#+Dec, 0.00011,
	*MAILER-DAEMON+#+Dec, 0.00011,
	*MAILER-DAEMON+#+#+#+18, 0.00014,
	ath9k+hw, 0.00014,
	linux+kernel, 0.00015,
	I'm+#+to, 0.00016,
	linux+#+#+#+linux, 0.00016,
	org+#+#+#+icf, 0.00017,
	IT+Service, 0.00017,
	Service+Ltd, 0.00018,
	IT+#+Ltd, 0.00019,
	C+#+#+#+Regards, 0.00019,
	C+#+#+Best, 0.00019,
	C+#+With, 0.00019,
	4872+#+#+#+4872, 0.00020,
	4872+#+#+#+4872, 0.00020,
	new+#+#+0, 0.00020,
	fax+#+4872, 0.00021,
	net+#+#+#+core, 0.00021,
	4872+#+#+7, 0.00021,
	4872+#+#+7, 0.00021,
	The+#+#+#+be, 0.00021,
	On+2011, 0.00022
X-Bounce-ID: icf.org.ru
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-375915274-1324562425=:6601
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2011-12-21 22:40 -0500, Steven Rostedt wrote LKML and RT:


there is steel a bug in acpi:

[  251.152035] BUG: scheduling while atomic: irq/9-acpi/14/0x00000002
[  251.152038] Modules linked in: xt_TCPMSS xt_tcpudp iptable_mangle ip_tables x_tables ipv6 pci_slot pktcdvd tcp_cubic microcode fuse hso pata_pcmcia firewire_net firewire_ohci firewire_core crc_itu_t tcp_hybla cdc_acm usbmouse usb_storage usb_libusual usbhid uhci_hcd ohci_hcd ehci_hcd usbcore snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi snd_seq_device cpufreq_userspace acpi_cpufreq mperf msr cpuid nvram arc4 joydev snd_intel8x0m mousedev 8250_pci 8250_pnp snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer psmouse snd_page_alloc serio_raw pcmcia radeon ttm drm_kms_helper drm backlight i2c_algo_bit ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 i2c_core cfbcopyarea cfbimgblt rfkill cfbfillrect processor pcspkr battery ac intel_agp intel_gtt agpgart yenta_socket pcmcia_rsrc pcmcia_core button power_supply 8250 serial_core evdev raid0 btrfs crc32c libcrc32c sr_mod cdrom atkbd thermal thermal_sys hwmon 8139too [last unloaded: scsi_wait_scan]
[  251.152105] Pid: 14, comm: irq/9-acpi Not tainted 3.0.14-rt31-r235 #1
[  251.152108] Call Trace:
[  251.152112]  [<792d784d>] ? 0x792d784d
[  251.152114]  [<79022284>] ? 0x79022284
[  251.152116]  [<79020547>] ? 0x79020547
[  251.152117]  [<7902253e>] ? 0x7902253e
[  251.152119]  [<79022e59>] ? 0x79022e59
[  251.152121]  [<792d7a4f>] ? 0x792d7a4f
[  251.152123]  [<792d8a55>] ? 0x792d8a55
[  251.152125]  [<79020bfc>] ? 0x79020bfc
[  251.152127]  [<7918d60c>] ? 0x7918d60c
[  251.152128]  [<79196f09>] ? 0x79196f09
[  251.152130]  [<7919e374>] ? 0x7919e374
[  251.152132]  [<791971ab>] ? 0x791971ab
[  251.152134]  [<79195c33>] ? 0x79195c33
[  251.152136]  [<79188cb7>] ? 0x79188cb7
[  251.152137]  [<7905dab0>] ? 0x7905dab0
[  251.152139]  [<7905d92d>] ? 0x7905d92d
[  251.152141]  [<7905da90>] ? 0x7905da90
[  251.152143]  [<7905d810>] ? 0x7905d810
[  251.152144]  [<7903eb24>] ? 0x7903eb24
[  251.152146]  [<7903eab0>] ? 0x7903eab0
[  251.152148]  [<792d9e3e>] ? 0x792d9e3e

SR>
SR>Dear RT Folks,
SR>
SR>I'm pleased to announce the 3.0.14-rt31 stable release.
SR>
SR>
SR>This release is just an update to the new stable 3.0.14 version
SR>and no RT specific changes have been made.
SR>
SR>
SR>You can get this release via the git tree at:
SR>
SR>  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
SR>
SR>  Head SHA1: 6aaac97b2b5e0750a2739c3a247d79d4fadac43e
SR>
SR>
SR>Or to build 3.0.14-rt31 directly, the following patches should be applied:
SR>
SR>  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz
SR>
SR>  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.14.xz
SR>
SR>  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.14-rt31.patch.xz
SR>
SR>
SR>The broken out patches are available at:
SR>
SR>  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patches-3.0.14-rt31.tar.xz
SR>
SR>Enjoy,
SR>
SR>-- Steve
SR>
SR>
SR>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-375915274-1324562425=:6601--
