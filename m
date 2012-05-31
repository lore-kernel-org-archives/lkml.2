Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab2EaVrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:47:06 -0400
Received: from info.physics.ubc.ca ([142.103.234.23]:50433 "EHLO
	info.physics.ubc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2EaVrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:47:02 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 17:47:02 EDT
Date: Thu, 31 May 2012 14:39:11 -0700 (PDT)
From: Bill Unruh <unruh@physics.ubc.ca>
X-X-Sender: unruh@info
To: linux-kernel@vger.kernel.org
Subject: Bug on bootup of Linux kernel on Panasonic Toughbook S10
Message-ID: <Pine.LNX.4.64.1205311412210.11510@info>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running Mageia 2 kernel 3.3.6-desktop586-2.mga2

Every time I boot up I get the error messages
pci 0000:00:04.0: BAR 0: error updating (0xdfa00004 != 0xfed98004)


I have no idea what this means. The system appears to be running OK (Ie I have
not noticed problems) 
I do have to run with noapic or the system randomly crashes (usually during
boot, but sometimes after bootup)

It was suggested that I try the pci=nocrs option which does get rid of that
error message, but also results in a much slower boot and slower running of
the system.

System Panasonic toughbook Cf-S10 (Intel graphics using ram for its memory,
Intel 6205 wireless card).

The dmesg lines from around that error message

[    2.037963] system 00:0d: [mem 0x20000000-0x201fffff] has been reserved
[    2.037965] system 00:0d: [mem 0x40000000-0x401fffff] has been reserved
[    2.037967] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.038015] pnp 00:0e: [mem 0xfed98000-0xfed9ffff]
[    2.038064] system 00:0e: [mem 0xfed98000-0xfed9ffff] has been reserved
[    2.038067] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.038080] pnp: PnP ACPI: found 15 devices
[    2.038081] ACPI: ACPI bus type pnp unregistered
[    2.038083] PnPBIOS: Disabled
[    2.074428] PCI: max bus depth: 2 pci_try_num: 3
[    2.074481] pci 0000:00:04.0: BAR 0: assigned [mem 0xdfa00000-0xdfa07fff 64bit]
[    2.074484] pci 0000:00:04.0: BAR 0: error updating (0xdfa00004 != 0xfed98004)
[    2.074491] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    2.074495] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    2.074500] pci 0000:00:1c.0:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    2.074505] pci 0000:00:1c.0:   bridge window [mem 0xf2700000-0xf27fffff
64bit pref] [    2.074512] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    2.074515] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    2.074521] pci 0000:00:1c.1:   bridge window [mem 0xf7a00000-0xf7afffff]
[    2.074525] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff 64bit pref]
[    2.074532] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    2.074535] pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
[    2.074541] pci 0000:00:1c.2:   bridge window [mem 0xf7900000-0xf79fffff]
[    2.074545] pci 0000:00:1c.2:   bridge window [mem 0xf2300000-0xf23fffff 64bit pref]
[    2.074557] pci 0000:04:00.0: BAR 16: can't assign mem (size 0x4000000)
[    2.074564] pci 0000:04:00.0: BAR 15: can't assign mem pref (size 0x4000000)
[    2.074566] pci 0000:04:00.0: BAR 14: assigned [io  0x8000-0x80ff]
[    2.074568] pci 0000:04:00.0: BAR 13: assigned [io  0x8400-0x84ff]


Various other information.



:
Linux version 3.3.6-desktop586-2.mga2 (iurt@ecosse.mageia.org) (gcc version 4.6.3 (GCC) ) #1 SMP Thu May 17 16:35:38 UTC 2012

/proc/cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4988.38
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 2
initial apicid	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4988.38
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4988.38
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 3
initial apicid	: 3
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4988.38
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


/proc/modules

