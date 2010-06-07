Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0FGLBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:01:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37229 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0FGLBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=vA2sb0qWtKNlMrDE9a5WoaRDP2svgJ+pd5Jyz8s1qz9XpXF2bpFeRUCZm1xgLpZS29
         Y76a7Rn+QyLuJsn24U0fqzAT4Z0b3qoYTV45h9dPn5kkgyMM02Fdai2HnE3z6JziBj8S
         cdjXHw9iOSkP9meKzJqqNRJXk1+DHlBUCUvOE=
MIME-Version: 1.0
From: Antony Gelberg <antony.gelberg@gmail.com>
Date: Mon, 7 Jun 2010 14:01:17 +0300
Message-ID: <AANLkTil7ZsABDQQr68jDHZ00QAInltFHn0X2szsMuyLV@mail.gmail.com>
Subject: PROBLEM: iwl3945 not working after resume from hibernate
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If any more information is required, please ask.

Antony


[1.] One line summary of the problem:

  iwl3945 not working after resume from hibernate

[2.] Full description of the problem/report:

I'm currently using Gnome which I believe uses pm-hibernate under the
hood.  With 2.6.34, quite often upon resume from hibernate, I get the
following on the console:

Message from syslogd@labrie at Sun Jun  6 22:51:37 2010 ...
labrie kernel: [97637.002492] Oops: 0000 [#1] SMP
labrie kernel: [97637.002500] last sysfs file:
/sys/devices/platform/hdaps/position
labrie kernel: [97637.002696] Process udisks-helper-a (pid: 24147, ti=f2aac000
task=f7064000 task.ti=f2aac000)
labrie kernel: [97637.002698] Stack:
labrie kernel: [97637.002719] Call Trace:
labrie kernel: [97637.002782] Code: ec 04 31 db 89 0c 24 89 d8 89 d1 f2 ae 4f
8b 0c 24 49 78 06 ac aa 84 c0 75 f7 31 c0 aa 5b 89 e8 5b 5e 5f 5d c3 57 89 d7
56 89 c6 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f c3 57 89
labrie kernel: [97637.002817] EIP: [<c1139f51>] strcmp+0x6/0x19 SS:ESP
0068:f2aade20
labrie kernel: [97637.002822] CR2: 0000000000000000

Also, my iwl3945 wifi interface doesn't work, and modprobe iwl3945
just hangs (this is what I really care about).  I'm not sure if the
Oops: is related to the iwl3945 issue.  This didn't happen in 2.6.32
or .33 (although I didn't use .33 for long).

[4.] Kernel version (from /proc/version):
Linux version 2.6.34-1-686 (Debian 2.6.34-1~experimental.1)
(maks@debian.org) (gcc version 4.3.4 (Debian 4.3.4-10) ) #1 SMP Thu
May 20 12:14:21 UTC 2010

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
Above.

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

Linux labrie 2.6.34-1-686 #1 SMP Thu May 20 12:14:21 UTC 2010 i686 GNU/Linux

Gnu C                  4.4.4
Gnu make               3.81
binutils               2.20.1
util-linux             /usr/lib/linux-kbuild-2.6.34/scripts/ver_linux:
line 23: fdformat: command not found
mount                  support
module-init-tools      found
Linux C Library        2.10.2
Dynamic linker (ldd)   2.10.2
Procps                 3.2.8
Console-tools          0.2.3
Sh-utils               8.5
Modules Loaded         hid_microsoft usbhid hid iwl3945 iwlcore
mac80211 cfg80211 tun cpufreq_stats cpufreq_powersave
cpufreq_userspace cpufreq_conservative ppdev lp parport sco bridge stp
rfcomm bnep l2cap crc16 bluetooth nfsd lockd nfs_acl auth_rpcgss hdaps
input_polldev sunrpc exportfs binfmt_misc uinput act_police cls_flow
cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq xt_time
xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy
ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN
ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp
nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda
nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack
xt_CONNMARK xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack
iptable_mangle nfnetlink iptable_filter ip_tables x_tables microcode
fuse acpi_cpufreq coretemp loop firewire_sbp2 firewire_core crc_itu_t
dm_crypt dm_mod snd_hda_codec_conexant snd_hda_intel arc4 ecb
snd_hda_codec i915 snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_midi drm_kms_helper snd_rawmidi snd_seq_midi_event drm
thinkpad_acpi snd_seq i2c_algo_bit snd_timer snd_seq_device pcmcia
joydev rfkill tpm_tis evdev tpm video tpm_bios nvram yenta_socket
rsrc_nonstatic pcmcia_core i2c_i801 i2c_core snd soundcore
snd_page_alloc psmouse processor button ac battery serio_raw output
ext3 jbd mbcache sg sd_mod crc_t10dif sr_mod cdrom ata_generic
uhci_hcd ata_piix sdhci_pci libata sdhci tg3 mmc_core led_class libphy
thermal ehci_hcd thermal_sys scsi_mod usbcore nls_base


[7.2.] Processor information (from /proc/cpuinfo):

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz
stepping	: 13
cpu MHz		: 1801.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
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
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida tpr_shadow vnmi
flexpriority
bogomips	: 3590.94
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz
stepping	: 13
cpu MHz		: 1800.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida tpr_shadow vnmi
flexpriority
bogomips	: 3590.64
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

hid_microsoft 1991 0 - Live 0xf8343000
usbhid 28307 0 - Live 0xfc8ee000
hid 51185 2 hid_microsoft,usbhid, Live 0xfc8b6000
iwl3945 45454 0 - Live 0xfa993000
iwlcore 74369 1 iwl3945, Live 0xfa95b000
mac80211 134629 2 iwl3945,iwlcore, Live 0xfa8f2000
cfg80211 100055 3 iwl3945,iwlcore,mac80211, Live 0xfa871000
tun 9703 2 - Live 0xf84da000
cpufreq_stats 1944 0 - Live 0xf8127000
cpufreq_powersave 606 0 - Live 0xf811d000
cpufreq_userspace 1496 0 - Live 0xf8114000
cpufreq_conservative 6210 0 - Live 0xf8108000
ppdev 4453 0 - Live 0xf82e5000
lp 5849 0 - Live 0xf82bc000
parport 22234 2 ppdev,lp, Live 0xf82af000
sco 6012 2 - Live 0xf826d000
bridge 44520 0 - Live 0xf8251000
stp 1000 1 bridge, Live 0xf8235000
rfcomm 24743 0 - Live 0xf822c000
bnep 7579 2 - Live 0xf8175000
l2cap 22579 6 rfcomm,bnep, Live 0xf8156000
crc16 1031 1 l2cap, Live 0xf8141000
bluetooth 35931 6 sco,rfcomm,bnep,l2cap, Live 0xf812f000
nfsd 193778 11 - Live 0xfa2dd000
lockd 49983 1 nfsd, Live 0xfa28e000
nfs_acl 1699 1 nfsd, Live 0xfa272000
auth_rpcgss 25227 1 nfsd, Live 0xfa260000
hdaps 3784 0 - Live 0xfa24c000
input_polldev 2110 1 hdaps, Live 0xfa23f000
sunrpc 135008 12 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xfa206000
exportfs 2626 1 nfsd, Live 0xfa1c9000
binfmt_misc 5022 1 - Live 0xfa1be000
uinput 4799 2 - Live 0xfa1b1000
act_police 2988 0 - Live 0xfa14a000
cls_flow 4876 0 - Live 0xfa13e000
cls_fw 2753 0 - Live 0xfa133000
cls_u32 4698 0 - Live 0xfa128000
sch_htb 10455 0 - Live 0xfa11b000
sch_hfsc 13190 0 - Live 0xfa10b000
sch_ingress 1096 0 - Live 0xfa0fd000
sch_sfq 3890 0 - Live 0xfa0f4000
xt_time 1383 0 - Live 0xfa093000
xt_connlimit 2323 0 - Live 0xfa078000
xt_realm 607 0 - Live 0xfa04c000
iptable_raw 872 0 - Live 0xf9ff1000
xt_comment 591 22 - Live 0xf9f6a000
xt_recent 5457 0 - Live 0xf9efa000
xt_policy 1774 0 - Live 0xf9eaa000
ipt_ULOG 4625 0 - Live 0xf9e18000
ipt_REJECT 1501 4 - Live 0xf9e0d000
ipt_REDIRECT 795 0 - Live 0xf9e03000
ipt_NETMAP 817 0 - Live 0xf9dfa000
ipt_MASQUERADE 1126 0 - Live 0xf9df1000
ipt_ECN 1268 0 - Live 0xf9de7000
ipt_ecn 920 0 - Live 0xf9ddd000
ipt_CLUSTERIP 3974 0 - Live 0xf9dd4000
ipt_ah 741 0 - Live 0xf9dc9000
ipt_addrtype 1325 2 - Live 0xf9dc0000
nf_nat_tftp 718 0 - Live 0xf9db7000
nf_nat_snmp_basic 6144 0 - Live 0xf9dad000
nf_nat_sip 4439 0 - Live 0xf9da1000
nf_nat_pptp 1754 0 - Live 0xf9d96000
nf_nat_proto_gre 873 1 nf_nat_pptp, Live 0xf9d8c000
nf_nat_irc 1022 0 - Live 0xf9d82000
nf_nat_h323 4411 0 - Live 0xf9d77000
nf_nat_ftp 1216 0 - Live 0xf9d6c000
nf_nat_amanda 848 0 - Live 0xf9d62000
ts_kmp 1283 5 - Live 0xf9d59000
nf_conntrack_amanda 1645 1 nf_nat_amanda, Live 0xf9d50000
nf_conntrack_sane 2692 0 - Live 0xf9d46000
nf_conntrack_tftp 2329 1 nf_nat_tftp, Live 0xf9d3c000
nf_conntrack_sip 13445 1 nf_nat_sip, Live 0xf9d2e000
nf_conntrack_proto_sctp 4642 0 - Live 0xf9d1e000
nf_conntrack_pptp 3185 1 nf_nat_pptp, Live 0xf9d13000
nf_conntrack_proto_gre 2747 1 nf_conntrack_pptp, Live 0xf9d08000
nf_conntrack_netlink 11736 0 - Live 0xf9cfa000
nf_conntrack_netbios_ns 922 0 - Live 0xf9cec000
nf_conntrack_irc 2555 1 nf_nat_irc, Live 0xf9ce2000
nf_conntrack_h323 30728 1 nf_nat_h323, Live 0xf9ccd000
nf_conntrack_ftp 4333 1 nf_nat_ftp, Live 0xf9cb8000
xt_TPROXY 969 0 - Live 0xf9cad000
nf_tproxy_core 1241 1 xt_TPROXY,[permanent], Live 0xf9ca4000
xt_tcpmss 997 0 - Live 0xf9c9a000
xt_pkttype 675 0 - Live 0xf9c91000
xt_physdev 1220 0 - Live 0xf9c88000
xt_owner 739 0 - Live 0xf9c7f000
xt_NFQUEUE 1573 0 - Live 0xf9c76000
xt_NFLOG 710 0 - Live 0xf9c6c000
nfnetlink_log 5624 1 xt_NFLOG, Live 0xf9c62000
xt_multiport 1731 4 - Live 0xf9c56000
xt_MARK 609 1 - Live 0xf9c4c000
xt_mark 605 0 - Live 0xf9c43000
xt_mac 667 0 - Live 0xf9c3a000
xt_limit 1080 0 - Live 0xf9c31000
xt_length 776 0 - Live 0xf9c27000
xt_iprange 1029 0 - Live 0xf9c1e000
xt_helper 871 0 - Live 0xf9c15000
xt_hashlimit 6703 0 - Live 0xf9c0b000
xt_DSCP 1407 0 - Live 0xf9bff000
xt_dscp 1079 0 - Live 0xf9bf5000
xt_dccp 1487 0 - Live 0xf9bec000
xt_conntrack 1935 12 - Live 0xf9be2000
xt_CONNMARK 943 0 - Live 0xf9bd8000
xt_connmark 791 0 - Live 0xf9bcf000
xt_CLASSIFY 609 0 - Live 0xf9bc6000
ipt_LOG 3562 7 - Live 0xf9bbd000
xt_tcpudp 1675 29 - Live 0xf9bb3000
xt_state 911 0 - Live 0xf9ba9000
iptable_nat 2883 0 - Live 0xf9ba0000
nf_nat 10920 12
ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,nf_nat_tftp,nf_nat_sip,nf_nat_pptp,nf_nat_proto_gre,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,iptable_nat,
Live 0xf9b92000
nf_conntrack_ipv4 7585 15 iptable_nat,nf_nat, Live 0xf9b82000
nf_defrag_ipv4 839 2 xt_TPROXY,nf_conntrack_ipv4, Live 0xf9b75000
nf_conntrack 39080 31
xt_connlimit,ipt_MASQUERADE,ipt_CLUSTERIP,nf_nat_tftp,nf_nat_snmp_basic,nf_nat_sip,nf_nat_pptp,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_amanda,nf_conntrack_sane,nf_conntrack_tftp,nf_conntrack_sip,nf_conntrack_proto_sctp,nf_conntrack_pptp,nf_conntrack_proto_gre,nf_conntrack_netlink,nf_conntrack_netbios_ns,nf_conntrack_irc,nf_conntrack_h323,nf_conntrack_ftp,xt_helper,xt_conntrack,xt_CONNMARK,xt_connmark,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4,
Live 0xf9b5d000
iptable_mangle 1080 1 - Live 0xf9b41000
nfnetlink 2074 2 nf_conntrack_netlink,nfnetlink_log, Live 0xf9b37000
iptable_filter 964 1 - Live 0xf9b29000
ip_tables 7877 4
iptable_raw,iptable_nat,iptable_mangle,iptable_filter, Live 0xf9b1e000
x_tables 8703 47
xt_time,xt_connlimit,xt_realm,iptable_raw,xt_comment,xt_recent,xt_policy,ipt_ULOG,ipt_REJECT,ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,ipt_ECN,ipt_ecn,ipt_CLUSTERIP,ipt_ah,ipt_addrtype,xt_TPROXY,xt_tcpmss,xt_pkttype,xt_physdev,xt_owner,xt_NFQUEUE,xt_NFLOG,xt_multiport,xt_MARK,xt_mark,xt_mac,xt_limit,xt_length,xt_iprange,xt_helper,xt_hashlimit,xt_DSCP,xt_dscp,xt_dccp,xt_conntrack,xt_CONNMARK,xt_connmark,xt_CLASSIFY,ipt_LOG,xt_tcpudp,xt_state,iptable_nat,iptable_mangle,iptable_filter,ip_tables,
Live 0xf9b0d000
microcode 8215 0 - Live 0xf9016000
fuse 43972 1 - Live 0xf9002000
acpi_cpufreq 5139 1 - Live 0xf8f5c000
coretemp 3285 0 - Live 0xf8f50000
loop 9748 0 - Live 0xf8f42000
firewire_sbp2 9596 0 - Live 0xf8f31000
firewire_core 32799 1 firewire_sbp2, Live 0xf8f18000
crc_itu_t 1039 1 firewire_core, Live 0xf8f02000
dm_crypt 9148 0 - Live 0xf8e6d000
dm_mod 47360 1 dm_crypt, Live 0xf8e50000
snd_hda_codec_conexant 20241 1 - Live 0xf8ce2000
snd_hda_intel 16543 1 - Live 0xf8cab000
arc4 978 2 - Live 0xf8c99000
ecb 1409 2 - Live 0xf8c90000
snd_hda_codec 54225 2 snd_hda_codec_conexant,snd_hda_intel, Live 0xf8a6a000
i915 219529 3 - Live 0xf8a08000
snd_hwdep 4070 1 snd_hda_codec, Live 0xf8985000
snd_pcm_oss 28706 0 - Live 0xf8972000
snd_mixer_oss 10474 1 snd_pcm_oss, Live 0xf895d000
snd_pcm 47768 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf893f000
snd_seq_midi 3604 0 - Live 0xf8922000
drm_kms_helper 18209 1 i915, Live 0xf8911000
snd_rawmidi 12636 1 snd_seq_midi, Live 0xf88b6000
snd_seq_midi_event 3676 1 snd_seq_midi, Live 0xf88a6000
drm 113797 4 i915,drm_kms_helper, Live 0xf8873000
thinkpad_acpi 45561 0 - Live 0xf881c000
snd_seq 35397 3 snd_seq_midi,snd_seq_midi_event, Live 0xf878f000
i2c_algo_bit 3541 1 i915, Live 0xf8778000
snd_timer 12341 2 snd_pcm,snd_seq, Live 0xf871c000
snd_seq_device 3677 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf870d000
pcmcia 27272 0 - Live 0xf86ed000
joydev 6855 0 - Live 0xf86d9000
rfkill 10512 4 cfg80211,bluetooth,thinkpad_acpi, Live 0xf86c0000
tpm_tis 5500 0 - Live 0xf867e000
evdev 5657 34 - Live 0xf865e000
tpm 8113 1 tpm_tis, Live 0xf8620000
video 15177 1 i915, Live 0xf85f9000
tpm_bios 3561 1 tpm, Live 0xf85cb000
nvram 3953 2 thinkpad_acpi, Live 0xf85c0000
yenta_socket 16834 0 - Live 0xf85ad000
rsrc_nonstatic 6886 1 yenta_socket, Live 0xf859b000
pcmcia_core 8972 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xf858b000
i2c_i801 6506 0 - Live 0xf857b000
i2c_core 12610 5 i915,drm_kms_helper,drm,i2c_algo_bit,i2c_i801, Live 0xf856a000
snd 34771 15 snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_rawmidi,thinkpad_acpi,snd_seq,snd_timer,snd_seq_device,
Live 0xf854d000
soundcore 3626 1 snd, Live 0xf8533000
snd_page_alloc 5133 2 snd_hda_intel,snd_pcm, Live 0xf8527000
psmouse 39043 0 - Live 0xf850e000
processor 25241 3 acpi_cpufreq, Live 0xf84de000
button 3642 1 i915, Live 0xf84bf000
ac 1644 0 - Live 0xf84b4000
battery 4074 0 - Live 0xf84aa000
serio_raw 2912 0 - Live 0xf849f000
output 1200 1 video, Live 0xf8490000
ext3 93348 2 - Live 0xf846b000
jbd 32625 1 ext3, Live 0xf8435000
mbcache 3766 1 ext3, Live 0xf841e000
sg 16103 0 - Live 0xf8406000
sd_mod 26889 4 - Live 0xf83ee000
crc_t10dif 1016 1 sd_mod, Live 0xf83da000
sr_mod 10930 0 - Live 0xf83cf000
cdrom 26454 1 sr_mod, Live 0xf83ba000
ata_generic 1951 0 - Live 0xf83a8000
uhci_hcd 16157 0 - Live 0xf8399000
ata_piix 17348 3 - Live 0xf8385000
sdhci_pci 5146 0 - Live 0xf82fb000
libata 116217 2 ata_generic,ata_piix, Live 0xf8345000
sdhci 12099 1 sdhci_pci, Live 0xf82e8000
tg3 94906 0 - Live 0xf82c0000
mmc_core 39971 1 sdhci, Live 0xf828b000
led_class 1571 2 thinkpad_acpi,sdhci, Live 0xf8271000
libphy 11982 1 tg3, Live 0xf825f000
thermal 9533 0 - Live 0xf824c000
ehci_hcd 28211 0 - Live 0xf8237000
thermal_sys 9406 3 video,processor,thermal, Live 0xf817c000
scsi_mod 103057 5 firewire_sbp2,sg,sd_mod,sr_mod,libata, Live 0xf8202000
usbcore 101657 4 usbhid,uhci_hcd,ehci_hcd, Live 0xf8064000
nls_base 4529 1 usbcore, Live 0xf803f000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:1f.2
    0170-0177 : ata_piix
  01f0-01f7 : 0000:00:1f.2
    01f0-01f7 : ata_piix
  0376-0376 : 0000:00:1f.2
    0376-0376 : ata_piix
  03c0-03df : vga+
  03f6-03f6 : 0000:00:1f.2
    03f6-03f6 : ata_piix
  0800-080f : pnp 00:02
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-107f : 0000:00:1f.0
    1000-107f : pnp 00:02
      1000-1003 : ACPI PM1a_EVT_BLK
      1004-1005 : ACPI PM1a_CNT_BLK
      1008-100b : ACPI PM_TMR
      1010-1015 : ACPI CPU throttle
      1020-1020 : ACPI PM2_CNT_BLK
      1028-102f : ACPI GPE0_BLK
  1180-11bf : 0000:00:1f.0
    1180-11bf : pnp 00:02
  15e0-15ef : pnp 00:02
  1600-162f : hdaps
  164e-164f : pnp 00:02
  1800-1807 : 0000:00:02.0
  1820-183f : 0000:00:1a.0
    1820-183f : uhci_hcd
  1840-185f : 0000:00:1a.1
    1840-185f : uhci_hcd
  1860-187f : 0000:00:1d.0
    1860-187f : uhci_hcd
  1880-189f : 0000:00:1d.1
    1880-189f : uhci_hcd
  18a0-18bf : 0000:00:1d.2
    18a0-18bf : uhci_hcd
  18d0-18df : 0000:00:1f.2
  18e0-18ef : 0000:00:1f.2
    18e0-18ef : ata_piix
  1c00-1c1f : 0000:00:1f.3
    1c00-1c1f : i801_smbus
  2000-2fff : PCI Bus 0000:02
  3000-3fff : PCI Bus 0000:03
  4000-4fff : PCI Bus 0000:05
  5000-5fff : PCI Bus 0000:0d
  6000-9fff : PCI Bus 0000:15
    6000-60ff : PCI CardBus 0000:16
    6400-64ff : PCI CardBus 0000:16
  a000-afff : PCI Bus 0000:04
00000000-00000fff : reserved
00001000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cbfff : pnp 00:00
000cc000-000cffff : pnp 00:00
000d0000-000d19ff : Adapter ROM
000d2000-000d3fff : reserved
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-9f6affff : System RAM
  01000000-01276d82 : Kernel code
  01276d83-013bc3ff : Kernel data
  01420000-014cf9c3 : Kernel bss
9f6b0000-9f6cbfff : ACPI Tables
9f6cc000-9f6fffff : ACPI Non-volatile Storage
9f700000-9fffffff : reserved
a0000000-febfffff : PCI Bus 0000:00
  a0000000-a01fffff : PCI Bus 0000:04
  a0200000-a0200fff : Intel Flush Page
  a4000000-a7ffffff : PCI CardBus 0000:16
  d4000000-d5ffffff : PCI Bus 0000:0d
  d8000000-d9ffffff : PCI Bus 0000:05
  dc100000-df6fffff : PCI Bus 0000:03
    df6ff000-df6fffff : 0000:03:00.0
      df6ff000-df6fffff : iwl3945
  df800000-df8fffff : PCI Bus 0000:0d
  dfb00000-dfbfffff : PCI Bus 0000:05
  dfe00000-dfefffff : PCI Bus 0000:03
  e0000000-efffffff : 0000:00:02.0
  f0000000-f3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f0000000-f3ffffff : reserved
      f0000000-f3ffffff : pnp 00:02
  f4000000-f7ffffff : PCI Bus 0000:15
    f4000000-f7ffffff : PCI CardBus 0000:16
  f8000000-f80fffff : PCI Bus 0000:02
  f8100000-f81fffff : 0000:00:02.0
  f8200000-f82fffff : 0000:00:02.1
  f8300000-fbffffff : PCI Bus 0000:15
    f8300000-f8300fff : 0000:15:00.0
      f8300000-f8300fff : yenta_socket
    f8301000-f83010ff : 0000:15:00.2
      f8301000-f83010ff : mmc0
    f8301800-f83018ff : 0000:15:00.4
    f8301c00-f8301cff : 0000:15:00.5
  fc000000-fdffffff : PCI Bus 0000:02
  fe000000-fe0fffff : PCI Bus 0000:04
    fe000000-fe00ffff : 0000:04:00.0
      fe000000-fe00ffff : tg3
  fe100000-fe103fff : 0000:00:1b.0
    fe100000-fe103fff : ICH HD audio
  fe304000-fe3043ff : 0000:00:1a.7
    fe304000-fe3043ff : ehci_hcd
  fe304400-fe3047ff : 0000:00:1d.7
    fe304400-fe3047ff : ehci_hcd
  fe304800-fe3048ff : 0000:00:1f.3
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
  fed14000-fed17fff : pnp 00:02
  fed18000-fed18fff : pnp 00:02
  fed19000-fed19fff : pnp 00:02
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:02
  fed40000-fed4bfff : PCI Bus 0000:00
    fed45000-fed4bfff : pnp 00:02
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
Controller Hub (rev 0c)
	Subsystem: Lenovo T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0a <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile
GM965/GL960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA
controller])
	Subsystem: Lenovo T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 30
	Region 0: Memory at f8100000 (64-bit, non-prefetchable) [size=1M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41a9
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 0c)
	Subsystem: Lenovo T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f8200000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1820 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T60
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1840 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at fe304000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 03)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 29
	Region 0: Memory at fe100000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41c1
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
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
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fc000000-fdffffff
	Prefetchable memory behind bridge: 00000000f8000000-00000000f80fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4161
	Capabilities: [90] Subsystem: Lenovo ThinkPad T61
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: dc100000-df6fffff
	Prefetchable memory behind bridge: 00000000dfe00000-00000000dfefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4169
	Capabilities: [90] Subsystem: Lenovo ThinkPad T61
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 3 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fe000000-fe0fffff
	Prefetchable memory behind bridge: 00000000a0000000-00000000a01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #4, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4171
	Capabilities: [90] Subsystem: Lenovo ThinkPad T61
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=03 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 4 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: d8000000-d9ffffff
	Prefetchable memory behind bridge: 00000000dfb00000-00000000dfbfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4179
	Capabilities: [90] Subsystem: Lenovo ThinkPad T61
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=04 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 5 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: d4000000-d5ffffff
	Prefetchable memory behind bridge: 00000000df800000-00000000df8fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4181
	Capabilities: [90] Subsystem: Lenovo ThinkPad T61
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=05 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 1860 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 1880 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 18a0 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fe304400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
	I/O behind bridge: 00006000-00009fff
	Memory behind bridge: f8300000-fbffffff
	Prefetchable memory behind bridge: 00000000f4000000-00000000f7ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Lenovo ThinkPad T61

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface
Controller (rev 03)
	Subsystem: Lenovo Device 20a5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
