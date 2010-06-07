Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0FGTGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:06:19 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35389 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0FGTGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=e1e6SnpGz5T4+pOesHn57xCtderXA428tKlawhJUvutqOoIk5xBUFCIwwtz92M8Bjq
         r/HNGRxN30SM7KkPB1/ArT1UR04YM3H7RXp+KFSlg6jveKdYVUjb9W33JTW2ZEMzw1ZY
         FXRZwdfldNKNZL08RUSlxFt7yV07FFqYvAXt4=
MIME-Version: 1.0
Date: Mon, 7 Jun 2010 15:06:15 -0400
Message-ID: <AANLkTinmZh9GnrZLzOGi5Q_xHbky8cKdHAkOnsIA6_dZ@mail.gmail.com>
Subject: 2.6.35-rc2-git1 - WARNING: at net/wireless/mlme.c:341 
	cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]()
From: Miles Lane <miles.lane@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   44.090157] WARNING: at net/wireless/mlme.c:341
cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]()
[   44.090162] Hardware name: UL50VT
[   44.090165] Modules linked in: ipv6 snd_hda_codec_nvhdmi
snd_seq_dummy snd_seq_oss snd_seq_midi snd_hda_codec_realtek
snd_rawmidi snd_seq_midi_event snd_hda_intel iwlagn snd_hda_codec
snd_hwdep snd_seq snd_pcm_oss snd_mixer_oss iwlcore snd_pcm mac80211
snd_seq_device snd_timer uvcvideo rtc_cmos videodev rtc_core
v4l1_compat v4l2_compat_ioctl32 snd psmouse cfg80211 rtc_lib atl1c
snd_page_alloc asus_laptop battery sparse_keymap rfkill ac led_class
sg sr_mod cdrom sd_mod ehci_hcd uhci_hcd
[   44.090239] Pid: 3915, comm: phy0 Not tainted 2.6.35-rc2-git1 #8
[   44.090242] Call Trace:
[   44.090254]  [<ffffffff8103a482>] warn_slowpath_common+0x80/0x98
[   44.090261]  [<ffffffff8103a4af>] warn_slowpath_null+0x15/0x17
[   44.090276]  [<ffffffffa009b583>]
cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]
[   44.090296]  [<ffffffffa0115427>] ieee80211_assoc_done+0x71/0xa6 [mac80211]
[   44.090312]  [<ffffffffa0117ad4>] ieee80211_work_work+0xdfa/0xe38 [mac80211]
[   44.090319]  [<ffffffff81050a9a>] ? worker_thread+0x250/0x3a7
[   44.090326]  [<ffffffff81050af1>] worker_thread+0x2a7/0x3a7
[   44.090331]  [<ffffffff81050a9a>] ? worker_thread+0x250/0x3a7
[   44.090347]  [<ffffffffa0116cda>] ? ieee80211_work_work+0x0/0xe38 [mac80211]
[   44.090354]  [<ffffffff81054fc5>] ? autoremove_wake_function+0x0/0x34
[   44.090361]  [<ffffffff8105084a>] ? worker_thread+0x0/0x3a7
[   44.090367]  [<ffffffff81054a82>] kthread+0x89/0x91
[   44.090375]  [<ffffffff81003054>] kernel_thread_helper+0x4/0x10
[   44.090382]  [<ffffffff813ca480>] ? restore_args+0x0/0x30
[   44.090388]  [<ffffffff810549f9>] ? kthread+0x0/0x91
[   44.090394]  [<ffffffff81003050>] ? kernel_thread_helper+0x0/0x10
