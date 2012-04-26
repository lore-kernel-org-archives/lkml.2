Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab2DZQUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:20:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53302 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723Ab2DZQUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:20:48 -0400
Date: Thu, 26 Apr 2012 18:20:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kris Erik Schwerdt <kriserik@quantentunnel.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PROBLEM: cp210x
Message-ID: <20120426162055.GA7458@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kris Erik Schwerdt <kriserik@quantentunnel.de>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <4F997340.3070401@quantentunnel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F997340.3070401@quantentunnel.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leaving in the whole message for linux-usb.

On Thu, Apr 26, 2012 at 06:09:36PM +0200, Kris Erik Schwerdt wrote:
> Dear Sir or Madam,
> 
> I would like to report a bug sice kernel 3.3.1.
> 
> [1.] One line summary of the problem:
> 
> 	The module cp210x causes kernelpanic.
> 
> [2.] Full description of the problem/report:
> 	
> 	By connecting a usb-device with ID 10c4:ea60 to the computer the module
> cp210x causes a recursive fault and the kernel is halted.
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> 	
> 	module: cp210x, usb to serial converter, kernel 3.3.1, kernel 3.3.2,
> kernel 3.3.3
> 
> [4.] Kernel version (from /proc/version):
> 
> 	Linux version 3.3.3-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.0
> 20120414 (prerelease) (GCC) ) #1 SMP PREEMPT Mon Apr 23 09:41:07 CEST 2012
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
> 
> 	it was not possible to save the oops message. but at the and there was
> a line with "recursive fault fixed, but system has to reboot"

Can you make a readable photo of the screen with a digital camera and
post it somewhere?

Or, connect the box to a serial or a firewire console?

If the oops is still whizzing by too fast, try enabling
CONFIG_BOOT_PRINTK_DELAY, see the help text with this option in the
configurator too, for more info.