SATA IDE Controller (rev 03) (prog-if 80 [Master])
	Subsystem: Lenovo Device 20a8
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 18e0 [size=16]
	Region 5: I/O ports at 18d0 [size=16]
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fe304800 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1c00 [size=32]
	Kernel driver in use: i801_smbus

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)
	Subsystem: Intel Corporation ThinkPad R60e/X60s
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 31
	Region 0: Memory at df6ff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41c9
	Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<128ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-1f-3c-ff-ff-4b-70-1f
	Kernel driver in use: iwl3945

04:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M
Gigabit Ethernet PCI Express (rev 02)
	Subsystem: Lenovo Device 20d5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 32
	Region 0: Memory at fe000000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
		Product Name: Broadcom NetXtreme Gigabit Ethernet Controller
		Read-only fields:
			[PN] Part number: BCM95751
			[EC] Engineering changes: 106679-15
			[SN] Serial number: 0123456789
			[MN] Manufacture ID: 31 34 65 34
			[RV] Reserved: checksum bad, 26 byte(s) reserved
		No end tag found
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [e8] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41d1
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<4us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-24-7e-ff-fe-6d-00-a3
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: tg3

15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
	Subsystem: Lenovo Device 20c6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f8300000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
	Memory window 0: f4000000-f7fff000 (prefetchable)
	Memory window 1: a4000000-a7fff000
	I/O window 0: 00006000-000060ff
	I/O window 1: 00006400-000064ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro
Host Adapter (rev 21)
	Subsystem: Lenovo Device 20c8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f8301000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: sdhci-pci

15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host
Adapter (rev 11)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f8301800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-

15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)
	Subsystem: Lenovo Device 20cb
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f8301c00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
