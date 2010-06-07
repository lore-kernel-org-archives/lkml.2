Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0FGTOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:14:10 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:42301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab0FGTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:14:08 -0400
Subject: Re: 2.6.35-rc2-git1 - WARNING: at net/wireless/mlme.c:341 
 cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]()
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinmZh9GnrZLzOGi5Q_xHbky8cKdHAkOnsIA6_dZ@mail.gmail.com>
References: <AANLkTinmZh9GnrZLzOGi5Q_xHbky8cKdHAkOnsIA6_dZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 21:14:06 +0200
Message-ID: <1275938046.29978.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 15:06 -0400, Miles Lane wrote:
> [   44.090157] WARNING: at net/wireless/mlme.c:341
> cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]()
> [   44.090162] Hardware name: UL50VT
> [   44.090165] Modules linked in: ipv6 snd_hda_codec_nvhdmi
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_hda_codec_realtek
> snd_rawmidi snd_seq_midi_event snd_hda_intel iwlagn snd_hda_codec
> snd_hwdep snd_seq snd_pcm_oss snd_mixer_oss iwlcore snd_pcm mac80211
> snd_seq_device snd_timer uvcvideo rtc_cmos videodev rtc_core
> v4l1_compat v4l2_compat_ioctl32 snd psmouse cfg80211 rtc_lib atl1c
> snd_page_alloc asus_laptop battery sparse_keymap rfkill ac led_class
> sg sr_mod cdrom sd_mod ehci_hcd uhci_hcd
> [   44.090239] Pid: 3915, comm: phy0 Not tainted 2.6.35-rc2-git1 #8
> [   44.090242] Call Trace:
> [   44.090254]  [<ffffffff8103a482>] warn_slowpath_common+0x80/0x98
> [   44.090261]  [<ffffffff8103a4af>] warn_slowpath_null+0x15/0x17
> [   44.090276]  [<ffffffffa009b583>]
> cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]
> [   44.090296]  [<ffffffffa0115427>] ieee80211_assoc_done+0x71/0xa6 [mac80211]

Yeah, just had another report of this. I thought we'd fixed it, but I
guess not.

Do you happen to have more verbose kernel messages before this?

johannes

