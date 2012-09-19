Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab2ISUbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:31:50 -0400
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:40203 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751584Ab2ISUbq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:31:46 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 16:31:46 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 511503.70858.bm@omp1068.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=iVCptCUImpvLcvmwgoq08v8JthijX/kZ8fnC7msLf2KK8/mlXwt8+p2G2ByT6jaimMuuZi7wRbEXxwx1r/PSdcyohS9fJVvLxUAybz8S3wYcRCfPomqMNUkF7G+bVrl4EVftjUj0eWA9vV8BPPZ9ZddzZ0yNhpz7RXmDEDJxzsE=;
X-YMail-OSG: 6qF9dRwVM1kByxls6GLxe._S.sZgI8b7ok6xWHfTpg47fdM
 3lCZRfvQu1nDMi1lH1k4wbZnz3Y5gW20DOarStpZNhmA1argg8UoRBvGuDiX
 Q4C3jduLvwdf70OIKzzZOmp8Rv_QKELjM4uRCOaetJ4jXZQO2jb9e6z7lRgJ
 HhDpURcNj3vB_tyLWCQUDHwu77QVe4hxJhOsa9fCkCQ7F3lgLl0J.TrYGj6i
 2zU8ouM2U8oBqARMno5mzn752an9wdTl0GX67xf0vG..22NX2Xk1vikfjPZ3
 2F.crhEWqUcNfFVJ6fJMyy6dknyhihNWM._NkS836NgXH7qrtt1hUpEon95E
 tuuS1UcWfcCSXumUBZMH7pIhq.EvcNBVNTArgZ8eg73ukavCkViP0hIAp50o
 J34_O3WhHoXqoKs0dXOlxFiD5_JMEqAndvVyfTc0Dp0jIXxbhXudYrjbpRTn
 sdxhJrelmg_EHqsVuyNRgMsImPhQufBAAddPLevrdVXMypRaxJqWBGIQGMLL
 zNNhrL45WvVk-
X-Mailer: YahooMailWebService/0.8.121.416
Message-ID: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>
Date: Wed, 19 Sep 2012 13:25:05 -0700 (PDT)
From: Kevin Cruz <skate_ops@yahoo.com>
Reply-To: Kevin Cruz <skate_ops@yahoo.com>
Subject: iwlwifi can't connect to router after resuming from suspend.
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#iwlwifi can't connect to router after resuming from suspend.#

I'm not subscribed to the mailing list so the FAQ said I need to be CC'd the
responses. I don't know how to find out who are the maintainers suspend or
iwlwifi modules, so that's why I'm sending this here. I'm pretty new to the
world of Linux, so please excuse my limited knowledge in this area.

Any ways here's my problem: wireless doesn't work after suspend.  I've
searched all over the web and haven't been able to find a fix that worked.
At first I thought it was Ubuntu 12.04's fault until I tried the live
disc's of OpenSUSE 12.2 and Sabayan 10 (which uses kernel 3.5). All of them
had the issue. That leads me to believe the bug is either in the kernel or
driver.

Here's what happens:  I start up my computer and log-in into my account,
everything is working fine.  When I'm in the middle of something but need
to leave for a while and will be back soon, I suspend my computer.  When I
return, resume and log back in, the WiFi icon shows that it attempts to re-
connect.  After a while of waiting, a window pops up asking for my network
password:

> **Authentication Required by wireless network**

> Passwords or encryption keys are required to access the wireless network
> 'Network\_Name'

The password is already filled correctly.  If I hit enter it still doesn't
work.  Even though I cannot connect,  I can still see all the networks in
my area.

In Ubuntu 11.10 I use to be able to fix the problem with [this][1] which
shows me how to reload my wireless driver by typing this in the terminal:

    sudo rmmod iwlwifi
    sudo modprobe iwlwifi

This hasn't worked in in Ubuntu 12.04.1 or in any of the other OS's I've
tried.  I've also done this to the cfg80211 and mac80211 modules (iwlwifi
uses these) but it didn't fix anyghing.  So I'm not sure if its iwlwifi or
not that's causing the problem.

  [1]: http://askubuntu.com/a/67852/58063

Another thing I tried was:

    sudo service network-manager restart

and that didn't fix it.