fuse 72055 3 - Live 0xf5b7d000
ipt_IFWLOG 12550 2 - Live 0xf5b30000
ipt_psd 53435 1 - Live 0xf5e02000
cls_flow 16891 0 - Live 0xf5b35000
cls_fw 12760 0 - Live 0xf5b2b000
cls_u32 16908 0 - Live 0xf5b20000
sch_tbf 12888 0 - Live 0xf5b1b000
sch_prio 12960 0 - Live 0xf5aef000
sch_htb 21741 0 - Live 0xf5aff000
sch_hfsc 25982 0 - Live 0xf5af7000
sch_ingress 12746 0 - Live 0xf5adf000
sch_sfq 17112 0 - Live 0xf5ae9000
bridge 79586 0 - Live 0xf5b06000
stp 12811 1 bridge, Live 0xf5cad000
xt_time 12581 0 - Live 0xf5bd5000
xt_connlimit 12591 0 - Live 0xf5b26000
xt_realm 12450 0 - Live 0xf5bef000
xt_addrtype 12563 4 - Live 0xf5bbd000
ip_set_hash_ip 27265 2 - Live 0xf5b45000
iptable_raw 12598 0 - Live 0xf5b78000
xt_comment 12456 18 - Live 0xf5c6d000
xt_recent 17995 0 - Live 0xf5bcc000
xt_policy 12518 0 - Live 0xf5b40000
ipt_ULOG 13664 0 - Live 0xf5ae4000
ipt_REJECT 12485 4 - Live 0xf5ada000
ipt_REDIRECT 12590 0 - Live 0xf5ad5000
ipt_NETMAP 12582 0 - Live 0xf5ad0000
ipt_MASQUERADE 12760 0 - Live 0xf5acb000
ipt_ECN 12473 0 - Live 0xf5ac1000
ipt_CLUSTERIP 13247 0 - Live 0xf5ac6000
ipt_ah 12694 0 - Live 0xf5ab2000
xt_set 12939 2 - Live 0xf5aad000
ip_set 30822 2 ip_set_hash_ip,xt_set, Live 0xf5ab8000
nf_nat_tftp 12420 0 - Live 0xf5aa2000
nf_nat_snmp_basic 17163 0 - Live 0xf5aa7000
nf_conntrack_snmp 12745 1 nf_nat_snmp_basic, Live 0xf5a9d000
nf_nat_sip 16921 0 - Live 0xf5a97000
nf_nat_pptp 12926 0 - Live 0xf5a92000
nf_nat_proto_gre 12898 1 nf_nat_pptp, Live 0xf5a8d000
nf_nat_irc 12606 0 - Live 0xf5a82000
nf_nat_h323 17359 0 - Live 0xf5a87000
nf_nat_ftp 12645 0 - Live 0xf5a7d000
nf_nat_amanda 12422 0 - Live 0xf5a78000
ts_kmp 12533 5 - Live 0xf5a73000
nf_conntrack_amanda 12897 1 nf_nat_amanda, Live 0xf5a6e000
nf_conntrack_sane 12965 0 - Live 0xf5a5d000
nf_conntrack_tftp 12980 1 nf_nat_tftp, Live 0xf5a28000
nf_conntrack_sip 24594 1 nf_nat_sip, Live 0xf5a66000
nf_conntrack_proto_sctp 18039 0 - Live 0xf5a57000
nf_conntrack_pptp 14615 1 nf_nat_pptp, Live 0xf5a41000
nf_conntrack_proto_gre 13878 1 nf_conntrack_pptp, Live 0xf5a52000
nf_conntrack_netlink 26205 0 - Live 0xf5a4a000
nf_conntrack_netbios_ns 12585 0 - Live 0xf5a23000
nf_conntrack_broadcast 12541 2 nf_conntrack_snmp,nf_conntrack_netbios_ns, Live 0xf5a1e000
nf_conntrack_irc 13275 1 nf_nat_irc, Live 0xf5a08000
nf_conntrack_h323 62776 1 nf_nat_h323, Live 0xf5a30000
nf_conntrack_ftp 14049 1 nf_nat_ftp, Live 0xf5a19000
xt_TPROXY 17135 0 - Live 0xf5a13000
nf_defrag_ipv6 13690 1 xt_TPROXY, Live 0xf5a0e000
nf_tproxy_core 12554 1 xt_TPROXY,[permanent], Live 0xf59fb000
ip6_tables 18115 1 xt_TPROXY, Live 0xf5a02000
xt_tcpmss 12453 0 - Live 0xf51d6000
xt_pkttype 12456 0 - Live 0xf51d1000
xt_physdev 12523 0 - Live 0xf51cc000
xt_owner 12450 0 - Live 0xf51c7000
xt_NFQUEUE 12606 0 - Live 0xf51c2000
xt_NFLOG 12481 0 - Live 0xf51b6000
nfnetlink_log 17489 1 xt_NFLOG, Live 0xf51bc000
xt_multiport 12694 4 - Live 0xf51b1000
xt_mark 12499 1 - Live 0xf51ac000
xt_mac 12444 0 - Live 0xf51a7000
xt_limit 12541 0 - Live 0xf51a2000
xt_length 12480 0 - Live 0xf519d000
xt_iprange 12679 0 - Live 0xf5198000
xt_helper 12519 0 - Live 0xf518d000
xt_hashlimit 17290 0 - Live 0xf5192000
xt_DSCP 12549 0 - Live 0xf5188000
xt_dscp 12525 0 - Live 0xf5183000
xt_dccp 12534 0 - Live 0xf517e000
xt_conntrack 12664 8 - Live 0xf5179000
xt_connmark 12659 0 - Live 0xf5174000
xt_CLASSIFY 12459 0 - Live 0xf5164000
xt_AUDIT 12590 0 - Live 0xf5121000
ipt_LOG 12841 5 - Live 0xf50fb000
xt_tcpudp 12756 11 - Live 0xf506a000
xt_state 12514 1 - Live 0xf501a000
iptable_nat 13138 0 - Live 0xf4bf4000
nf_nat 24963 12 ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,nf_nat_tftp,nf_nat_sip,nf_nat_pptp,nf_nat_proto_gre,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,iptable_nat, Live 0xf516c000
nf_conntrack_ipv4 14277 12 iptable_nat,nf_nat, Live 0xf4bfa000
nf_defrag_ipv4 12649 2 xt_TPROXY,nf_conntrack_ipv4, Live 0xf5015000
nf_conntrack 65397 32 xt_connlimit,ipt_MASQUERADE,ipt_CLUSTERIP,nf_nat_tftp,nf_nat_snmp_basic,nf_conntrack_snmp,nf_nat_sip,nf_nat_pptp,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_amanda,nf_conntrack_sane,nf_conntrack_tftp,nf_conntrack_sip,nf_conntrack_proto_sctp,nf_conntrack_pptp,nf_conntrack_proto_gre,nf_conntrack_netlink,nf_conntrack_netbios_ns,nf_conntrack_broadcast,nf_conntrack_irc,nf_conntrack_h323,nf_conntrack_ftp,xt_helper,xt_conntrack,xt_connmark,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4, Live 0xf50ea000
iptable_mangle 12615 1 - Live 0xf4bef000
nfnetlink 13983 3 ip_set,nf_conntrack_netlink,nfnetlink_log, Live 0xf4777000
iptable_filter 12706 1 - Live 0xf476a000
ip_tables 17987 4 iptable_raw,iptable_nat,iptable_mangle,iptable_filter, Live 0xf4bdf000
x_tables 21992 49 ipt_IFWLOG,ipt_psd,xt_time,xt_connlimit,xt_realm,xt_addrtype,iptable_raw,xt_comment,xt_recent,xt_policy,ipt_ULOG,ipt_REJECT,ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,ipt_ECN,ipt_CLUSTERIP,ipt_ah,xt_set,xt_TPROXY,ip6_tables,xt_tcpmss,xt_pkttype,xt_physdev,xt_owner,xt_NFQUEUE,xt_NFLOG,xt_multiport,xt_mark,xt_mac,xt_limit,xt_length,xt_iprange,xt_helper,xt_hashlimit,xt_DSCP,xt_dscp,xt_dccp,xt_conntrack,xt_connmark,xt_CLASSIFY,xt_AUDIT,ipt_LOG,xt_tcpudp,xt_state,iptable_nat,iptable_mangle,iptable_filter,ip_tables, Live 0xf4be8000
rfcomm 57543 8 - Live 0xf50da000
bnep 18867 2 - Live 0xf45c6000
snd_hda_codec_hdmi 31470 1 - Live 0xf4bd6000
cpufreq_ondemand 13452 4 - Live 0xf476f000
cpufreq_conservative 13495 0 - Live 0xf4737000
cpufreq_powersave 12554 0 - Live 0xf46a1000
acpi_cpufreq 14206 1 - Live 0xf4732000
mperf 12603 1 acpi_cpufreq, Live 0xf472d000
snd_hda_codec_realtek 121605 1 - Live 0xf504b000
freq_table 14322 2 cpufreq_ondemand,acpi_cpufreq, Live 0xf45ea000
nvram 13957 0 - Live 0xf4673000
snd_hda_intel 32340 3 - Live 0xf4761000
snd_hda_codec 108688 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0xf4623000
arc4 12473 2 - Live 0xf42a1000
snd_pcm 88532 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0xf4711000
snd_page_alloc 14036 2 snd_hda_intel,snd_pcm, Live 0xf45b2000
snd_hwdep 13276 1 snd_hda_codec, Live 0xf45c1000
snd_timer 28598 1 snd_pcm, Live 0xf45e2000
snd 65929 13 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_hwdep,snd_timer, Live 0xf4661000
tpm_tis 18576 0 - Live 0xf433f000
btusb 23231 1 - Live 0xf45ba000
iwlwifi 286332 0 - Live 0xf523c000
mac80211 384735 1 iwlwifi, Live 0xf51dd000
iTCO_wdt 17652 0 - Live 0xf434d000
iTCO_vendor_support 13502 1 iTCO_wdt, Live 0xf426c000
e1000e 175646 0 - Live 0xf4fe9000
mei 68995 0 - Live 0xf45d0000 (C)
bluetooth 239698 23 rfcomm,bnep,btusb, Live 0xf5128000
soundcore 14599 1 snd, Live 0xf4267000
tpm_infineon 13200 0 - Live 0xf4273000
cfg80211 169030 2 iwlwifi,mac80211, Live 0xf5020000
panasonic_laptop 13194 0 - Live 0xf427b000
serio_raw 13155 0 - Live 0xf4246000
i2c_i801 17506 0 - Live 0xf4250000
sparse_keymap 13658 1 panasonic_laptop, Live 0xf4728000
tpm 21864 2 tpm_tis,tpm_infineon, Live 0xf42b6000
battery 13522 0 - Live 0xf424b000
processor 30402 1 acpi_cpufreq, Live 0xf42ad000
thermal 13830 0 - Live 0xf4227000
tpm_bios 13421 1 tpm, Live 0xf4210000
rfkill 20902 3 bluetooth,cfg80211, Live 0xf4331000
joydev 17161 0 - Live 0xf42a7000
evdev 17445 7 - Live 0xf4221000
ac 12742 0 - Live 0xf41bc000
ipv6 286407 55 bridge,xt_TPROXY,nf_defrag_ipv6, Live 0xf42cb000
autofs4 37365 3 - Live 0xf4296000
ext4 428767 2 - Live 0xf5070000
jbd2 75163 1 ext4, Live 0xf4282000
crc16 12595 2 bluetooth,ext4, Live 0xf41c7000
mmc_block 26567 0 - Live 0xf4185000
pcmcia 51330 0 - Live 0xf4259000
rts_pstor 341858 0 - Live 0xf4b81000 (C)
xhci_hcd 115575 0 - Live 0xf4313000
sd_mod 43934 4 - Live 0xf42bf000
sdhci_pci 18149 0 - Live 0xf420a000
sr_mod 21872 0 - Live 0xf41a8000
sdhci 37180 1 sdhci_pci, Live 0xf4216000
crc_t10dif 12507 1 sd_mod, Live 0xf4195000
mmc_core 100789 3 mmc_block,sdhci_pci,sdhci, Live 0xf422c000
ehci_hcd 55582 0 - Live 0xf41cd000
yenta_socket 36268 0 - Live 0xf41af000
usbcore 177104 4 btusb,xhci_hcd,ehci_hcd, Live 0xf41dd000
pcmcia_rsrc 18319 1 yenta_socket, Live 0xf419a000
pcmcia_core 22246 3 pcmcia,yenta_socket,pcmcia_rsrc, Live 0xf418e000
usb_common 12525 1 usbcore, Live 0xf4180000
i915 414077 3 - Live 0xf46aa000
video 18640 1 i915, Live 0xf45ac000
button 13561 1 i915, Live 0xf416d000
i2c_algo_bit 13080 1 i915, Live 0xf435c000
drm_kms_helper 32743 1 i915, Live 0xf4177000
drm 208242 4 i915,drm_kms_helper, Live 0xf45ef000
i2c_core 29836 5 i2c_i801,i915,i2c_algo_bit,drm_kms_helper,drm, Live 0xf4377000
dm_mirror 21654 0 - Live 0xf4364000
dm_region_hash 15977 1 dm_mirror, Live 0xf4172000
dm_log 18111 2 dm_mirror,dm_region_hash, Live 0xf4356000
dm_mod 75920 2 dm_mirror,dm_log, Live 0xf406b000
ata_piix 22146 0 - Live 0xf4132000
ahci 25496 4 - Live 0xf4059000
libahci 25805 1 ahci, Live 0xf4063000
libata 183151 3 ata_piix,ahci,libahci, Live 0xf402b000
mpt2sas 168588 0 - Live 0xf4581000
raid_class 13293 1 mpt2sas, Live 0xf4019000
scsi_transport_sas 34482 1 mpt2sas, Live 0xf4021000
scsi_mod 186048 7 rts_pstor,sd_mod,sr_mod,libata,mpt2sas,raid_class,scsi_transport_sas, Live 0xf413e000

