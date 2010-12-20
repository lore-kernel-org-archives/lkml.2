Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0LTJ6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:58:09 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:39882 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab0LTJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:58:07 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2010 04:58:07 EST
Date: Mon, 20 Dec 2010 10:49:48 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/sched.c:4131 schedule+0xa01/0xa20()
Message-ID: <20101220094948.GA3964@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.osknowledge.org/~marc/pubkey.asc
X-Operating-System: Linux marc 2.6.37-rc6-dezzy-01908-g55ec86f
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following popped up in my dmesg today:

[ 1512.587294] ------------[ cut here ]------------
[ 1512.587309] WARNING: at kernel/sched.c:4131 schedule+0xa01/0xa20()
[ 1512.587312] Hardware name: 43495KG
[ 1512.587314] Modules linked in: sdhci mmc_core uhci_hcd ehci_hcd fuse snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss cdc_acm btusb bluetooth hdaps tp_smapi thinkpad_ec vboxnetadp vboxnetflt vboxdrv usb_storage usblp usbmon tun display cpufreq_userspace coretemp acpi_cpufreq mperf hed sbs sbshc fan qcserial usb_wwan uvcvideo videodev v4l1_compat usbserial iwlagn sr_mod cdrom snd_hda_codec_conexant iwlcore snd_hda_intel snd_hda_codec snd_hwdep mac80211 snd_pcm thinkpad_acpi snd_timer e1000e cfg80211 snd_page_alloc wmi i2c_i801 joydev intel_ips battery processor button ac thermal [last unloaded: mmc_core]
[ 1512.587385] Pid: 6725, comm: kworker/1:2 Not tainted 2.6.37-rc6-dezzy-01908-g55ec86f #1
[ 1512.587388] Call Trace:
[ 1512.587395]  [<c13dc371>] ? printk+0x18/0x1f
[ 1512.587405]  [<c103252d>] warn_slowpath_common+0x6d/0xa0
[ 1512.587410]  [<c13dd061>] ? schedule+0xa01/0xa20
[ 1512.587415]  [<c13dd061>] ? schedule+0xa01/0xa20
[ 1512.587421]  [<c103257d>] warn_slowpath_null+0x1d/0x20
[ 1512.587426]  [<c13dd061>] schedule+0xa01/0xa20
[ 1512.587432]  [<c103d546>] ? lock_timer_base.clone.23+0x26/0x50
[ 1512.587438]  [<c103d96d>] ? mod_timer+0xfd/0x1e0
[ 1512.587445]  [<c104595b>] ? queue_delayed_work+0x1b/0x30
[ 1512.587450]  [<c1045981>] ? schedule_delayed_work+0x11/0x20
[ 1512.587455]  [<c1045f4a>] ? process_one_work+0x14a/0x2e0
[ 1512.587460]  [<c103d96d>] ? mod_timer+0xfd/0x1e0
[ 1512.587465]  [<c1044820>] ? wq_barrier_func+0x0/0x10
[ 1512.587472]  [<c1097ad0>] ? vmstat_update+0x0/0x30
[ 1512.587477]  [<c10467bf>] worker_thread+0x1df/0x2c0
[ 1512.587482]  [<c10465e0>] ? worker_thread+0x0/0x2c0
[ 1512.587487]  [<c104a3e4>] kthread+0x74/0x80
[ 1512.587492]  [<c104a370>] ? kthread+0x0/0x80
[ 1512.587497]  [<c10032b6>] kernel_thread_helper+0x6/0x10
[ 1512.587501] ---[ end trace 14341092e363cd55 ]---

Regards,
	Marc

-- 
Marc Koschewski
