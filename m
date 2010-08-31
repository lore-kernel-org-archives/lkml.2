Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0HaUQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:16:22 -0400
Received: from www17.your-server.de ([213.133.104.17]:38457 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab0HaUQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:16:20 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.36-rc3: WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed
Date: Tue, 31 Aug 2010 22:14:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-00001-g02d9a9b; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008312214.52473.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Very rarely I get this warning in my kernel log:

[ 9224.980599] ------------[ cut here ]------------
[ 9224.980622] WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed+0x19e/0x1a0 [mac80211]()
[ 9224.980627] Hardware name: Aspire 1810T
[ 9224.980630] Modules linked in: fuse coretemp hwmon cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi snd_hda_codec_realtek arc4 snd_hda_intel ecb snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer iwlagn snd soundcore iwlcore snd_page_alloc mac80211 iTCO_wdt cfg80211 uvcvideo rfkill iTCO_vendor_support wmi joydev i2c_i801 serio_raw videodev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded:scsi_wait_scan]
[ 9224.980691] Pid: 5676, comm: kworker/u:1 Tainted: G        W I 2.6.36-rc3-00001-g02d9a9b #181
[ 9224.980695] Call Trace:
[ 9224.980704]  [<c042c2a8>] ? warn_slowpath_common+0x78/0xb0
[ 9224.980720]  [<f8c71f6e>] ? ieee80211_scan_completed+0x19e/0x1a0 [mac80211]
[ 9224.980735]  [<f8c71f6e>] ? ieee80211_scan_completed+0x19e/0x1a0 [mac80211]
[ 9224.980744]  [<c042c2fb>] ? warn_slowpath_null+0x1b/0x20
[ 9224.980760]  [<f8c71f6e>] ? ieee80211_scan_completed+0x19e/0x1a0 [mac80211]
[ 9224.980768]  [<c043d3d4>] ? process_one_work+0xf4/0x320
[ 9224.980774]  [<c085433a>] ? schedule+0x1aa/0x4c0
[ 9224.980791]  [<f911a830>] ? iwl_bg_scan_completed+0x0/0x210 [iwlcore]
[ 9224.980799]  [<c043ebd6>] ? worker_thread+0x106/0x330
[ 9224.980806]  [<c043ead0>] ? worker_thread+0x0/0x330
[ 9224.980814]  [<c0441f14>] ? kthread+0x74/0x80
[ 9224.980821]  [<c0441ea0>] ? kthread+0x0/0x80
[ 9224.980828]  [<c04032be>] ? kernel_thread_helper+0x6/0x18
[ 9224.980832] ---[ end trace a7919e7f17c0a728 ]---

Should I be worried?