I'm hoping I can get this fixed soon. I'd love to make my default OS a
Linux one, but I got to be able to suspend and I got to be able to use the
Internet.  I'd appreciate any help I can get on fixing this.

Thank you guys for your work on a great kernel and drivers!

##Kernel Version:##
Linux version 3.2.0-30-generic (buildd@batsu) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #48-Ubuntu SMP Fri Aug 24 16:52:48 UTC 2012

##Environment##
###Software###
ver\_linux:

    If some fields are empty or look unusual you may have an old version.
    Compare to the current minimal requirements in Documentation/Changes.
     
    Linux cyber-ubuntu 3.2.0-30-generic #48-Ubuntu SMP Fri Aug 24 16:52:48 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
     
    Gnu C                  4.6
    Gnu make               3.81
    binutils               2.22
    util-linux             2.20.1
    mount                  support
    module-init-tools      3.16
    e2fsprogs              1.42
    pcmciautils            018
    PPP                    2.4.5
    Linux C Library        2.15
    Dynamic linker (ldd)   2.15
    Procps                 3.2.8
    Net-tools              1.60
    Kbd                    1.15.2
    Sh-utils               8.13
    wireless-tools         30
    Modules Loaded         rfcomm parport_pc ppdev bnep bluetooth snd_hda_codec_hdmi snd_hda_codec_idt joydev arc4 hp_wmi sparse_keymap fglrx snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer hp_accel wmi lis3lv02d snd_seq_device input_polldev iwlwifi mac_hid snd mac80211 uvcvideo i915 psmouse videodev v4l2_compat_ioctl32 serio_raw rts_pstor drm_kms_helper cfg80211 drm soundcore lp mei i2c_algo_bit snd_page_alloc parport video sdhci_pci sdhci r8169

###Processor Information###
cpuinfo:

    processor    : 0
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 42
    model name    : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
    stepping    : 7
    microcode    : 0x25
    cpu MHz        : 800.000
    cache size    : 6144 KB
    physical id    : 0
    siblings    : 8
    core id        : 0
    cpu cores    : 4
    apicid        : 0
    initial apicid    : 0
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 13
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 4390.33
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 36 bits physical, 48 bits virtual
    power management:

    processor    : 1
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 42
    model name    : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
    stepping    : 7
    microcode    : 0x25
    cpu MHz        : 800.000
    cache size    : 6144 KB
    physical id    : 0
    siblings    : 8
    core id        : 0
    cpu cores    : 4
    apicid        : 1
    initial apicid    : 1
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 13
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 4389.82
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 36 bits physical, 48 bits virtual
    power management:

    processor    : 2
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 42
    model name    : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
    stepping    : 7
    microcode    : 0x25
    cpu MHz        : 800.000
    cache size    : 6144 KB
    physical id    : 0
    siblings    : 8
    core id        : 1
    cpu cores    : 4
    apicid        : 2
    initial apicid    : 2
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 13
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 4389.83
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 36 bits physical, 48 bits virtual
    power management:

    processor    : 3
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 42
    model name    : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
    stepping    : 7
    microcode    : 0x25
    cpu MHz        : 800.000
    cache size    : 6144 KB
    physical id    : 0
    siblings    : 8
    core id        : 1
    cpu cores    : 4
    apicid        : 3
    initial apicid    : 3
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 13
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 4389.83
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 36 bits physical, 48 bits virtual
    power management:

    processor    : 4
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 42
    model name    : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
    stepping    : 7
    microcode    : 0x25
    cpu MHz        : 800.000
    cache size    : 6144 KB
    physical id    : 0
    siblings    : 8
    core id        : 2
    cpu cores    : 4
    apicid        : 4
    initial apicid    : 4
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 13
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 4389.83
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 36 bits physical, 48 bits virtual
    power management:

    processor    : 5
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 42
    model name    : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
    stepping    : 7
    microcode    : 0x25
    cpu MHz        : 800.000
    cache size    : 6144 KB
    physical id    : 0
    siblings    : 8
    core id        : 2
    cpu cores    : 4
    apicid        : 5
    initial apicid    : 5
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 13
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 4389.82
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 36 bits physical, 48 bits virtual
    power management:

    processor    : 6
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 42
    model name    : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
    stepping    : 7
    microcode    : 0x25
    cpu MHz        : 800.000
    cache size    : 6144 KB
    physical id    : 0
    siblings    : 8
    core id        : 3
    cpu cores    : 4
    apicid        : 6
    initial apicid    : 6
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 13
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 4389.83
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 36 bits physical, 48 bits virtual
    power management:

    processor    : 7
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 42
    model name    : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
    stepping    : 7
    microcode    : 0x25
    cpu MHz        : 800.000
    cache size    : 6144 KB
    physical id    : 0
    siblings    : 8
    core id        : 3
    cpu cores    : 4
    apicid        : 7
    initial apicid    : 7
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 13
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 4389.83
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 36 bits physical, 48 bits virtual
    power management:

###Module information###
modules:

    rfcomm 47604 0 - Live 0x0000000000000000
    parport_pc 32866 0 - Live 0x0000000000000000
    ppdev 17113 0 - Live 0x0000000000000000
    bnep 18281 2 - Live 0x0000000000000000
    bluetooth 180104 10 rfcomm,bnep, Live 0x0000000000000000
    snd_hda_codec_hdmi 32474 1 - Live 0x0000000000000000
    snd_hda_codec_idt 70795 1 - Live 0x0000000000000000
    joydev 17693 0 - Live 0x0000000000000000
    arc4 12529 2 - Live 0x0000000000000000
    hp_wmi 18092 0 - Live 0x0000000000000000
    sparse_keymap 13890 1 hp_wmi, Live 0x0000000000000000
    fglrx 3263886 0 - Live 0x0000000000000000 (P)
    snd_hda_intel 33773 3 - Live 0x0000000000000000
    snd_hda_codec 127706 3 snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel, Live 0x0000000000000000
    snd_hwdep 13668 1 snd_hda_codec, Live 0x0000000000000000
    snd_pcm 97188 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0x0000000000000000
    snd_seq_midi 13324 0 - Live 0x0000000000000000
    snd_rawmidi 30748 1 snd_seq_midi, Live 0x0000000000000000
    snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
    snd_seq 61896 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
    snd_timer 29990 2 snd_pcm,snd_seq, Live 0x0000000000000000
    hp_accel 25976 0 - Live 0x0000000000000000
    wmi 19256 1 hp_wmi, Live 0x0000000000000000
    lis3lv02d 19876 1 hp_accel, Live 0x0000000000000000
    snd_seq_device 14540 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
    input_polldev 13896 1 lis3lv02d, Live 0x0000000000000000
    iwlwifi 332525 0 - Live 0x0000000000000000
    mac_hid 13253 0 - Live 0x0000000000000000
    snd 78855 16 snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0x0000000000000000
    mac80211 506816 1 iwlwifi, Live 0x0000000000000000
    uvcvideo 72627 0 - Live 0x0000000000000000
    i915 473035 2 - Live 0x0000000000000000
    psmouse 87692 0 - Live 0x0000000000000000
    videodev 98259 1 uvcvideo, Live 0x0000000000000000
    v4l2_compat_ioctl32 17128 1 videodev, Live 0x0000000000000000
    serio_raw 13211 0 - Live 0x0000000000000000
    rts_pstor 445196 0 - Live 0x0000000000000000 (C)
    drm_kms_helper 46978 1 i915, Live 0x0000000000000000
    cfg80211 205544 2 iwlwifi,mac80211, Live 0x0000000000000000
    drm 242038 3 i915,drm_kms_helper, Live 0x0000000000000000
    soundcore 15091 1 snd, Live 0x0000000000000000
    lp 17799 0 - Live 0x0000000000000000
    mei 41616 0 - Live 0x0000000000000000 (C)
    i2c_algo_bit 13423 1 i915, Live 0x0000000000000000
    snd_page_alloc 18529 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
    parport 46562 3 parport_pc,ppdev,lp, Live 0x0000000000000000
    video 19596 1 i915, Live 0x0000000000000000
    sdhci_pci 18826 0 - Live 0x0000000000000000
    sdhci 33205 1 sdhci_pci, Live 0x0000000000000000
    r8169 62099 0 - Live 0x0000000000000000