/proc/ioports

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
   03c0-03df : vesafb
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
   0900-097f : pnp 00:05
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   1000-100f : pnp 00:05
   8000-9fff : PCI Bus 0000:04
     8000-80ff : PCI CardBus 0000:40
     8400-84ff : PCI CardBus 0000:40
   a000-afff : PCI Bus 0000:0d
   b000-bfff : PCI Bus 0000:03
   c000-cfff : PCI Bus 0000:02
   d000-dfff : PCI Bus 0000:01
   e000-e03f : 0000:00:02.0
   e040-e05f : 0000:00:1f.3
   e060-e07f : 0000:00:1f.2
     e060-e07f : ahci
   e080-e09f : 0000:00:19.0
   e0a0-e0a3 : 0000:00:1f.2
     e0a0-e0a3 : ahci
   e0b0-e0b7 : 0000:00:1f.2
     e0b0-e0b7 : ahci
   e0c0-e0c3 : 0000:00:1f.2
     e0c0-e0c3 : ahci
   e0d0-e0d7 : 0000:00:1f.2
     e0d0-e0d7 : ahci
   e0e0-e0e7 : 0000:00:16.3
     e0e0-e0e7 : serial
   ffff-ffff : pnp 00:05
     ffff-ffff : pnp 00:05

/proc/iomem

