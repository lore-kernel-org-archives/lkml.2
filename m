Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0KHT4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:56:10 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52905 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab0KHT4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=MZWq1P00QWY7nqTpOUrxJKAqvfQlG8OUJXVqYBECc0/DFjF8ozHtRofOJz756bBmtQ
         z+oQI3NvyG5epN+HJ51ueTgAvaUTLZkfM+Zr6JsVcYR3nZdF/wuF2LvCf3lKjFt1uWfE
         ahe0R8iAR65uIenwxonc+lwAm+uOFkwvz7Lto=
MIME-Version: 1.0
Date: Mon, 8 Nov 2010 14:56:06 -0500
Message-ID: <AANLkTinVyf4CpxdzEWUn7zTyOrAMKY3H9Dct-HfopiSD@mail.gmail.com>
Subject: 2.6.37-rc1-git5 -- WARNING: at net/ipv4/devinet.c:137 in_dev_finish_destroy+0x3d/0x6e()
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: at net/ipv4/devinet.c:137 in_dev_finish_destroy+0x3d/0x6e()
Hardware name: UL50VT
Modules linked in: ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_pcm_oss snd_hwdep snd_mixer_oss
snd_seq_dummy snd_pcm snd_seq_oss snd_seq_midi iwlagn snd_rawmidi
snd_seq_midi_event snd_seq iwlcore uvcvideo snd_timer mac80211
snd_seq_device videodev v4l1_compat v4l2_compat_ioctl32 i915 snd
rtc_cmos rtc_core psmouse cfg80211 soundcore drm_kms_helper
snd_page_alloc rtc_lib asus_laptop video battery ac sparse_keymap wmi
button rfkill processor power_supply led_class usb_storage sg sr_mod
sd_mod cdrom atl1c ehci_hcd uhci_hcd thermal thermal_sys hwmon
Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-rc1-git5 #10
Call Trace:
 <IRQ>  [<ffffffff8103767e>] warn_slowpath_common+0x80/0x98
 [<ffffffff810376ab>] warn_slowpath_null+0x15/0x17
 [<ffffffff8130d549>] in_dev_finish_destroy+0x3d/0x6e
 [<ffffffff8130d58e>] in_dev_put+0x14/0x16
 [<ffffffff8130d5ab>] inet_rcu_free_ifa+0x1b/0x27
 [<ffffffff810834a8>] __rcu_process_callbacks+0x1a4/0x2bc
 [<ffffffff8108363b>] rcu_process_callbacks+0x7b/0x82
 [<ffffffff8103cb9c>] __do_softirq+0xb8/0x15a
 [<ffffffff8100394c>] call_softirq+0x1c/0x28
 [<ffffffff81005637>] do_softirq+0x38/0x81
 [<ffffffff8103cce9>] irq_exit+0x45/0x94
 [<ffffffff8101ac1f>] smp_apic_timer_interrupt+0x78/0x86
 [<ffffffff81003413>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff8134aff6>] ? _raw_spin_unlock_irqrestore+0x3c/0x69
 [<ffffffff81059cb3>] clockevents_notify+0x11e/0x12d
 [<ffffffffa008e561>] ? acpi_idle_enter_bm+0x236/0x271 [processor]
 [<ffffffffa008dfce>] lapic_timer_state_broadcast+0x41/0x43 [processor]
 [<ffffffffa008e588>] acpi_idle_enter_bm+0x25d/0x271 [processor]
 [<ffffffff8129db30>] cpuidle_idle_call+0x9e/0xda
 [<ffffffff810012ea>] cpu_idle+0xce/0x10c
 [<ffffffff81343ce8>] start_secondary+0x1fc/0x205
---[ end trace 1d49bc8ff0266634 ]---
Freeing alive in_device ffff88013fe536d0