###Loaded driver and hardware information###
ioports:

    0000-0cf7 : PCI Bus 0000:00
      0000-001f : dma1
      0020-0021 : pic1
      0040-0043 : timer0
      0050-0053 : timer1
      0060-0060 : keyboard
      0062-0062 : EC data
      0064-0064 : keyboard
      0066-0066 : EC cmd
      0070-0077 : rtc0
      0080-008f : dma page reg
      00a0-00a1 : pic2
      00c0-00df : dma2
      00f0-00ff : fpu
      0400-0453 : pnp 00:05
        0400-0403 : ACPI PM1a_EVT_BLK
        0404-0405 : ACPI PM1a_CNT_BLK
        0408-040b : ACPI PM_TMR
        0410-0415 : ACPI CPU throttle
        0420-042f : ACPI GPE0_BLK
        0450-0450 : ACPI PM2_CNT_BLK
      0454-0457 : pnp 00:07
      0458-047f : pnp 00:05
      0500-057f : pnp 00:05
      0680-069f : pnp 00:05
    0cf8-0cff : PCI conf1
    0d00-ffff : PCI Bus 0000:00
      1000-100f : pnp 00:05
      1010-1013 : pnp 00:05
      164e-164f : pnp 00:05
      2000-2fff : PCI Bus 0000:13
      3000-3fff : PCI Bus 0000:0d
      4000-4fff : PCI Bus 0000:07
        4000-40ff : 0000:07:00.0
          4000-40ff : r8169
      5000-5fff : PCI Bus 0000:01
        5000-50ff : 0000:01:00.0
      6000-603f : 0000:00:02.0
      6040-605f : 0000:00:1f.3
      6060-607f : 0000:00:1f.2
        6060-607f : ahci
      6080-6087 : 0000:00:1f.2
        6080-6087 : ahci
      6088-608f : 0000:00:1f.2
        6088-608f : ahci
      6098-609b : 0000:00:1f.2
        6098-609b : ahci
      609c-609f : 0000:00:1f.2
        609c-609f : ahci
      ffff-ffff : pnp 00:05

iomem:

    00000000-0000ffff : reserved
    00010000-0009d7ff : System RAM
    0009d800-0009ffff : reserved
    000a0000-000bffff : PCI Bus 0000:00
    000c0000-000cf1ff : Video ROM
    000e0000-000fffff : reserved
      000f0000-000fffff : System ROM
    00100000-9ce3efff : System RAM
      01000000-0166794b : Kernel code
      0166794c-01ce437f : Kernel data
      01dd3000-01f28fff : Kernel bss
    9ce3f000-9cebefff : reserved
    9cebf000-9cfbefff : ACPI Non-volatile Storage
    9cfbf000-9cffefff : ACPI Tables
    9cfff000-9cffffff : System RAM
    9d000000-9f9fffff : reserved
    9fa00000-feafffff : PCI Bus 0000:00
      9fa00000-9fa00fff : pnp 00:0a
      a0000000-afffffff : PCI Bus 0000:01
        a0000000-afffffff : 0000:01:00.0
      b0000000-bfffffff : 0000:00:02.0
      c0000000-c03fffff : 0000:00:02.0
      c0400000-c13fffff : PCI Bus 0000:07
        c0400000-c0403fff : 0000:07:00.0
          c0400000-c0403fff : r8169
        c0404000-c0404fff : 0000:07:00.0
          c0404000-c0404fff : r8169
      c1400000-c23fffff : PCI Bus 0000:0d
      c2400000-c33fffff : PCI Bus 0000:13
        c2400000-c240ffff : 0000:13:00.0
      c3400000-c34fffff : PCI Bus 0000:19
        c3400000-c3401fff : 0000:19:00.0
          c3400000-c3401fff : xhci_hcd
      c3500000-c44fffff : PCI Bus 0000:13
        c3500000-c35000ff : 0000:13:00.1
          c3500000-c35000ff : mmc0
        c3501000-c3501fff : 0000:13:00.0
          c3501000-c3501fff : rts_pstor
      c4500000-c54fffff : PCI Bus 0000:0d
        c4500000-c4501fff : 0000:0d:00.0
          c4500000-c4501fff : iwlwifi
      c5500000-c64fffff : PCI Bus 0000:07
      c6500000-c74fffff : PCI Bus 0000:01
        c6500000-c651ffff : 0000:01:00.0
        c6520000-c653ffff : 0000:01:00.0
      c7500000-c7503fff : 0000:00:1b.0
        c7500000-c7503fff : ICH HD audio
      c7504000-c750400f : 0000:00:16.0
        c7504000-c750400f : mei
      c7506000-c75060ff : 0000:00:1f.3
      c7508000-c75087ff : 0000:00:1f.2
        c7508000-c75087ff : ahci
      c7509000-c75093ff : 0000:00:1d.0
        c7509000-c75093ff : ehci_hcd
      c750a000-c750a3ff : 0000:00:1a.0
        c750a000-c750a3ff : ehci_hcd
      e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
        e0000000-efffffff : reserved
          e0000000-efffffff : pnp 00:0a
    feb00000-feb03fff : reserved
    fec00000-fec00fff : reserved
      fec00000-fec003ff : IOAPIC 0
    fed00000-fed003ff : HPET 0
    fed10000-fed19fff : reserved
      fed10000-fed17fff : pnp 00:0a
      fed18000-fed18fff : pnp 00:0a
      fed19000-fed19fff : pnp 00:0a
    fed1c000-fed1ffff : reserved
      fed1c000-fed1ffff : pnp 00:0a
    fed20000-fed3ffff : pnp 00:0a
    fed90000-fed93fff : pnp 00:0a
    fee00000-fee00fff : Local APIC