00000000-0000ffff : reserved
00010000-0009e7ff : System RAM
0009e800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
   000a0000-000bffff : Video RAM area
000c0000-000cf1ff : Video ROM
000cf200-000cf7ff : pnp 00:01
000cf800-000d07ff : Adapter ROM
000d0800-000d3fff : pnp 00:01
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-1fffffff : System RAM
   00100000-004bbff3 : Kernel code
   004bbff4-006b7dbf : Kernel data
   00749000-007d4fff : Kernel bss
20000000-201fffff : reserved
   20000000-201fffff : pnp 00:0d
20200000-3fffffff : System RAM
40000000-401fffff : reserved
   40000000-401fffff : pnp 00:0d
40200000-dac33fff : System RAM
dac34000-dad8dfff : reserved
dad8e000-dad9dfff : System RAM
dad9e000-dad9ffff : reserved
dada0000-dada0fff : System RAM
dada1000-dade7fff : reserved
dade8000-daf39fff : System RAM
daf3a000-daf80fff : ACPI Non-volatile Storage
daf81000-daf87fff : reserved
daf88000-dafe7fff : ACPI Non-volatile Storage
dafe8000-dafebfff : System RAM
dafec000-df9fffff : reserved
dfa00000-feafffff : PCI Bus 0000:00
   dfa00000-dfa07fff : 0000:00:04.0
   e0000000-efffffff : 0000:00:02.0
   f0000000-f1ffffff : PCI Bus 0000:04
   f2100000-f21fffff : PCI Bus 0000:0d
   f2300000-f23fffff : PCI Bus 0000:03
   f2500000-f25fffff : PCI Bus 0000:02
   f2700000-f27fffff : PCI Bus 0000:01
   f5400000-f57fffff : 0000:00:02.0
   f5800000-f77fffff : PCI Bus 0000:04
     f5800000-f6bfffff : PCI CardBus 0000:40
     f6c00000-f6c00fff : 0000:04:00.0
       f6c00000-f6c00fff : yenta_socket
     f7000000-f73fffff : PCI CardBus 0000:40
   f7800000-f78fffff : PCI Bus 0000:0d
     f7800000-f78000ff : 0000:0d:00.1
       f7800000-f78000ff : mmc0
     f7801000-f7801fff : 0000:0d:00.0
       f7801000-f7801fff : rts_pstor
   f7900000-f79fffff : PCI Bus 0000:03
     f7900000-f7901fff : 0000:03:00.0
       f7900000-f7901fff : iwlwifi
   f7a00000-f7afffff : PCI Bus 0000:02
     f7a00000-f7a01fff : 0000:02:00.0
       f7a00000-f7a01fff : xhci_hcd
   f7b00000-f7bfffff : PCI Bus 0000:01
   f7c00000-f7c1ffff : 0000:00:19.0
     f7c00000-f7c1ffff : e1000e
   f7c28000-f7c2bfff : 0000:00:1b.0
     f7c28000-f7c2bfff : ICH HD audio
   f7c2c000-f7c2cfff : 0000:00:1f.6
   f7c2d000-f7c2d0ff : 0000:00:1f.3
   f7c2e000-f7c2e7ff : 0000:00:1f.2
     f7c2e000-f7c2e7ff : ahci
   f7c2f000-f7c2f3ff : 0000:00:1d.0
     f7c2f000-f7c2f3ff : ehci_hcd
   f7c30000-f7c303ff : 0000:00:1a.0
     f7c30000-f7c303ff : ehci_hcd
   f7c31000-f7c31fff : 0000:00:19.0
     f7c31000-f7c31fff : e1000e
   f7c32000-f7c32fff : 0000:00:16.3
   f7c34000-f7c3400f : 0000:00:16.0
     f7c34000-f7c3400f : mei
   f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
     f8000000-fbffffff : reserved
       f8000000-fbffffff : pnp 00:0b