> 
> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> 
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
> 
> Linux fridolin 3.3.3-1-ARCH #1 SMP PREEMPT Mon Apr 23 09:41:07 CEST 2012
> x86_64 Intel(R) Core(TM) i5 CPU M 520 @ 2.40GHz GenuineIntel GNU/Linux
> 
> Gnu C                  4.7.0
> Gnu make               3.82
> binutils               2.22.0.20120323
> util-linux             2.21.1
> mount                  support
> module-init-tools      8
> e2fsprogs              1.42.2
> jfsutils               1.1.15
> reiserfsprogs          3.6.21
> pcmciautils            018
> PPP                    2.4.5
> Linux C Library        2.15
> Dynamic linker (ldd)   2.15
> Linux C++ Library      so.6.0
> Procps                 3.2.8
> Net-tools              1.60
> Kbd                    1.15.3
> Sh-utils               8.16
> wireless-tools         29
> Modules Loaded         usbhid hid tun snd_usb_audio snd_usbmidi_lib
> snd_rawmidi snd_seq_device nfnetlink_log nfnetlink fuse qcserial
> usb_wwan usbserial uvcvideo videobuf2_vmalloc videobuf2_memops
> videobuf2_core videodev v4l2_compat_ioctl32 media btusb bluetooth
> snd_hda_codec_hdmi vboxdrv nvidia snd_hda_codec_conexant tp_smapi arc4
> thinkpad_ec acpi_cpufreq mperf fan iwlwifi mxm_wmi mac80211 serio_raw
> psmouse pcspkr evdev i2c_i801 cfg80211 battery sdhci_pci thermal
> thinkpad_acpi sdhci nvram ac mmc_core rfkill snd_hda_intel snd_hda_codec
> i2c_core snd_hwdep snd_pcm intel_agp snd_page_alloc intel_gtt snd_timer
> e1000e mei snd iTCO_wdt iTCO_vendor_support soundcore video wmi button
> processor microcode aesni_intel aes_x86_64 cryptd aes_generic intel_ips
> ext4 crc16 jbd2 mbcache sd_mod ahci libahci libata scsi_mod ehci_hcd
> usbcore usb_common uvesafb
> 
> [7.2.] Processor information (from /proc/cpuinfo):
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 37
> model name	: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
> stepping	: 2
> microcode	: 0xd
> cpu MHz		: 2400.000
> cache size	: 3072 KB
> physical id	: 0
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 11
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
> tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts
> tpr_shadow vnmi flexpriority ept vpid
> bogomips	: 4789.11
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> processor	: 1
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 37
> model name	: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
> stepping	: 2
> microcode	: 0xd
> cpu MHz		: 2400.000
> cache size	: 3072 KB
> physical id	: 0
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> apicid		: 1
> initial apicid	: 1
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 11
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
> tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts
> tpr_shadow vnmi flexpriority ept vpid
> bogomips	: 4789.11
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> processor	: 2
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 37
> model name	: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
> stepping	: 2
> microcode	: 0xd
> cpu MHz		: 2400.000
> cache size	: 3072 KB
> physical id	: 0
> siblings	: 4
> core id		: 2
> cpu cores	: 2
> apicid		: 4
> initial apicid	: 4
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 11
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
> tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts
> tpr_shadow vnmi flexpriority ept vpid
> bogomips	: 4789.11
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> processor	: 3
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 37
> model name	: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
> stepping	: 2
> microcode	: 0xd
> cpu MHz		: 2400.000
> cache size	: 3072 KB
> physical id	: 0
> siblings	: 4
> core id		: 2
> cpu cores	: 2
> apicid		: 5
> initial apicid	: 5
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 11
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
> tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts
> tpr_shadow vnmi flexpriority ept vpid
> bogomips	: 4789.11
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> 
> [7.3.] Module information (from /proc/modules):
> 
> usbhid 36142 0 - Live 0xffffffffa0352000
> hid 84549 1 usbhid, Live 0xffffffffa0f7c000
> tun 15241 2 - Live 0xffffffffa0255000
> snd_usb_audio 93519 2 - Live 0xffffffffa0f64000
> snd_usbmidi_lib 18744 1 snd_usb_audio, Live 0xffffffffa0292000
> snd_rawmidi 18991 1 snd_usbmidi_lib, Live 0xffffffffa0272000
> snd_seq_device 5300 1 snd_rawmidi, Live 0xffffffffa0252000
> nfnetlink_log 8037 0 - Live 0xffffffffa01f5000
> nfnetlink 3210 1 nfnetlink_log, Live 0xffffffffa016b000
> fuse 68162 2 - Live 0xffffffffa0f52000
> qcserial 4898 0 - Live 0xffffffffa029b000
> usb_wwan 9366 1 qcserial, Live 0xffffffffa10f8000
> usbserial 32395 2 qcserial,usb_wwan, Live 0xffffffffa10e9000
> uvcvideo 67853 0 - Live 0xffffffffa10d2000
> videobuf2_vmalloc 2276 1 uvcvideo, Live 0xffffffffa0249000
> videobuf2_memops 2182 1 videobuf2_vmalloc, Live 0xffffffffa01c0000
> videobuf2_core 20415 1 uvcvideo, Live 0xffffffffa10c9000
> videodev 83373 1 uvcvideo, Live 0xffffffffa10ab000
> v4l2_compat_ioctl32 8348 1 videodev, Live 0xffffffffa035c000
> media 10469 2 uvcvideo,videodev, Live 0xffffffffa0261000
> btusb 11643 0 - Live 0xffffffffa00df000
> bluetooth 171342 1 btusb, Live 0xffffffffa0fff000
> snd_hda_codec_hdmi 24120 4 - Live 0xffffffffa01b9000
> vboxdrv 1792230 0 - Live 0xffffffffa1c5e000 (O)
> nvidia 12257807 33 - Live 0xffffffffa03a0000 (PO)
> snd_hda_codec_conexant 46856 1 - Live 0xffffffffa0345000
> tp_smapi 20660 0 - Live 0xffffffffa026b000 (O)
> arc4 1410 2 - Live 0xffffffffa0202000
> thinkpad_ec 4285 1 tp_smapi, Live 0xffffffffa024c000 (O)
> acpi_cpufreq 5941 1 - Live 0xffffffffa01ff000
> mperf 1275 1 acpi_cpufreq, Live 0xffffffffa01f3000
> fan 2426 0 - Live 0xffffffffa0081000
> iwlwifi 252526 0 - Live 0xffffffffa0361000
> mxm_wmi 1425 0 - Live 0xffffffffa0189000
> mac80211 391455 1 iwlwifi, Live 0xffffffffa02e4000
> serio_raw 4653 0 - Live 0xffffffffa01e7000
> psmouse 69539 0 - Live 0xffffffffa02d2000
> pcspkr 1835 0 - Live 0xffffffffa00c5000
> evdev 9402 22 - Live 0xffffffffa01ef000
> i2c_i801 8116 0 - Live 0xffffffffa00cd000
> cfg80211 176857 2 iwlwifi,mac80211, Live 0xffffffffa021c000
> battery 6485 0 - Live 0xffffffffa0050000
> sdhci_pci 10535 0 - Live 0xffffffffa02cb000
> thermal 7959 0 - Live 0xffffffffa02c5000
> thinkpad_acpi 62497 0 - Live 0xffffffffa029e000
> sdhci 23662 1 sdhci_pci, Live 0xffffffffa02bb000
> nvram 5906 1 thinkpad_acpi, Live 0xffffffffa0298000
> ac 2376 0 - Live 0xffffffffa003c000
> mmc_core 82671 2 sdhci_pci,sdhci, Live 0xffffffffa0278000
> rfkill 15604 3 bluetooth,cfg80211,thinkpad_acpi, Live 0xffffffffa0266000
> snd_hda_intel 23989 0 - Live 0xffffffffa025a000
> snd_hda_codec 92713 3
> snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel, Live
> 0xffffffffa0204000
> i2c_core 20593 3 videodev,nvidia,i2c_i801, Live 0xffffffffa01f8000
> snd_hwdep 6556 2 snd_usb_audio,snd_hda_codec, Live 0xffffffffa01e0000
> snd_pcm 74812 4
> snd_usb_audio,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
> 0xffffffffa01c8000
> intel_agp 10872 0 - Live 0xffffffffa0182000
> snd_page_alloc 7217 2 snd_hda_intel,snd_pcm, Live 0xffffffffa00d7000
> intel_gtt 14007 1 intel_agp, Live 0xffffffffa0163000
> snd_timer 19222 1 snd_pcm, Live 0xffffffffa01c2000
> e1000e 144866 0 - Live 0xffffffffa0194000
> mei 32216 0 - Live 0xffffffffa018b000 (C)
> snd 59656 16
> snd_usb_audio,snd_usbmidi_lib,snd_rawmidi,snd_seq_device,snd_hda_codec_hdmi,snd_hda_codec_conexant,thinkpad_acpi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
> Live 0xffffffffa0172000
> iTCO_wdt 12877 0 - Live 0xffffffffa01ea000
> iTCO_vendor_support 1929 1 iTCO_wdt, Live 0xffffffffa0042000
> soundcore 6082 1 snd, Live 0xffffffffa01e4000
> video 11243 0 - Live 0xffffffffa01dc000
> wmi 8475 1 mxm_wmi, Live 0xffffffffa016e000
> button 4502 0 - Live 0xffffffffa0168000
> processor 26144 1 acpi_cpufreq, Live 0xffffffffa015b000
> microcode 12217 0 - Live 0xffffffffa00db000
> aesni_intel 49946 0 - Live 0xffffffffa014d000
> aes_x86_64 7508 1 aesni_intel, Live 0xffffffffa007e000
> cryptd 8383 1 aesni_intel, Live 0xffffffffa003e000
> aes_generic 26138 2 aesni_intel,aes_x86_64, Live 0xffffffffa0034000
> intel_ips 11347 0 - Live 0xffffffffa0084000
> ext4 424467 5 - Live 0xffffffffa00e4000
> crc16 1359 2 bluetooth,ext4, Live 0xffffffffa000d000
> jbd2 71704 1 ext4, Live 0xffffffffa00b2000
> mbcache 5977 1 ext4, Live 0xffffffffa0007000
> sd_mod 28059 7 - Live 0xffffffffa0076000
> ahci 20261 5 - Live 0xffffffffa00d1000
> libahci 19999 1 ahci, Live 0xffffffffa00c7000
> libata 167019 2 ahci,libahci, Live 0xffffffffa0088000
> scsi_mod 133422 2 sd_mod,libata, Live 0xffffffffa0054000
> ehci_hcd 43944 0 - Live 0xffffffffa0044000
> usbcore 146847 10
> usbhid,snd_usb_audio,snd_usbmidi_lib,qcserial,usb_wwan,usbserial,uvcvideo,btusb,ehci_hcd,
> Live 0xffffffffa000f000
> usb_common 954 1 usbcore, Live 0xffffffffa000b000
> uvesafb 21439 1 - Live 0xffffffffa0000000
> 
> [7.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):
> [X.] Other notes, patches, fixes, workarounds:
> 
> 
> Thank you





-- 
Regards/Gruss,
Boris.