###PCI information###
lspci -vvv:

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: agpgart-intel

    00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=06, sec-latency=0
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: c6500000-c74fffff
        Prefetchable memory behind bridge: 00000000a0000000-00000000afffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
            PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [88] Subsystem: Hewlett-Packard Company Device 1656
        Capabilities: [80] Power Management version 3
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
            Address: feeff00c  Data: 4169
        Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                ExtTag- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 128 bytes
            DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
            LnkCap:    Port #2, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <256ns, L1 <4us
                ClockPM- Surprise- LLActRep- BwNot+
            LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
            SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
            SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
            SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                Changed: MRL- PresDet+ LinkState-
            RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
            RootCap: CRSVisible-
            RootSta: PME ReqID 0000, PMEStatus- PMEPending-
            DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
            LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [100 v1] Virtual Channel
            Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
            Arb:    Fixed- WRR32- WRR64- WRR128-
            Ctrl:    ArbSelect=Fixed
            Status:    InProgress-
            VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                Status:    NegoPending- InProgress-
        Capabilities: [140 v1] Root Complex Link
            Desc:    PortNumber=02 ComponentID=01 EltType=Config
            Link0:    Desc:    TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
                Addr:    00000000fed19000
        Kernel driver in use: pcieport
        Kernel modules: shpchp

    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 53
        Region 0: Memory at c0000000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 6000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
            Address: feec000c  Data: 4122
        Capabilities: [d0] Power Management version 2
            Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
            AFCap: TP+ FLR+
            AFCtrl: FLR-
            AFStatus: TP-
        Kernel driver in use: i915
        Kernel modules: i915

    00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 51
        Region 0: Memory at c7504000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
            Address: 00000000feeff00c  Data: 415a
        Kernel driver in use: mei
        Kernel modules: mei

    00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at c750a000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
            AFCap: TP+ FLR+
            AFCtrl: FLR-
            AFStatus: TP-
        Kernel driver in use: ehci_hcd

    00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 54
        Region 0: Memory at c7500000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
            Address: 00000000feeff00c  Data: 4162
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                ExtTag- RBE- FLReset+
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 128 bytes
            DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
            LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                ClockPM- Surprise- LLActRep- BwNot-
            LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
            Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
            Arb:    Fixed- WRR32- WRR64- WRR128-
            Ctrl:    ArbSelect=Fixed
            Status:    InProgress-
            VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                Status:    NegoPending- InProgress-
            VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                Ctrl:    Enable+ ID=1 ArbSelect=Fixed TC/VC=22
                Status:    NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
            Desc:    PortNumber=0f ComponentID=00 EltType=Config
            Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
                Addr:    00000000fed1c000
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd-hda-intel

    00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=07, subordinate=0c, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: c5500000-c64fffff
        Prefetchable memory behind bridge: 00000000c0400000-00000000c13fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
            PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                ExtTag- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 128 bytes
            DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
            LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                ClockPM- Surprise- LLActRep+ BwNot-
            LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
            SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
            SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
                Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
            SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                Changed: MRL- PresDet- LinkState-
            RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
            RootCap: CRSVisible-
            RootSta: PME ReqID 0000, PMEStatus- PMEPending-
            DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
            LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
            Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 1656
        Capabilities: [a0] Power Management version 2
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

    00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=0d, subordinate=12, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: c4500000-c54fffff
        Prefetchable memory behind bridge: 00000000c1400000-00000000c23fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
            PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                ExtTag- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 128 bytes
            DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
            LnkCap:    Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                ClockPM- Surprise- LLActRep+ BwNot-
            LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
            SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
            SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
                Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
            SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                Changed: MRL- PresDet- LinkState-
            RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
            RootCap: CRSVisible-
            RootSta: PME ReqID 0000, PMEStatus- PMEPending-
            DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
            LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
            Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 1656
        Capabilities: [a0] Power Management version 2
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

    00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=13, subordinate=18, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: c3500000-c44fffff
        Prefetchable memory behind bridge: 00000000c2400000-00000000c33fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
            PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                ExtTag- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 128 bytes
            DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
            LnkCap:    Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                ClockPM- Surprise- LLActRep+ BwNot-
            LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
            SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
            SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
                Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
            SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                Changed: MRL- PresDet- LinkState-
            RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
            RootCap: CRSVisible-
            RootSta: PME ReqID 0000, PMEStatus- PMEPending-
            DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
            LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
            Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 1656
        Capabilities: [a0] Power Management version 2
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

    00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=19, subordinate=19, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: c3400000-c34fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
            PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                ExtTag- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 128 bytes
            DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
            LnkCap:    Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                ClockPM- Surprise- LLActRep+ BwNot-
            LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
            SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
            SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
            SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                Changed: MRL- PresDet- LinkState-
            RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
            RootCap: CRSVisible-
            RootSta: PME ReqID 0000, PMEStatus- PMEPending-
            DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+ ARIFwd-
            LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
            Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 1656
        Capabilities: [a0] Power Management version 2
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

    00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at c7509000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
            AFCap: TP+ FLR+
            AFCtrl: FLR-
            AFStatus: TP-
        Kernel driver in use: ehci_hcd

    00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Controller (rev 05)
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel modules: iTCO_wdt

    00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 41
        Region 0: I/O ports at 6088 [size=8]
        Region 1: I/O ports at 609c [size=4]
        Region 2: I/O ports at 6080 [size=8]
        Region 3: I/O ports at 6098 [size=4]
        Region 4: I/O ports at 6060 [size=32]
        Region 5: Memory at c7508000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
            Address: fee0100c  Data: 4171
        Capabilities: [70] Power Management version 3
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
            Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
        Capabilities: [b0] PCI Advanced Features
            AFCap: TP+ FLR+
            AFCtrl: FLR-
            AFStatus: TP-
        Kernel driver in use: ahci

    00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 10
        Region 0: Memory at c7506000 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 6040 [size=32]
        Kernel modules: i2c-i801

    01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Seymour [Radeon HD 6400M Series] (prog-if 00 [VGA controller])
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at a0000000 (64-bit, prefetchable) [size=256M]
        Region 2: Memory at c6500000 (64-bit, non-prefetchable) [size=128K]
        Region 4: I/O ports at 5000 [size=256]
        Expansion ROM at c6520000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 3
            Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
            DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
                ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                MaxPayload 128 bytes, MaxReadReq 512 bytes
            DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
            LnkCap:    Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
                ClockPM- Surprise- LLActRep- BwNot-
            LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
            DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
            LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
            Address: 0000000000000000  Data: 0000
        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
        Capabilities: [150 v1] Advanced Error Reporting
            UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
            CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap+ ChkEn-
        Kernel driver in use: fglrx_pci
        Kernel modules: fglrx_updates, radeon

    07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 50
        Region 0: I/O ports at 4000 [size=256]
        Region 2: Memory at c0404000 (64-bit, prefetchable) [size=4K]
        Region 4: Memory at c0400000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
            Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
            Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
            Address: 00000000feeff00c  Data: 41b9
        Capabilities: [70] Express (v2) Endpoint, MSI 01
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
                ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 4096 bytes
            DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
            LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
                ClockPM+ Surprise- LLActRep- BwNot-
            LnkCtl:    ASPM L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
            DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
            LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
            Vector table: BAR=4 offset=00000000
            PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data
            No end tag found
        Capabilities: [100 v1] Advanced Error Reporting
            UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
            CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Virtual Channel
            Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
            Arb:    Fixed- WRR32- WRR64- WRR128-
            Ctrl:    ArbSelect=Fixed
            Status:    InProgress-
            VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                Status:    NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 3b-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
        Kernel modules: r8169

    0d:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
        Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at c4500000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [c8] Power Management version 3
            Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
            Address: 00000000fee0100c  Data: 41c9
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
                ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
                MaxPayload 128 bytes, MaxReadReq 128 bytes
            DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
            LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
                ClockPM+ Surprise- LLActRep- BwNot-
            LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
            UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
            CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [140 v1] Device Serial Number 74-e5-0b-ff-ff-69-8d-c4
        Kernel modules: iwlwifi

    13:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5116 PCI Express Card Reader (rev 01)
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at c3501000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at c2400000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 3
            Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
            Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
                ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 512 bytes
            DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
            LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
                ClockPM+ Surprise- LLActRep- BwNot-
            LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
            DevCap2: Completion Timeout: Not Supported, TimeoutDis+
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
            LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100 v1] Advanced Error Reporting
            UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
            CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout+ NonFatalErr+
            CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
        Kernel driver in use: rts_pstor
        Kernel modules: rts_pstor

    13:00.1 SD Host controller: Realtek Semiconductor Co., Ltd. RTS5116 PCI Express Card Reader (rev 01)
        Subsystem: Hewlett-Packard Company Device 1656
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 19
        Region 0: Memory at c3500000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 3
            Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
            Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
            Address: 0000000000000000  Data: 0000
        Capabilities: [b0] Express (v2) Endpoint, MSI 01
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
                ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 512 bytes
            DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
            LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
                ClockPM+ Surprise- LLActRep- BwNot-
            LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
            DevCap2: Completion Timeout: Not Supported, TimeoutDis+
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
            LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100 v1] Advanced Error Reporting
            UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
            CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
            CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci

    19:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04) (prog-if 30 [XHCI])
        Subsystem: Hewlett-Packard Company Device 1658
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at c3400000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [50] Power Management version 3
            Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
            Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
            Address: 0000000000000000  Data: 0000
        Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
            Vector table: BAR=0 offset=00001000
            PBA: BAR=0 offset=00001080
        Capabilities: [a0] Express (v2) Endpoint, MSI 00
            DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
            DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                MaxPayload 128 bytes, MaxReadReq 512 bytes
            DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
            LnkCap:    Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 unlimited
                ClockPM+ Surprise- LLActRep- BwNot-
            LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
            LnkSta:    Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
            DevCap2: Completion Timeout: Not Supported, TimeoutDis+
            DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
            LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                 Compliance De-emphasis: -6dB
            LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100 v1] Advanced Error Reporting
            UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
            UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
            UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
            CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
            AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
        Capabilities: [150 v1] Latency Tolerance Reporting
            Max snoop latency: 0ns
            Max no snoop latency: 0ns
        Kernel driver in use: xhci_hcd

###SCSI information###
scsi:

    Attached devices:
    Host: scsi0 Channel: 00 Id: 00 Lun: 00
      Vendor: ATA      Model: Hitachi HTS54757 Rev: JE4O
      Type:   Direct-Access                    ANSI  SCSI revision: 05
    Host: scsi5 Channel: 00 Id: 00 Lun: 00
      Vendor: hp       Model: BD E  DS6E2LH    Rev: FH62
      Type:   CD-ROM                           ANSI  SCSI revision: 05
    Host: scsi6 Channel: 00 Id: 00 Lun: 00
      Vendor: Generic- Model: xD/SD/M.S.       Rev: 1.00
      Type:   Direct-Access                    ANSI  SCSI revision: 02