fec00000-fec00fff : reserved
fed00000-fed003ff : HPET 0
fed08000-fed08fff : pnp 00:0b
fed10000-fed13fff : reserved
fed18000-fed19fff : reserved
   fed18000-fed18fff : pnp 00:0b
   fed19000-fed19fff : pnp 00:0b
fed1c000-fed1ffff : reserved
   fed1c000-fed1ffff : pnp 00:0b
fed20000-fed3ffff : pnp 00:0b
fed40000-fed44fff : PCI Bus 0000:00
fed45000-fed8ffff : pnp 00:0b
fed90000-fed93fff : pnp 00:0b
fed98000-fed9ffff : pnp 00:0e
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ff980000-ffbfffff : reserved
ffd80000-ffffffff : reserved
--------

lspci -vvv


00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
 	Latency: 0
 	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
 	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 45
 	Region 0: Memory at f5400000 (64-bit, non-prefetchable) [size=4M]
 	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
 	Region 4: I/O ports at e000 [size=64]
 	Expansion ROM at <unassigned> [disabled]
 	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
 		Address: fee00000  Data: 4061
 	Capabilities: [d0] Power Management version 2
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [a4] PCI Advanced Features
 		AFCap: TP+ FLR+
 		AFCtrl: FLR-
 		AFStatus: TP-
 	Kernel driver in use: i915

