Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0EYRBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:01:39 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855Ab0EYRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:01:37 -0400
Subject: Re: iwl3945 dies (oops) in post 2.6.34 kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100525163920.GA2730@core.coreip.homeip.net>
References: <20100525163920.GA2730@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 19:01:56 +0200
Message-ID: <1274806916.18861.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 09:39 -0700, Dmitry Torokhov wrote:
> Hi,
> 
> I am getting the following crashers in iwl3945 after updating to
> post-2.6.34 kernels. This is with the pull from Linus's tree as of last
> night (the taint is from nvidia module):
> 
> [ 3330.630734] general protection fault: 0000 [#1] PREEMPT SMP 
> [ 3330.630752] last sysfs file: /sys/devices/platform/dock.0/docked
> [ 3330.630761] CPU 0 
> [ 3330.630766] Modules linked in: cryptd aes_x86_64 aes_generic fuse rfcomm sco bnep l2cap autofs4
> coretemp hwmon sunrpc ppdev parport_pc parport acpi_cpufreq mperf uinput nvidia(P) snd_hda_codec_idt
> arc4 snd_hda_intel ecb snd_hda_codec snd_hwdep iwl3945 joydev snd_seq snd_seq_device snd_pcm iwlcore
> mac80211 snd_timer cfg80211 snd psmouse iTCO_wdt dell_wmi iTCO_vendor_support serio_raw tg3 battery
> dell_laptop dcdbas soundcore snd_page_alloc btusb bluetooth video pcspkr mac_hid ac wmi libphy
> firewire_ohci i2c_i801 firewire_core yenta_socket crc_itu_t ohci_hcd [last unloaded: microcode]
> [ 3330.630950] 
> [ 3330.630958] Pid: 455, comm: iwl3945 Tainted: P            2.6.35-rc0 #293 0WM416/Latitude D630                   
> [ 3330.630967] RIP: 0010:[<ffffffffa01e70d3>]  [<ffffffffa01e70d3>] iwl3945_get_channels_for_scan+0xe3/0x460 [iwl3945]


http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208

johannes

