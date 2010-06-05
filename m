Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab0FEIx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 04:53:56 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28799 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0FEIxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 04:53:54 -0400
X-RZG-AUTH: :IGUKYFjlcPpA1bcP2iXwpIWQAiKdq4RzISreXUsIKgSQyUatw9HMXziBchD/Kp/bzoxrfF1jZt2KeL1q1w==
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Linux-Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Sat, 05 Jun 2010 10:53:51 +0200
Subject: Kernel freeze with Umts-stick
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Alexander Fischer" <linux-kernel@ordnungsdienst.org>
Message-ID: <op.vdtkb1rtd1ouc6@afr-nb.recommind.com>
User-Agent: Opera Mail/10.53 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


A minute after i establish a connection to the internet with my UMTS data  
stick,
i receive a kernel stack trace and the system freezes.

Hardware is an Globetrotter HSUPA Modem with 7501 Option Chip.
System is: Slackware-13.1 with vanilla kernel 2.6.34


I'd like to give further information, so somebody is able to fix it,
but so far i do not know, what is relevant in that case.

The syslog message is:

Jun  5 09:39:00 darkstar kernel: BUG: scheduling while atomic:  
swapper/0/0x10010100
Jun  5 09:39:00 darkstar kernel: Modules linked in: ppp_deflate bsd_comp  
ppp_async ipv6 ppp_generic slhc usb_storage hso snd_seq_dummy snd_seq_oss  
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm  
sco bridge stp llc bnep l2cap cpufreq_ondemand speedstep_lib acpi_cpufreq  
freq_table lp ppdev parport_pc parport fuse snd_hda_codec_realtek  
rt2860sta(C) rt2800pci rt2800lib snd_hda_intel rt2x00usb rt2x00pci  
snd_hda_codec crc_ccitt rt2x00lib i915 snd_hwdep snd_pcm drm_kms_helper  
snd_timer mac80211 uvcvideo rtc_cmos snd drm cfg80211 eeepc_laptop  
videodev rtc_core intel_agp soundcore btusb i2c_algo_bit agpgart processor  
bluetooth snd_page_alloc video psmouse eeprom_93cx6 v4l1_compat thermal  
atl1e i2c_i801 thermal_sys sparse_keymap rtc_lib sg rfkill battery ac  
serio_raw i2c_core led_class output button evdev hwmon usbhid hid uhci_hcd  
ehci_hcd ext4 jbd2 ext2 mbcache
Jun  5 09:39:00 darkstar kernel: Modules linked in: ppp_deflate bsd_comp  
ppp_async ipv6 ppp_generic slhc usb_storage hso snd_seq_dummy snd_seq_oss  
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm  
sco bridge stp llc bnep l2cap cpufreq_ondemand speedstep_lib acpi_cpufreq  
freq_table lp ppdev parport_pc parport fuse snd_hda_codec_realtek  
rt2860sta(C) rt2800pci rt2800lib snd_hda_intel rt2x00usb rt2x00pci  
snd_hda_codec crc_ccitt rt2x00lib i915 snd_hwdep snd_pcm drm_kms_helper  
snd_timer mac80211 uvcvideo rtc_cmos snd drm cfg80211 eeepc_laptop  
videodev rtc_core intel_agp soundcore btusb i2c_algo_bit agpgart processor  
bluetooth snd_page_alloc video psmouse eeprom_93cx6 v4l1_compat thermal  
atl1e i2c_i801 thermal_sys sparse_keymap rtc_lib sg rfkill battery ac  
serio_raw i2c_core led_class output button evdev hwmon usbhid hid uhci_hcd  
ehci_hcd ext4 jbd2 ext2 mbcache
Jun  5 09:39:00 darkstar kernel:
Jun  5 09:39:00 darkstar kernel: Pid: 0, comm: swapper Tainted: G          
C 2.6.34-smp #1 901/901
Jun  5 09:39:00 darkstar kernel: EIP: 0060:[<c1086ea0>] EFLAGS: 00000246  
CPU: 0
Jun  5 09:39:00 darkstar kernel: EIP is at rcu_bh_qs+0x0/0x30
Jun  5 09:39:00 darkstar kernel: EAX: 00000000 EBX: 00000001 ECX: c1545a18  
EDX: 00000000
Jun  5 09:39:00 darkstar kernel: ESI: 00000018 EDI: 00000006 EBP: c1541ecc  
ESP: c1541e88
Jun  5 09:39:00 darkstar kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS:  
0068
Jun  5 09:39:00 darkstar kernel: Process swapper (pid: 0, ti=c1540000  
task=c156eba0 task.ti=c1540000)
Jun  5 09:39:00 darkstar kernel: Stack:
Jun  5 09:39:00 darkstar kernel:  c1042897 00000001 c1541ec0 c108391c  
c1546700 c1541ec0 c101d41f c1545a18
Jun  5 09:39:00 darkstar kernel: <0> c105dc7d 00000017 0000000a 00000000  
c1622880 00000100 00000046 00000000
Jun  5 09:39:00 darkstar kernel: <0> 00000017 c1541ed8 c10429b5 00000079  
c1541ee0 c1042b25 c1541f0c c13faa35
Jun  5 09:39:00 darkstar kernel: Call Trace:
Jun  5 09:39:00 darkstar kernel:  [<c1042897>] ? __do_softirq+0xb7/0x1a0
Jun  5 09:39:00 darkstar kernel:  [<c108391c>] ?  
handle_IRQ_event+0x4c/0x140
Jun  5 09:39:00 darkstar kernel:  [<c101d41f>] ? ack_apic_level+0x6f/0x200
Jun  5 09:39:00 darkstar kernel:  [<c105dc7d>] ?  
sched_clock_idle_wakeup_event+0x1d/0x30
Jun  5 09:39:00 darkstar kernel:  [<c10429b5>] ? do_softirq+0x35/0x40
Jun  5 09:39:00 darkstar kernel:  [<c1042b25>] ? irq_exit+0x65/0x70
Jun  5 09:39:00 darkstar kernel:  [<c13faa35>] ? do_IRQ+0x55/0xc0
Jun  5 09:39:00 darkstar kernel:  [<c105d944>] ?  
sched_clock_local+0xa4/0x180
Jun  5 09:39:00 darkstar kernel:  [<c10035f0>] ? common_interrupt+0x30/0x38
Jun  5 09:39:00 darkstar kernel:  [<c105007b>] ? sys_prctl+0x1ab/0x2b0
Jun  5 09:39:00 darkstar kernel:  [<f85784c8>] ?  
acpi_idle_enter_simple+0x10a/0x135 [processor]
Jun  5 09:39:00 darkstar kernel:  [<c1327f0a>] ?  
cpuidle_idle_call+0x7a/0xf0
Jun  5 09:39:00 darkstar kernel:  [<c1001d8f>] ? cpu_idle+0x8f/0xd0
Jun  5 09:39:00 darkstar kernel:  [<c13e9057>] ? rest_init+0x67/0x70
Jun  5 09:39:00 darkstar kernel:  [<c15b0932>] ? start_kernel+0x330/0x336
Jun  5 09:39:00 darkstar kernel:  [<c15b042c>] ?  
unknown_bootoption+0x0/0x1a0
Jun  5 09:39:00 darkstar kernel:  [<c15b00d7>] ?  
i386_start_kernel+0xd7/0xdf
Jun  5 09:39:00 darkstar kernel: Code: 44 00 00 ba 20 2b 62 c1 03 14 85 80  
d2 5a c1 8b 42 04 83 e8 01 89 42 08 c6 42 0c 01 5d c3 8d b6 00 00 00 00 8d  
bc 27 00 00 00 00 <55> 89 e5 0f 1f 44 00 00 ba a0 2b 62 c1 03 14 85 80 d2  
5a c1 8b
Jun  5 09:39:00 darkstar kernel: Call Trace:
Jun  5 09:39:00 darkstar kernel:  [<c1042897>] ? __do_softirq+0xb7/0x1a0
Jun  5 09:39:00 darkstar kernel:  [<c108391c>] ?  
handle_IRQ_event+0x4c/0x140
Jun  5 09:39:00 darkstar kernel:  [<c101d41f>] ? ack_apic_level+0x6f/0x200
Jun  5 09:39:00 darkstar kernel:  [<c105dc7d>] ?  
sched_clock_idle_wakeup_event+0x1d/0x30
Jun  5 09:39:00 darkstar kernel:  [<c10429b5>] do_softirq+0x35/0x40
Jun  5 09:39:00 darkstar kernel:  [<c1042b25>] irq_exit+0x65/0x70
Jun  5 09:39:00 darkstar kernel:  [<c13faa35>] do_IRQ+0x55/0xc0
Jun  5 09:39:00 darkstar kernel:  [<c105d944>] ?  
sched_clock_local+0xa4/0x180
Jun  5 09:39:00 darkstar kernel:  [<c10035f0>] common_interrupt+0x30/0x38
Jun  5 09:39:00 darkstar kernel:  [<c105007b>] ? sys_prctl+0x1ab/0x2b0
Jun  5 09:39:00 darkstar kernel:  [<f85784c8>] ?  
acpi_idle_enter_simple+0x10a/0x135 [processor]
Jun  5 09:39:00 darkstar kernel:  [<c1327f0a>] cpuidle_idle_call+0x7a/0xf0
Jun  5 09:39:00 darkstar kernel:  [<c1001d8f>] cpu_idle+0x8f/0xd0
Jun  5 09:39:00 darkstar kernel:  [<c13e9057>] rest_init+0x67/0x70
Jun  5 09:39:00 darkstar kernel:  [<c15b0932>] start_kernel+0x330/0x336
Jun  5 09:39:00 darkstar kernel:  [<c15b042c>] ?  
unknown_bootoption+0x0/0x1a0
Jun  5 09:39:00 darkstar kernel:  [<c15b00d7>] i386_start_kernel+0xd7/0xdf