00:04.0 Signal processing controller: Intel Corporation Device 0103 (rev 09)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 11
 	Region 0: Memory at dfa00000 (64-bit, non-prefetchable) [size=32K]
 	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
 		Address: 00000000  Data: 0000
 	Capabilities: [d0] Power Management version 3
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 51
 	Region 0: Memory at f7c34000 (64-bit, non-prefetchable) [size=16]
 	Capabilities: [50] Power Management version 3
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
 		Address: 00000000fee00000  Data: 4091
 	Kernel driver in use: mei

00:16.3 Serial controller: Intel Corporation 6 Series/C200 Series Chipset Family KT Controller (rev 04) (prog-if 02 [16550])
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin B routed to IRQ 10
 	Region 0: I/O ports at e0e0 [size=8]
 	Region 1: Memory at f7c32000 (32-bit, non-prefetchable) [size=4K]
 	Capabilities: [c8] Power Management version 3
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
 		Address: 0000000000000000  Data: 0000
 	Kernel driver in use: serial

00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (rev 04)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 52
 	Region 0: Memory at f7c00000 (32-bit, non-prefetchable) [size=128K]
 	Region 1: Memory at f7c31000 (32-bit, non-prefetchable) [size=4K]
 	Region 2: I/O ports at e080 [size=32]
 	Capabilities: [c8] Power Management version 2
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
 	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
 		Address: 00000000fee00000  Data: 40b9
 	Capabilities: [e0] PCI Advanced Features
 		AFCap: TP+ FLR+
 		AFCtrl: FLR-
 		AFStatus: TP-
 	Kernel driver in use: e1000e

00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 11
 	Region 0: Memory at f7c30000 (32-bit, non-prefetchable) [size=1K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [58] Debug port: BAR=1 offset=00a0
 	Capabilities: [98] PCI Advanced Features
 		AFCap: TP+ FLR+
 		AFCtrl: FLR-
 		AFStatus: TP-
 	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 54
 	Region 0: Memory at f7c28000 (64-bit, non-prefetchable) [size=16K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
 		Address: 00000000fee00000  Data: 40a9
 	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
 			ExtTag- RBE- FLReset+
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
 			ClockPM- Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
 	Capabilities: [100 v1] Virtual Channel
 		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
 		Arb:	Fixed- WRR32- WRR64- WRR128-
 		Ctrl:	ArbSelect=Fixed
 		Status:	InProgress-
 		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
 			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
 			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
 			Status:	NegoPending- InProgress-
 		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
 			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
 			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=22
 			Status:	NegoPending- InProgress-
 	Capabilities: [130 v1] Root Complex Link
 		Desc:	PortNumber=0f ComponentID=00 EltType=Config
 		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
 			Addr:	00000000fed1c000
 	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b4) (prog-if 00 [Normal decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
 	I/O behind bridge: 0000d000-0000dfff
 	Memory behind bridge: f7b00000-f7bfffff
 	Prefetchable memory behind bridge: 00000000f2700000-00000000f27fffff
 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
 			ExtTag- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
 			ClockPM- Surprise- LLActRep+ BwNot-
 		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
 			Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
 			Changed: MRL- PresDet- LinkState-
 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
 		RootCap: CRSVisible-
 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
 			 Compliance De-emphasis: -6dB
 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
 		Address: fee00000  Data: 4029
 	Capabilities: [90] Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Capabilities: [a0] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b4) (prog-if 00 [Normal decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
 	I/O behind bridge: 0000c000-0000cfff
 	Memory behind bridge: f7a00000-f7afffff
 	Prefetchable memory behind bridge: 00000000f2500000-00000000f25fffff
 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
 			ExtTag- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
 			ClockPM- Surprise- LLActRep+ BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
 			Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
 			Changed: MRL- PresDet- LinkState+
 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
 		RootCap: CRSVisible-
 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
 			 Compliance De-emphasis: -6dB
 		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
 		Address: fee00000  Data: 4041
 	Capabilities: [90] Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Capabilities: [a0] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b4) (prog-if 00 [Normal decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
 	I/O behind bridge: 0000b000-0000bfff
 	Memory behind bridge: f7900000-f79fffff
 	Prefetchable memory behind bridge: 00000000f2300000-00000000f23fffff
 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
 			ExtTag- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
 			ClockPM- Surprise- LLActRep+ BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
 			Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
 			Changed: MRL- PresDet- LinkState+
 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
 		RootCap: CRSVisible-
 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
 			 Compliance De-emphasis: -6dB
 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
 		Address: fee00000  Data: 4049
 	Capabilities: [90] Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Capabilities: [a0] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev b4) (prog-if 01 [Subtractive decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=04, subordinate=0c, sec-latency=0
 	I/O behind bridge: 00008000-00009fff
 	Memory behind bridge: f5800000-f77fffff
 	Prefetchable memory behind bridge: 00000000f0000000-00000000f1ffffff
 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
 			ExtTag- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
 			ClockPM- Surprise- LLActRep+ BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
 			Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
 			Changed: MRL- PresDet- LinkState+
 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
 		RootCap: CRSVisible-
 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
 			 Compliance De-emphasis: -6dB
 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
 		Address: 00000000  Data: 0000
 	Capabilities: [90] Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Capabilities: [a0] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b4) (prog-if 00 [Normal decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
 	I/O behind bridge: 0000a000-0000afff
 	Memory behind bridge: f7800000-f78fffff
 	Prefetchable memory behind bridge: 00000000f2100000-00000000f21fffff
 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
 			ExtTag- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
 			ClockPM- Surprise- LLActRep+ BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
 			Slot #4, PowerLimit 10.000W; Interlock- NoCompl+
 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
 			Changed: MRL- PresDet- LinkState-
 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
 		RootCap: CRSVisible-
 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
 			 Compliance De-emphasis: -6dB
 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
 		Address: fee00000  Data: 4051
 	Capabilities: [90] Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Capabilities: [a0] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 10
 	Region 0: Memory at f7c2f000 (32-bit, non-prefetchable) [size=1K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [58] Debug port: BAR=1 offset=00a0
 	Capabilities: [98] PCI Advanced Features
 		AFCap: TP+ FLR+
 		AFCtrl: FLR-
 		AFStatus: TP-
 	Kernel driver in use: ehci_hcd

00:1f.0 ISA bridge: Intel Corporation QM67 Express Chipset Family LPC Controller (rev 04)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 04) (prog-if 01 [AHCI 1.0])
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin B routed to IRQ 44
 	Region 0: I/O ports at e0d0 [size=8]
 	Region 1: I/O ports at e0c0 [size=4]
 	Region 2: I/O ports at e0b0 [size=8]
 	Region 3: I/O ports at e0a0 [size=4]
 	Region 4: I/O ports at e060 [size=32]
 	Region 5: Memory at f7c2e000 (32-bit, non-prefetchable) [size=2K]
 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
 		Address: fee00000  Data: 4059
 	Capabilities: [70] Power Management version 3
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
 	Capabilities: [b0] PCI Advanced Features
 		AFCap: TP+ FLR+
 		AFCtrl: FLR-
 		AFStatus: TP-
 	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 04)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Interrupt: pin C routed to IRQ 11
 	Region 0: Memory at f7c2d000 (64-bit, non-prefetchable) [size=256]
 	Region 4: I/O ports at e040 [size=32]

00:1f.6 Signal processing controller: Intel Corporation 6 Series/C200 Series Chipset Family Thermal Management Controller (rev 04)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin C routed to IRQ 11
 	Region 0: Memory at f7c2c000 (64-bit, non-prefetchable) [size=4K]
 	Capabilities: [50] Power Management version 3
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

02:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04) (prog-if 30 [XHCI])
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 4
 	Region 0: Memory at f7a00000 (64-bit, non-prefetchable) [size=8K]
 	Capabilities: [50] Power Management version 3
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
 		Address: 0000000000000000  Data: 0000
 	Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
 		Vector table: BAR=0 offset=00001000
 		PBA: BAR=0 offset=00001080
 	Capabilities: [a0] Express (v2) Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
 			MaxPayload 128 bytes, MaxReadReq 512 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 unlimited
 			ClockPM+ Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
 		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
 			 Compliance De-emphasis: -6dB
 		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 	Capabilities: [100 v1] Advanced Error Reporting
 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
 	Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
 	Capabilities: [150 v1] Latency Tolerance Reporting
 		Max snoop latency: 0ns
 		Max no snoop latency: 0ns
 	Kernel driver in use: xhci_hcd

03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)
 	Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 53
 	Region 0: Memory at f7900000 (64-bit, non-prefetchable) [size=8K]
 	Capabilities: [c8] Power Management version 3
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
 		Address: 00000000fee00000  Data: 40a1
 	Capabilities: [e0] Express (v1) Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <32us
 			ClockPM+ Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
 	Capabilities: [100 v1] Advanced Error Reporting
 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
 	Capabilities: [140 v1] Device Serial Number 08-11-96-ff-ff-3d-5b-30
 	Kernel driver in use: iwlwifi

04:00.0 CardBus bridge: Ricoh Co Ltd Device e476 (rev 02)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 10
 	Region 0: Memory at f6c00000 (32-bit, non-prefetchable) [size=4K]
 	Bus: primary=04, secondary=40, subordinate=43, sec-latency=176
 	Memory window 0: f5800000-f6bfffff (prefetchable)
 	Memory window 1: f7000000-f73fffff
 	I/O window 0: 00008400-000084ff
 	I/O window 1: 00008000-000080ff
 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
 	16-bit legacy interface ports at 0001
 	Kernel driver in use: yenta_cardbus

0d:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5116 PCI Express Card Reader (rev 01)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 11
 	Region 0: Memory at f7801000 (32-bit, non-prefetchable) [size=4K]
 	Capabilities: [40] Power Management version 3
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
 		Address: 0000000000000000  Data: 0000
 	Capabilities: [70] Express (v2) Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 512 bytes
 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
 			ClockPM+ Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
 			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
 		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
 		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
 			 Compliance De-emphasis: -6dB
 		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 	Capabilities: [100 v1] Advanced Error Reporting
 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout+ NonFatalErr+
 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
 	Capabilities: [140 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
 	Kernel driver in use: rts_pstor

0d:00.1 SD Host controller: Realtek Semiconductor Co., Ltd. RTS5116 PCI Express Card Reader (rev 01)
 	Subsystem: Matsushita Electric Industrial Co., Ltd. Device 8338
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin B routed to IRQ 4
 	Region 0: Memory at f7800000 (32-bit, non-prefetchable) [size=256]
 	Capabilities: [80] Power Management version 3
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
 		Address: 0000000000000000  Data: 0000
 	Capabilities: [b0] Express (v2) Endpoint, MSI 01
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 512 bytes
 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
 			ClockPM+ Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
 		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
 		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
 			 Compliance De-emphasis: -6dB
 		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 	Capabilities: [100 v1] Advanced Error Reporting
 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
 	Capabilities: [140 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
 	Kernel driver in use: sdhci-pci

