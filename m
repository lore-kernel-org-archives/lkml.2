Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab2CSO6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:58:22 -0400
Received: from win.srlabs.de ([46.4.89.15]:9407 "EHLO win.srlabs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2CSO6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:58:17 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 10:58:16 EDT
Message-ID: <4F6747FF.1060005@srlabs.de>
Date: Mon, 19 Mar 2012 15:51:43 +0100
From: Mate Soos <mate@srlabs.de>
Organization: Security Research Labs
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: PROBLEM: Kernel Oops when unplugging USB
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="------------ms090000060505060002060309"
X-Originating-IP: [77.188.77.50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------ms090000060505060002060309
Content-Type: multipart/mixed;
 boundary="------------000100000006000905080509"

This is a multi-part message in MIME format.
--------------000100000006000905080509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I had a kernel oops, so I thought I might report it.

[1.] One line summary of the problem
See 'messages' for the actual kernel oops messages.

[2.] Full description of the problem/report:
The kernel oops-ed when I pulled out an umounted 8GB USB key. This seems
to be visible in the "messages" file. All the data attached, except for
the "messages" has been produced after a reboot, since the system
hanged. Luckily, the "messages" got saved. The system after restart
should have exactly the same modules loaded as before.

[3.] Keywords (i.e., modules, networking, kernel):
USB, Kernel Ooops, Watchdog

[4.] Kernel version (from /proc/version):
$ cat
 /proc/version
Linux version 3.2.0-1-amd64 (Debian 3.2.4-1) (waldi@debian.org) (gcc
version 4.6.2 (Debian 4.6.2-12) ) #1 SMP Sun Feb 5 15:17:15 UTC 2012

It's from Debian squeeze, debian package version "linux-image-3.2.0-1-amd=
64"

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
In the "messages" text file you will find these.

[6.] A small shell script or example program which triggers the
     problem (if possible)
Unfortunately, I can't reproduce.

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
Attached.

[7.2.] Processor information (from /proc/cpuinfo):
Attached.

[7.3.] Module information (from /proc/modules):
Attached.

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem=
)
Both attached.

[7.5.] PCI information ('lspci -vvv' as root)
Attached.

[7.6.] SCSI information (from /proc/scsi/scsi)
bash: /proc/scsi/scsi: No such file or directory

I hope this helps in triaging and/or resolving this bug!

Thanks,

Mate

--=20
Mate Soos
Security Research Labs
http://www.srlabs.de

--------------000100000006000905080509
Content-Type: text/plain;
 name="cpuinfo"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="cpuinfo"

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp=
 lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts=
c aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm s=
se4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid=

bogomips	: 6147.41
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp=
 lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts=
c aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm s=
se4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid=

bogomips	: 6146.93
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp=
 lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts=
c aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm s=
se4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid=

bogomips	: 6126.44
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 6
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp=
 lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts=
c aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm s=
se4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid=

bogomips	: 6146.94
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 4
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp=
 lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts=
c aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm s=
se4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid=

bogomips	: 6286.35
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 5
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp=
 lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts=
c aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm s=
se4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid=

bogomips	: 6146.93
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 6
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 5
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp=
 lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts=
c aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm s=
se4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid=

bogomips	: 5999.24
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 7
initial apicid	: 7
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp=
 lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts=
c aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm s=
se4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid=

bogomips	: 6146.95
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


--------------000100000006000905080509
Content-Type: text/plain;
 name="modules"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="modules"

ip6table_filter 12540 0 - Live 0xffffffffa08d9000
ip6_tables 22175 1 ip6table_filter, Live 0xffffffffa08ce000
ebtable_nat 12580 0 - Live 0xffffffffa08c9000
ebtables 26235 1 ebtable_nat, Live 0xffffffffa08bd000
ipt_MASQUERADE 12594 3 - Live 0xffffffffa08b3000
iptable_nat 12928 1 - Live 0xffffffffa08b8000
nf_nat 18242 2 ipt_MASQUERADE,iptable_nat, Live 0xffffffffa08ad000
nf_conntrack_ipv4 14078 4 iptable_nat,nf_nat, Live 0xffffffffa089e000
nf_defrag_ipv4 12483 1 nf_conntrack_ipv4, Live 0xffffffffa0899000
xt_state 12503 1 - Live 0xffffffffa08a4000
nf_conntrack 52720 5 ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4,=
xt_state, Live 0xffffffffa088b000
ipt_REJECT 12502 2 - Live 0xffffffffa0886000
xt_CHECKSUM 12471 1 - Live 0xffffffffa0881000
iptable_mangle 12536 1 - Live 0xffffffffa087c000
xt_tcpudp 12570 5 - Live 0xffffffffa0877000
iptable_filter 12536 1 - Live 0xffffffffa0872000
ip_tables 22042 3 iptable_nat,iptable_mangle,iptable_filter, Live 0xfffff=
fffa0863000
x_tables 19073 12 ip6table_filter,ip6_tables,ebtables,ipt_MASQUERADE,ipta=
ble_nat,xt_state,ipt_REJECT,xt_CHECKSUM,iptable_mangle,xt_tcpudp,iptable_=
filter,ip_tables, Live 0xffffffffa086c000
bridge 70728 0 - Live 0xffffffffa0850000
stp 12392 1 bridge, Live 0xffffffffa083a000
parport_pc 22364 0 - Live 0xffffffffa0849000
ppdev 12763 0 - Live 0xffffffffa0801000
lp 17149 0 - Live 0xffffffffa0834000
parport 31858 3 parport_pc,ppdev,lp, Live 0xffffffffa0840000
rfcomm 33656 0 - Live 0xffffffffa082a000
bnep 17567 2 - Live 0xffffffffa07f6000
acpi_cpufreq 12935 1 - Live 0xffffffffa07fc000
bluetooth 119406 10 rfcomm,bnep, Live 0xffffffffa080b000
mperf 12453 1 acpi_cpufreq, Live 0xffffffffa0806000
rfkill 19012 2 bluetooth, Live 0xffffffffa07f0000
cpufreq_userspace 12576 0 - Live 0xffffffffa07eb000
cpufreq_powersave 12454 0 - Live 0xffffffffa07ad000
cpufreq_stats 12866 0 - Live 0xffffffffa0734000
cpufreq_conservative 13147 0 - Live 0xffffffffa0690000
binfmt_misc 12957 1 - Live 0xffffffffa068b000
uinput 17440 1 - Live 0xffffffffa0701000
fuse 61981 1 - Live 0xffffffffa079c000
nfsd 211858 2 - Live 0xffffffffa07b6000
nfs 312062 0 - Live 0xffffffffa074e000
lockd 67328 2 nfsd,nfs, Live 0xffffffffa073c000
fscache 36739 1 nfs, Live 0xffffffffa06f7000
auth_rpcgss 37143 2 nfsd,nfs, Live 0xffffffffa06ec000
nfs_acl 12511 2 nfsd,nfs, Live 0xffffffffa02cb000
sunrpc 173671 6 nfsd,nfs,lockd,auth_rpcgss,nfs_acl, Live 0xffffffffa07080=
00
ext4 350557 1 - Live 0xffffffffa0695000
jbd2 62015 1 ext4, Live 0xffffffffa067a000
crc16 12343 2 bluetooth,ext4, Live 0xffffffffa0642000
hwmon_vid 12430 0 - Live 0xffffffffa02a2000
coretemp 12898 0 - Live 0xffffffffa022c000
loop 22641 0 - Live 0xffffffffa029b000
firewire_sbp2 17993 0 - Live 0xffffffffa026e000
sha256_generic 16797 2 - Live 0xffffffffa0231000
cryptd 14517 0 - Live 0xffffffffa020c000
aes_x86_64 16796 32 - Live 0xffffffffa01b1000
aes_generic 33026 1 aes_x86_64, Live 0xffffffffa0222000
cbc 12754 16 - Live 0xffffffffa0159000
dm_crypt 22586 1 - Live 0xffffffffa021b000
kvm_intel 121968 0 - Live 0xffffffffa0623000
kvm 287572 1 kvm_intel, Live 0xffffffffa05db000
snd_hda_codec_hdmi 30783 0 - Live 0xffffffffa0212000
joydev 17266 0 - Live 0xffffffffa01ea000
snd_hda_codec_realtek 188599 1 - Live 0xffffffffa064a000
fglrx 3150987 355 - Live 0xffffffffa02d8000 (P)
snd_pcm_oss 41081 0 - Live 0xffffffffa01d6000
snd_hda_intel 26345 4 - Live 0xffffffffa01a9000
snd_mixer_oss 17916 1 snd_pcm_oss, Live 0xffffffffa0132000
snd_hda_codec 77994 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_in=
tel, Live 0xffffffffa01f7000
snd_hwdep 13186 1 snd_hda_codec, Live 0xffffffffa007e000
snd_pcm 63900 5 snd_hda_codec_hdmi,snd_pcm_oss,snd_hda_intel,snd_hda_code=
c, Live 0xffffffffa01c5000
snd_seq_midi 12848 0 - Live 0xffffffffa0108000
snd_rawmidi 23060 1 snd_seq_midi, Live 0xffffffffa0177000
snd_seq_midi_event 13316 1 snd_seq_midi, Live 0xffffffffa005f000
snd_seq 45093 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa01b8000
snd_timer 22917 3 snd_pcm,snd_seq, Live 0xffffffffa014a000
evdev 17562 11 - Live 0xffffffffa02c5000
mxm_wmi 12473 0 - Live 0xffffffffa02d3000
snd_seq_device 13176 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffa=
02c0000
psmouse 64455 0 - Live 0xffffffffa02af000
serio_raw 12931 0 - Live 0xffffffffa02aa000
snd 52850 18 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_pcm_oss,snd_hda=
_intel,snd_mixer_oss,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,=
snd_timer,snd_seq_device, Live 0xffffffffa028d000
pcspkr 12579 0 - Live 0xffffffffa027e000
i2c_i801 16870 0 - Live 0xffffffffa0287000
soundcore 13065 1 snd, Live 0xffffffffa0269000
i2c_core 23876 1 i2c_i801, Live 0xffffffffa0262000
iTCO_wdt 17081 0 - Live 0xffffffffa0274000
snd_page_alloc 13003 2 snd_hda_intel,snd_pcm, Live 0xffffffffa025d000
iTCO_vendor_support 12704 1 iTCO_wdt, Live 0xffffffffa024e000
i7core_edac 22454 0 - Live 0xffffffffa0256000
edac_core 35258 3 i7core_edac, Live 0xffffffffa0244000
asus_atk0110 17297 0 - Live 0xffffffffa023a000
wmi 13243 1 mxm_wmi, Live 0xffffffffa01f2000
button 12937 1 fglrx, Live 0xffffffffa008f000
processor 28059 1 acpi_cpufreq, Live 0xffffffffa01e2000
thermal_sys 18040 1 processor, Live 0xffffffffa0065000
ext3 161867 1 - Live 0xffffffffa0180000
jbd 56902 1 ext3, Live 0xffffffffa0168000
mbcache 13065 2 ext4,ext3, Live 0xffffffffa005a000
dm_mod 63545 3 dm_crypt, Live 0xffffffffa00f7000
sr_mod 21899 0 - Live 0xffffffffa0053000
sd_mod 36136 5 - Live 0xffffffffa00ed000
cdrom 35401 1 sr_mod, Live 0xffffffffa0049000
usbhid 36379 0 - Live 0xffffffffa00e3000
hid 81288 1 usbhid, Live 0xffffffffa00ce000
crc_t10dif 12348 1 sd_mod, Live 0xffffffffa0042000
uhci_hcd 26865 0 - Live 0xffffffffa0036000
firewire_ohci 35772 0 - Live 0xffffffffa015e000
ahci 24997 4 - Live 0xffffffffa0151000
firewire_core 48407 2 firewire_sbp2,firewire_ohci, Live 0xffffffffa013d00=
0
r8169 46980 0 - Live 0xffffffffa00c1000
crc_itu_t 12347 1 firewire_core, Live 0xffffffffa0138000
libahci 22860 1 ahci, Live 0xffffffffa002f000
mii 12675 1 r8169, Live 0xffffffffa0028000
libata 140589 2 ahci,libahci, Live 0xffffffffa010e000
scsi_mod 162417 4 firewire_sbp2,sr_mod,sd_mod,libata, Live 0xffffffffa009=
4000
ehci_hcd 40215 0 - Live 0xffffffffa0084000
xhci_hcd 73208 0 - Live 0xffffffffa006b000
usbcore 128498 5 usbhid,uhci_hcd,ehci_hcd,xhci_hcd, Live 0xffffffffa00070=
00
usb_common 12354 1 usbcore, Live 0xffffffffa0000000

--------------000100000006000905080509
Content-Type: text/plain;
 name="ioports"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ioports"

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
  0290-029f : pnp 00:06
  03c0-03df : vga+
  03f8-03ff : serial
  04d0-04d1 : pnp 00:07
  0500-057f : pnp 00:07
  0600-0607 : pnp 00:07
  0800-087f : pnp 00:07
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-082f : ACPI GPE0_BLK
    0830-0833 : iTCO_wdt
    0850-0850 : ACPI PM2_CNT_BLK
    0860-087f : iTCO_wdt
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-101f : 0000:00:1f.3
  2000-2fff : PCI Bus 0000:06
  a400-a41f : 0000:00:1f.2
    a400-a41f : ahci
  a480-a483 : 0000:00:1f.2
    a480-a483 : ahci
  a800-a807 : 0000:00:1f.2
    a800-a807 : ahci
  a880-a883 : 0000:00:1f.2
    a880-a883 : ahci
  ac00-ac07 : 0000:00:1f.2
    ac00-ac07 : ahci
  b080-b09f : 0000:00:1d.0
    b080-b09f : uhci_hcd
  b400-b41f : 0000:00:1d.1
    b400-b41f : uhci_hcd
  b480-b49f : 0000:00:1d.2
    b480-b49f : uhci_hcd
  b800-b81f : 0000:00:1a.0
    b800-b81f : uhci_hcd
  b880-b89f : 0000:00:1a.1
    b880-b89f : uhci_hcd
  bc00-bc1f : 0000:00:1a.2
    bc00-bc1f : uhci_hcd
  c000-cfff : PCI Bus 0000:03
    c000-c0ff : 0000:03:00.0
  d000-dfff : PCI Bus 0000:05
    d400-d40f : 0000:05:00.0
      d400-d40f : ahci
    d480-d483 : 0000:05:00.0
      d480-d483 : ahci
    d800-d807 : 0000:05:00.0
      d800-d807 : ahci
    d880-d883 : 0000:05:00.0
      d880-d883 : ahci
    dc00-dc07 : 0000:05:00.0
      dc00-dc07 : ahci
  e000-efff : PCI Bus 0000:07
    e800-e8ff : 0000:07:01.0
      e800-e8ff : r8169
    ec00-ec7f : 0000:07:02.0

--------------000100000006000905080509
Content-Type: text/plain;
 name="iomem"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="iomem"

00000000-0000ffff : reserved
00010000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cffff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
000e2c00-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-bf77ffff : System RAM
  01000000-0134a005 : Kernel code
  0134a006-0169277f : Kernel data
  01725000-01803fff : Kernel bss
bf780000-bf797fff : ACPI Tables
bf798000-bf7d9fff : ACPI Non-volatile Storage
bf7da000-bfffffff : reserved
c0000000-dfffffff : PCI Bus 0000:00
  c0000000-c02fffff : PCI Bus 0000:05
    c0000000-c000ffff : 0000:05:00.0
  c0300000-c06fffff : PCI Bus 0000:06
  d0000000-dfffffff : PCI Bus 0000:03
    d0000000-dfffffff : 0000:03:00.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:0d
f0000000-fed8ffff : PCI Bus 0000:00
  faf00000-faffffff : PCI Bus 0000:06
  fbaf8000-fbafbfff : 0000:00:1b.0
    fbaf8000-fbafbfff : ICH HD audio
  fbafc000-fbafc7ff : 0000:00:1f.2
    fbafc000-fbafc7ff : ahci
  fbafd000-fbafd0ff : 0000:00:1f.3
  fbafe000-fbafe3ff : 0000:00:1d.7
    fbafe000-fbafe3ff : ehci_hcd
  fbaff000-fbaff3ff : 0000:00:1a.7
    fbaff000-fbaff3ff : ehci_hcd
  fbb00000-fbbfffff : PCI Bus 0000:02
    fbbfe000-fbbfffff : 0000:02:00.0
      fbbfe000-fbbfffff : xhci_hcd
  fbc00000-fbcfffff : PCI Bus 0000:03
    fbc80000-fbcbffff : 0000:03:00.0
    fbcc0000-fbcdffff : 0000:03:00.0
    fbcfc000-fbcfffff : 0000:03:00.1
  fbd00000-fbdfffff : PCI Bus 0000:05
    fbdffc00-fbdffdff : 0000:05:00.0
      fbdffc00-fbdffdff : ahci
  fbe00000-fbefffff : PCI Bus 0000:07
    fbec0000-fbedffff : 0000:07:01.0
    fbefe000-fbefe7ff : 0000:07:02.0
      fbefe000-fbefe7ff : firewire_ohci
    fbeffc00-fbeffcff : 0000:07:01.0
      fbeffc00-fbeffcff : r8169
  fbf00000-fbffffff : pnp 00:01
  fc000000-fcffffff : pnp 00:01
  fd000000-fdffffff : pnp 00:01
  fe000000-febfffff : pnp 00:01
  fec00000-fec003ff : IOAPIC 0
  fec8a000-fec8a3ff : IOAPIC 1
  fed00000-fed003ff : HPET 0
  fed10000-fed10fff : pnp 00:01
  fed1c000-fed1ffff : pnp 00:07
  fed20000-fed3ffff : pnp 00:07
  fed40000-fed8ffff : pnp 00:07
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:0b
ffc00000-ffdfffff : pnp 00:0a
ffe00000-ffffffff : reserved
100000000-63fffffff : System RAM

--------------000100000006000905080509
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="lspci"

00:00.0 Host bridge: Intel Corporation 5520/5500/X58 I/O Hub to ESI Port =
(rev 13)
	Subsystem: ASUSTeK Computer Inc. Device 836b
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [60] MSI: Enable- Count=3D1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512n=
s, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgm=
t- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Select=
able De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCt=
rl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCt=
rl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=3D0002 Rev=3D0 Le=
n=3D00c <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express R=
oot Port 1 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 836b
	Capabilities: [60] MSI: Enable- Count=3D1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x2, ASPM L0s L1, Latency L0 <512ns,=
 L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectab=
le De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCt=
rl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCt=
rl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=3D0002 Rev=3D0 Le=
n=3D00c <?>
	Kernel driver in use: pcieport

00:02.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express R=
oot Port 2 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fbb00000-fbbfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 836b
	Capabilities: [60] MSI: Enable- Count=3D1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x2, ASPM L0s L1, Latency L0 <512ns,=
 L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+=
 ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectab=
le De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCt=
rl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCt=
rl- DirectTrans-
	Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express R=
oot Port 3 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fbc00000-fbcfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 836b
	Capabilities: [60] MSI: Enable- Count=3D1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns=
, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMg=
mt+ ABWMgmt+
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #2, PowerLimit 75.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectab=
le De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCt=
rl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCt=
rl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=3D0002 Rev=3D0 Le=
n=3D00c <?>
	Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express R=
oot Port 7 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 836b
	Capabilities: [60] MSI: Enable- Count=3D1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns=
, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #5, PowerLimit 25.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectab=
le De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCt=
rl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCt=
rl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=3D0002 Rev=3D0 Le=
n=3D00c <?>
	Kernel driver in use: pcieport

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management Re=
gisters (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimite=
d, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Select=
able De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Kernel driver in use: i7core_edac

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad=
 Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimite=
d, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Select=
able De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and R=
AS Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimite=
d, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Select=
able De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (=
rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-

00:1a.0 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #4 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at b800 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #5 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at b880 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.2 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #6 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at bc00 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHC=
I Controller #2 (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbaff000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D=
3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio C=
ontroller
	Subsystem: ASUSTeK Computer Inc. Device 8436
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 75
	Region 0: Memory at fbaf8000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+,D3=
cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee00000  Data: 402a
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64n=
s, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgm=
t- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D1 ArbSelect=3DFixed TC/VC=3D80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=3D0f ComponentID=3D00 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D00 AssocRCRB- LinkType=3D=
MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express =
Root Port 1 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D06, subordinate=3D06, sec-latency=3D0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: c0300000-c06fffff
	Prefetchable memory behind bridge: 00000000faf00000-00000000faffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <256n=
s, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee00000  Data: 4041
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8436
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=3D01 ComponentID=3D00 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D00 AssocRCRB- LinkType=3D=
MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express =
Root Port 5 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000c02fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256n=
s, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgm=
t- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee00000  Data: 4049
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 8436
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=3D05 ComponentID=3D00 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D00 AssocRCRB- LinkType=3D=
MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #1 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at b080 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #2 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at b400 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #3 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at b480 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHC=
I Controller #1 (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbafe000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D=
3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if =
01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=3D00, secondary=3D07, subordinate=3D07, sec-latency=3D32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 82d4

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Con=
troller
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AH=
CI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 74
	Region 0: I/O ports at ac00 [size=3D8]
	Region 1: I/O ports at a880 [size=3D4]
	Region 2: I/O ports at a800 [size=3D8]
	Region 3: I/O ports at a480 [size=3D4]
	Region 4: I/O ports at a400 [size=3D32]
	Region 5: Memory at fbafc000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [80] MSI: Enable+ Count=3D1/16 Maskable- 64bit-
		Address: fee00000  Data: 40b9
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: ASUSTeK Computer Inc. Device 82d4
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbafd000 (64-bit, non-prefetchable) [size=3D256]
	Region 4: I/O ports at 1000 [size=3D32]

02:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller=
 (rev 03) (prog-if 30 [XHCI])
	Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 29
	Region 0: Memory at fbbfe000 (64-bit, non-prefetchable) [size=3D8K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D=
3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [70] MSI: Enable- Count=3D1/8 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [90] MSI-X: Enable+ Count=3D8 Masked-
		Vector table: BAR=3D0 offset=3D00001000
		PBA: BAR=3D0 offset=3D00001080
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 un=
limited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L=
1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectab=
le De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP+ BadDLLP+ Rollover- Timeout+ NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
	Capabilities: [150 v1] Latency Tolerance Reporting
		Max snoop latency: 0ns
		Max no snoop latency: 0ns
	Kernel driver in use: xhci_hcd

03:00.0 VGA compatible controller: ATI Technologies Inc Tahiti PRO [Radeo=
n HD 7950] (prog-if 00 [VGA controller])
	Subsystem: Hightech Information System Ltd. Device 2316
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 76
	Region 0: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
	Region 2: Memory at fbc80000 (64-bit, non-prefetchable) [size=3D256K]
	Region 4: I/O ports at c000 [size=3D256]
	Expansion ROM at fbcc0000 [disabled] [size=3D128K]
	Capabilities: [48] Vendor Specific Information: Len=3D08 <?>
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1+,D2+,D3hot+,D3c=
old-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimit=
ed
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x16, ASPM L0s L1, Latency L0 <64n=
s, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMg=
mt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: Unknown, EnterCompliance- SpeedDis-, Select=
able De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee00000  Data: 405a
	Capabilities: [100 v1] Vendor Specific Information: ID=3D0001 Rev=3D1 Le=
n=3D010 <?>
	Capabilities: [150 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [270 v1] #19
	Capabilities: [2b0 v1] Address Translation Service (ATS)
		ATSCap:	Invalidate Queue Depth: 00
		ATSCtl:	Enable-, Smallest Translation Unit: 00
	Capabilities: [2c0 v1] #13
	Capabilities: [2d0 v1] #1b
	Kernel driver in use: fglrx_pci

03:00.1 Audio device: ATI Technologies Inc Device aaa0
	Subsystem: Hightech Information System Ltd. Device aaa0
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 34
	Region 0: Memory at fbcfc000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [48] Vendor Specific Information: Len=3D08 <?>
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimit=
ed
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x16, ASPM L0s L1, Latency L0 <64n=
s, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMg=
mt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Select=
able De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Com=
plianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee00000  Data: 4052
	Capabilities: [100 v1] Vendor Specific Information: ID=3D0001 Rev=3D1 Le=
n=3D010 <?>
	Capabilities: [150 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-

05:00.0 SATA controller: JMicron Technology Corp. JMB362 AHCI Controller =
(rev 10) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at dc00 [size=3D8]
	Region 1: I/O ports at d880 [size=3D4]
	Region 2: I/O ports at d800 [size=3D8]
	Region 3: I/O ports at d480 [size=3D4]
	Region 4: I/O ports at d400 [size=3D16]
	Region 5: Memory at fbdffc00 (32-bit, non-prefetchable) [size=3D512]
	[virtual] Expansion ROM at c0000000 [disabled] [size=3D64K]
	Capabilities: [8c] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3c=
old-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us,=
 L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
	Kernel driver in use: ahci

07:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8=
169SC Gigabit Ethernet (rev 10)
	Subsystem: ASUSTeK Computer Inc. Device 820d
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at e800 [size=3D256]
	Region 1: Memory at fbeffc00 (32-bit, non-prefetchable) [size=3D256]
	Expansion ROM at fbec0000 [disabled] [size=3D128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0-,D1+,D2+,D3hot+,D=
3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] Vital Product Data
		Unknown small resource type 05, will not decode more.
	Kernel driver in use: r8169

07:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(=
M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. M4A series motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns max), Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fbefe000 (32-bit, non-prefetchable) [size=3D2K]
	Region 1: I/O ports at ec00 [size=3D128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: firewire_ohci

ff:00.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath Archit=
ecture Generic Non-Core Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:00.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath Archit=
ecture System Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 0 (rev =
05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 0 (=
rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Target Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.4 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Test Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 0 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 0 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 0 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 0 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 1 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 1 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 1 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 1 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 2 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 2 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 2 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memor=
y Controller Channel 2 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0


--------------000100000006000905080509
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="messages"

Mar 18 07:35:12 sleepy rsyslogd: [origin software=3D"rsyslogd" swVersion=3D=
"5.8.6" x-pid=3D"1581" x-info=3D"http://www.rsyslog.com"] rsyslogd was HU=
Ped
Mar 19 07:35:11 sleepy rsyslogd: [origin software=3D"rsyslogd" swVersion=3D=
"5.8.6" x-pid=3D"1581" x-info=3D"http://www.rsyslog.com"] rsyslogd was HU=
Ped
Mar 19 13:12:03 sleepy kernel: [165730.492578] usb 2-6.3: new high-speed =
USB device number 9 using ehci_hcd
Mar 19 13:12:03 sleepy kernel: [165730.723814] usb 2-6.3: New USB device =
found, idVendor=3D058f, idProduct=3D6387
Mar 19 13:12:03 sleepy kernel: [165730.723819] usb 2-6.3: New USB device =
strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Mar 19 13:12:03 sleepy kernel: [165730.723822] usb 2-6.3: Product: Rainbo=
w Line
Mar 19 13:12:03 sleepy kernel: [165730.723825] usb 2-6.3: Manufacturer: I=
ntenso
Mar 19 13:12:03 sleepy kernel: [165730.723827] usb 2-6.3: SerialNumber: 9=
1AE60EF
Mar 19 13:12:03 sleepy mtp-probe: checking bus 2, device 9: "/sys/devices=
/pci0000:00/0000:00:1d.7/usb2/2-6/2-6.3"
Mar 19 13:12:04 sleepy mtp-probe: bus: 2, device: 9 was not an MTP device=

Mar 19 13:12:04 sleepy kernel: [165731.029165] usbcore: registered new in=
terface driver uas
Mar 19 13:12:04 sleepy kernel: [165731.032558] Initializing USB Mass Stor=
age driver...
Mar 19 13:12:04 sleepy kernel: [165731.032653] scsi8 : usb-storage 2-6.3:=
1.0
Mar 19 13:12:04 sleepy kernel: [165731.032774] usbcore: registered new in=
terface driver usb-storage
Mar 19 13:12:04 sleepy kernel: [165731.032776] USB Mass Storage support r=
egistered.
Mar 19 13:12:05 sleepy kernel: [165732.034022] scsi 8:0:0:0: Direct-Acces=
s     Intenso  Rainbow Line     8.07 PQ: 0 ANSI: 2
Mar 19 13:12:05 sleepy kernel: [165732.036372] sd 8:0:0:0: [sdd] 32849920=
 512-byte logical blocks: (16.8 GB/15.6 GiB)
Mar 19 13:12:05 sleepy kernel: [165732.036835] sd 8:0:0:0: [sdd] Write Pr=
otect is off
Mar 19 13:12:05 sleepy kernel: [165732.500273]  sdd: sdd1
Mar 19 13:12:05 sleepy kernel: [165732.503155] sd 8:0:0:0: [sdd] Attached=
 SCSI removable disk
Mar 19 13:12:09 sleepy kernel: [165736.458779] FAT-fs (sdd1): utf8 is not=
 a recommended IO charset for FAT filesystems, filesystem will be case se=
nsitive!
Mar 19 13:12:37 sleepy kernel: [165764.560733] sdd: detected capacity cha=
nge from 16819159040 to 0
Mar 19 13:12:40 sleepy kernel: [165767.141142] usb 2-6.3: USB disconnect,=
 device number 9
Mar 19 13:25:59 sleepy kernel: [166566.197373] usb 2-6.3: new high-speed =
USB device number 10 using ehci_hcd
Mar 19 13:25:59 sleepy kernel: [166566.395023] usb 2-6.3: New USB device =
found, idVendor=3D090c, idProduct=3D1000
Mar 19 13:25:59 sleepy kernel: [166566.395028] usb 2-6.3: New USB device =
strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Mar 19 13:25:59 sleepy kernel: [166566.395031] usb 2-6.3: Product: USB Fl=
ash Disk
Mar 19 13:25:59 sleepy kernel: [166566.395034] usb 2-6.3: Manufacturer: G=
eneral
Mar 19 13:25:59 sleepy kernel: [166566.395036] usb 2-6.3: SerialNumber: E=
F00000000000686
Mar 19 13:25:59 sleepy kernel: [166566.395587] scsi9 : usb-storage 2-6.3:=
1.0
Mar 19 13:25:59 sleepy mtp-probe: checking bus 2, device 10: "/sys/device=
s/pci0000:00/0000:00:1d.7/usb2/2-6/2-6.3"
Mar 19 13:26:00 sleepy mtp-probe: bus: 2, device: 10 was not an MTP devic=
e
Mar 19 13:26:00 sleepy kernel: [166567.564949] scsi 9:0:0:0: Direct-Acces=
s     General  USB Flash Disk   1100 PQ: 0 ANSI: 0 CCS
Mar 19 13:26:00 sleepy kernel: [166567.567383] sd 9:0:0:0: [sdd] 15851520=
 512-byte logical blocks: (8.11 GB/7.55 GiB)
Mar 19 13:26:00 sleepy kernel: [166567.568019] sd 9:0:0:0: [sdd] Write Pr=
otect is off
Mar 19 13:26:00 sleepy kernel: [166567.572261]  sdd: sdd1
Mar 19 13:26:00 sleepy kernel: [166567.574735] sd 9:0:0:0: [sdd] Attached=
 SCSI removable disk
Mar 19 13:26:04 sleepy kernel: [166571.385225] FAT-fs (sdd1): utf8 is not=
 a recommended IO charset for FAT filesystems, filesystem will be case se=
nsitive!
Mar 19 13:27:58 sleepy kernel: [166685.495151] usb 2-6.3: USB disconnect,=
 device number 10
Mar 19 13:28:00 sleepy kernel: [166687.484632] usb 2-6.3: new high-speed =
USB device number 11 using ehci_hcd
Mar 19 13:28:01 sleepy kernel: [166687.682409] usb 2-6.3: New USB device =
found, idVendor=3D090c, idProduct=3D1000
Mar 19 13:28:01 sleepy kernel: [166687.682414] usb 2-6.3: New USB device =
strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Mar 19 13:28:01 sleepy kernel: [166687.682417] usb 2-6.3: Product: USB Fl=
ash Disk
Mar 19 13:28:01 sleepy kernel: [166687.682420] usb 2-6.3: Manufacturer: G=
eneral
Mar 19 13:28:01 sleepy kernel: [166687.682422] usb 2-6.3: SerialNumber: E=
F00000000000686
Mar 19 13:28:01 sleepy kernel: [166687.683118] scsi10 : usb-storage 2-6.3=
:1.0
Mar 19 13:28:01 sleepy mtp-probe: checking bus 2, device 11: "/sys/device=
s/pci0000:00/0000:00:1d.7/usb2/2-6/2-6.3"
Mar 19 13:28:01 sleepy mtp-probe: bus: 2, device: 11 was not an MTP devic=
e
Mar 19 13:28:02 sleepy kernel: [166688.845934] scsi 10:0:0:0: Direct-Acce=
ss     General  USB Flash Disk   1100 PQ: 0 ANSI: 0 CCS
Mar 19 13:28:02 sleepy kernel: [166688.848114] sd 10:0:0:0: [sdd] 1585152=
0 512-byte logical blocks: (8.11 GB/7.55 GiB)
Mar 19 13:28:02 sleepy kernel: [166688.848866] sd 10:0:0:0: [sdd] Write P=
rotect is off
Mar 19 13:28:02 sleepy kernel: [166688.853240]  sdd: sdd1
Mar 19 13:28:02 sleepy kernel: [166688.855734] sd 10:0:0:0: [sdd] Attache=
d SCSI removable disk
Mar 19 13:28:05 sleepy kernel: [166692.258141] FAT-fs (sdd1): utf8 is not=
 a recommended IO charset for FAT filesystems, filesystem will be case se=
nsitive!
Mar 19 13:28:26 sleepy kernel: [166712.987283] sdd: detected capacity cha=
nge from 8115978240 to 0
Mar 19 13:28:30 sleepy kernel: [166716.712665] usb 2-6.3: USB disconnect,=
 device number 11
Mar 19 13:45:45 sleepy kernel: [167751.690495] usb 2-6.4: new high-speed =
USB device number 12 using ehci_hcd
Mar 19 13:45:45 sleepy kernel: [167751.888244] usb 2-6.4: New USB device =
found, idVendor=3D090c, idProduct=3D1000
Mar 19 13:45:45 sleepy kernel: [167751.888249] usb 2-6.4: New USB device =
strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Mar 19 13:45:45 sleepy kernel: [167751.888252] usb 2-6.4: Product: USB Fl=
ash Disk
Mar 19 13:45:45 sleepy kernel: [167751.888255] usb 2-6.4: Manufacturer: G=
eneral
Mar 19 13:45:45 sleepy kernel: [167751.888257] usb 2-6.4: SerialNumber: E=
F00000000000686
Mar 19 13:45:45 sleepy kernel: [167751.889031] scsi11 : usb-storage 2-6.4=
:1.0
Mar 19 13:45:45 sleepy mtp-probe: checking bus 2, device 12: "/sys/device=
s/pci0000:00/0000:00:1d.7/usb2/2-6/2-6.4"
Mar 19 13:45:46 sleepy mtp-probe: bus: 2, device: 12 was not an MTP devic=
e
Mar 19 13:45:47 sleepy kernel: [167753.068879] scsi 11:0:0:0: Direct-Acce=
ss     General  USB Flash Disk   1100 PQ: 0 ANSI: 0 CCS
Mar 19 13:45:47 sleepy kernel: [167753.070657] sd 11:0:0:0: [sdd] 1585152=
0 512-byte logical blocks: (8.11 GB/7.55 GiB)
Mar 19 13:45:47 sleepy kernel: [167753.071336] sd 11:0:0:0: [sdd] Write P=
rotect is off
Mar 19 13:45:47 sleepy kernel: [167753.075474]  sdd: sdd1
Mar 19 13:45:47 sleepy kernel: [167753.077961] sd 11:0:0:0: [sdd] Attache=
d SCSI removable disk
Mar 19 13:45:59 sleepy kernel: [167765.307274] FAT-fs (sdd1): utf8 is not=
 a recommended IO charset for FAT filesystems, filesystem will be case se=
nsitive!
Mar 19 14:16:07 sleepy kernel: [169572.528071] sdd: detected capacity cha=
nge from 8115978240 to 0
Mar 19 14:52:44 sleepy kernel: [171768.300140] usb 2-6.4: USB disconnect,=
 device number 12
Mar 19 14:53:44 sleepy kernel: [171790.806211] ------------[ cut here ]--=
----------
Mar 19 14:53:44 sleepy kernel: [171790.806220] WARNING: at /home/blank/de=
bian/kernel/release/linux-2.6/linux-2.6-3.2.4/debian/build/source_amd64_n=
one/kernel/watchdog.c:241 watchdog_overflow_callback+0x93/0x9e()
Mar 19 14:53:44 sleepy kernel: [171790.806224] Hardware name: System Prod=
uct Name
Mar 19 14:53:44 sleepy kernel: [171790.806226] Watchdog detected hard LOC=
KUP on cpu 2
Mar 19 14:53:44 sleepy kernel: [171790.806228] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171790.806332] Pid: 7825, comm: udevd Tai=
nted: P           O 3.2.0-1-amd64 #1
Mar 19 14:53:44 sleepy kernel: [171790.806335] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171790.806337]  <NMI>  [<ffffffff81046871=
>] ? warn_slowpath_common+0x78/0x8c
Mar 19 14:53:44 sleepy kernel: [171790.806347]  [<ffffffff8104691d>] ? wa=
rn_slowpath_fmt+0x45/0x4a
Mar 19 14:53:44 sleepy kernel: [171790.806351]  [<ffffffff8108fcc4>] ? wa=
tchdog_overflow_callback+0x93/0x9e
Mar 19 14:53:44 sleepy kernel: [171790.806355]  [<ffffffff8108fc31>] ? to=
uch_nmi_watchdog+0x60/0x60
Mar 19 14:53:44 sleepy kernel: [171790.806359]  [<ffffffff810af36c>] ? __=
perf_event_overflow+0xf9/0x17b
Mar 19 14:53:44 sleepy kernel: [171790.806365]  [<ffffffff81063866>] ? lo=
cal_clock+0x24/0x2b
Mar 19 14:53:44 sleepy kernel: [171790.806370]  [<ffffffff810ada5f>] ? pe=
rf_event_update_userpage+0x9/0x9a
Mar 19 14:53:44 sleepy kernel: [171790.806376]  [<ffffffff81019cf9>] ? x8=
6_perf_event_set_period+0x101/0x10b
Mar 19 14:53:44 sleepy kernel: [171790.806381]  [<ffffffff8101cf98>] ? in=
tel_pmu_handle_irq+0x206/0x267
Mar 19 14:53:44 sleepy kernel: [171790.806386]  [<ffffffff81341659>] ? nm=
i_handle.isra.0+0x3e/0x61
Mar 19 14:53:44 sleepy kernel: [171790.806390]  [<ffffffff813416f9>] ? do=
_nmi+0x7d/0x258
Mar 19 14:53:44 sleepy kernel: [171790.806393]  [<ffffffff81340f70>] ? nm=
i+0x20/0x30
Mar 19 14:53:44 sleepy kernel: [171790.806399]  [<ffffffff8134071a>] ? _r=
aw_spin_lock_irqsave+0x17/0x25
Mar 19 14:53:44 sleepy kernel: [171790.806401]  <<EOE>>  [<ffffffff8105f5=
65>] ? add_wait_queue+0x12/0x3c
Mar 19 14:53:44 sleepy kernel: [171790.806411]  [<ffffffff81127995>] ? ep=
_ptable_queue_proc+0x55/0x7e
Mar 19 14:53:44 sleepy kernel: [171790.806415]  [<ffffffff81128bd8>] ? si=
gnalfd_poll+0x34/0xa9
Mar 19 14:53:44 sleepy kernel: [171790.806419]  [<ffffffff8112830a>] ? sy=
s_epoll_ctl+0x22e/0x4be
Mar 19 14:53:44 sleepy kernel: [171790.806423]  [<ffffffff81127940>] ? ep=
_set_mstimeout+0x4a/0x4a
Mar 19 14:53:44 sleepy kernel: [171790.806428]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171790.806431] ---[ end trace d0323b774a4=
fde8b ]---
Mar 19 14:53:44 sleepy kernel: [171828.281902] sending NMI to all CPUs:
Mar 19 14:53:44 sleepy kernel: [171828.281906] NMI backtrace for cpu 0
Mar 19 14:53:44 sleepy kernel: [171828.281908] CPU 0=20
Mar 19 14:53:44 sleepy kernel: [171828.281910] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171828.282010]=20
Mar 19 14:53:44 sleepy kernel: [171828.282014] Pid: 0, comm: swapper/0 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171828.282019] RIP: 0010:[<ffffffff81023d=
d8>]  [<ffffffff81023dd8>] native_safe_apic_wait_icr_idle+0x1d/0x32
Mar 19 14:53:44 sleepy kernel: [171828.282029] RSP: 0018:ffff88063fc03c98=
  EFLAGS: 00000006
Mar 19 14:53:44 sleepy kernel: [171828.282032] RAX: 0000000000001400 RBX:=
 00000000000003e9 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171828.282034] RDX: 0000000000000001 RSI:=
 0000000000000002 RDI: 0000000000000300
Mar 19 14:53:44 sleepy kernel: [171828.282037] RBP: 0000000000001000 R08:=
 0000000000000000 R09: ffffffff8168ca80
Mar 19 14:53:44 sleepy kernel: [171828.282040] R10: 7fffffffffffffff R11:=
 7fffffffffffffff R12: 0000000000000002
Mar 19 14:53:44 sleepy kernel: [171828.282043] R13: ffffffff8168ca80 R14:=
 0000000000000001 R15: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.282047] FS:  0000000000000000(0000=
) GS:ffff88063fc00000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.282050] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171828.282053] CR2: 00007f1b6807c000 CR3:=
 0000000001605000 CR4: 00000000000006f0
Mar 19 14:53:44 sleepy kernel: [171828.282056] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.282059] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171828.282062] Process swapper/0 (pid: 0,=
 threadinfo ffffffff81600000, task ffffffff8160d020)
Mar 19 14:53:44 sleepy kernel: [171828.282066]  7fffffffffffffff 00000000=
00000002 0000000000000002 ffffffff81024723
Mar 19 14:53:44 sleepy kernel: [171828.282072]  0000000000000001 00000000=
00000086 000000000000da42 ffffffff8102478f
Mar 19 14:53:44 sleepy kernel: [171828.282077]  0000000000002710 ffffffff=
81621d00 ffffffff81621e00 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171828.282090]  [<ffffffff81024723>] ? __=
default_send_IPI_dest_field.constprop.0+0x19/0x4d
Mar 19 14:53:44 sleepy kernel: [171828.282095]  [<ffffffff8102478f>] ? de=
fault_send_IPI_mask_sequence_phys+0x38/0x6a
Mar 19 14:53:44 sleepy kernel: [171828.282100]  [<ffffffff810248a2>] ? ar=
ch_trigger_all_cpu_backtrace+0x4d/0x7b
Mar 19 14:53:44 sleepy kernel: [171828.282106]  [<ffffffff81095590>] ? __=
rcu_pending+0x21a/0x337
Mar 19 14:53:44 sleepy kernel: [171828.282111]  [<ffffffff81011885>] ? ar=
ch_local_irq_save+0x5/0x13
Mar 19 14:53:44 sleepy kernel: [171828.282117]  [<ffffffff8106ba90>] ? ti=
ck_nohz_handler+0xd0/0xd0
Mar 19 14:53:44 sleepy kernel: [171828.282121]  [<ffffffff810959da>] ? rc=
u_check_callbacks+0x90/0xcc
Mar 19 14:53:44 sleepy kernel: [171828.282125]  [<ffffffff810526f7>] ? up=
date_process_times+0x31/0x63
Mar 19 14:53:44 sleepy kernel: [171828.282129]  [<ffffffff8106bafa>] ? ti=
ck_sched_timer+0x6a/0x90
Mar 19 14:53:44 sleepy kernel: [171828.282134]  [<ffffffff81061e0e>] ? __=
run_hrtimer+0xac/0x135
Mar 19 14:53:44 sleepy kernel: [171828.282138]  [<ffffffff8106253e>] ? hr=
timer_interrupt+0xdb/0x195
Mar 19 14:53:44 sleepy kernel: [171828.282142]  [<ffffffff81094b28>] ? fo=
rce_qs_rnp+0xc3/0x10a
Mar 19 14:53:44 sleepy kernel: [171828.282146]  [<ffffffff8106af1b>] ? ti=
ck_do_broadcast.constprop.4+0x3f/0x85
Mar 19 14:53:44 sleepy kernel: [171828.282151]  [<ffffffff8106b01d>] ? ti=
ck_handle_oneshot_broadcast+0xbc/0xfa
Mar 19 14:53:44 sleepy kernel: [171828.282155]  [<ffffffff8109501a>] ? __=
rcu_process_callbacks+0x72/0x2c0
Mar 19 14:53:44 sleepy kernel: [171828.282161]  [<ffffffff8100fe5d>] ? ti=
mer_interrupt+0x15/0x1c
Mar 19 14:53:44 sleepy kernel: [171828.282164]  [<ffffffff8109053d>] ? ha=
ndle_irq_event_percpu+0x50/0x180
Mar 19 14:53:44 sleepy kernel: [171828.282169]  [<ffffffff810135b2>] ? re=
ad_tsc+0x5/0x14
Mar 19 14:53:44 sleepy kernel: [171828.282173]  [<ffffffff81023d04>] ? __=
setup_APIC_LVTT+0x4a/0x66
Mar 19 14:53:44 sleepy kernel: [171828.282177]  [<ffffffff810906a1>] ? ha=
ndle_irq_event+0x34/0x53
Mar 19 14:53:44 sleepy kernel: [171828.282181]  [<ffffffff81092a9d>] ? ha=
ndle_edge_irq+0xa2/0xc9
Mar 19 14:53:44 sleepy kernel: [171828.282185]  [<ffffffff8100f835>] ? ha=
ndle_irq+0x1d/0x21
Mar 19 14:53:44 sleepy kernel: [171828.282189]  [<ffffffff8100f565>] ? do=
_IRQ+0x42/0x98
Mar 19 14:53:44 sleepy kernel: [171828.282193]  [<ffffffff813409ee>] ? co=
mmon_interrupt+0x6e/0x6e
Mar 19 14:53:44 sleepy kernel: [171828.282201]  [<ffffffff811e3929>] ? in=
tel_idle+0xea/0x119
Mar 19 14:53:44 sleepy kernel: [171828.282205]  [<ffffffff811e3908>] ? in=
tel_idle+0xc9/0x119
Mar 19 14:53:44 sleepy kernel: [171828.282211]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.282215]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.282220]  [<ffffffff816a9b3d>] ? st=
art_kernel+0x3bd/0x3c8
Mar 19 14:53:44 sleepy kernel: [171828.282224]  [<ffffffff816a9140>] ? ea=
rly_idt_handlers+0x140/0x140
Mar 19 14:53:44 sleepy kernel: [171828.282228]  [<ffffffff816a93c4>] ? x8=
6_64_start_kernel+0x104/0x111
Mar 19 14:53:44 sleepy kernel: [171828.282267] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171828.282269]  <IRQ>  [<ffffffff81024723=
>] ? __default_send_IPI_dest_field.constprop.0+0x19/0x4d
Mar 19 14:53:44 sleepy kernel: [171828.282278]  [<ffffffff8102478f>] ? de=
fault_send_IPI_mask_sequence_phys+0x38/0x6a
Mar 19 14:53:44 sleepy kernel: [171828.282283]  [<ffffffff810248a2>] ? ar=
ch_trigger_all_cpu_backtrace+0x4d/0x7b
Mar 19 14:53:44 sleepy kernel: [171828.282287]  [<ffffffff81095590>] ? __=
rcu_pending+0x21a/0x337
Mar 19 14:53:44 sleepy kernel: [171828.282291]  [<ffffffff81011885>] ? ar=
ch_local_irq_save+0x5/0x13
Mar 19 14:53:44 sleepy kernel: [171828.282295]  [<ffffffff8106ba90>] ? ti=
ck_nohz_handler+0xd0/0xd0
Mar 19 14:53:44 sleepy kernel: [171828.282299]  [<ffffffff810959da>] ? rc=
u_check_callbacks+0x90/0xcc
Mar 19 14:53:44 sleepy kernel: [171828.282303]  [<ffffffff810526f7>] ? up=
date_process_times+0x31/0x63
Mar 19 14:53:44 sleepy kernel: [171828.282307]  [<ffffffff8106bafa>] ? ti=
ck_sched_timer+0x6a/0x90
Mar 19 14:53:44 sleepy kernel: [171828.282311]  [<ffffffff81061e0e>] ? __=
run_hrtimer+0xac/0x135
Mar 19 14:53:44 sleepy kernel: [171828.282315]  [<ffffffff8106253e>] ? hr=
timer_interrupt+0xdb/0x195
Mar 19 14:53:44 sleepy kernel: [171828.282319]  [<ffffffff81094b28>] ? fo=
rce_qs_rnp+0xc3/0x10a
Mar 19 14:53:44 sleepy kernel: [171828.282323]  [<ffffffff8106af1b>] ? ti=
ck_do_broadcast.constprop.4+0x3f/0x85
Mar 19 14:53:44 sleepy kernel: [171828.282327]  [<ffffffff8106b01d>] ? ti=
ck_handle_oneshot_broadcast+0xbc/0xfa
Mar 19 14:53:44 sleepy kernel: [171828.282332]  [<ffffffff8109501a>] ? __=
rcu_process_callbacks+0x72/0x2c0
Mar 19 14:53:44 sleepy kernel: [171828.282336]  [<ffffffff8100fe5d>] ? ti=
mer_interrupt+0x15/0x1c
Mar 19 14:53:44 sleepy kernel: [171828.282340]  [<ffffffff8109053d>] ? ha=
ndle_irq_event_percpu+0x50/0x180
Mar 19 14:53:44 sleepy kernel: [171828.282344]  [<ffffffff810135b2>] ? re=
ad_tsc+0x5/0x14
Mar 19 14:53:44 sleepy kernel: [171828.282348]  [<ffffffff81023d04>] ? __=
setup_APIC_LVTT+0x4a/0x66
Mar 19 14:53:44 sleepy kernel: [171828.282351]  [<ffffffff810906a1>] ? ha=
ndle_irq_event+0x34/0x53
Mar 19 14:53:44 sleepy kernel: [171828.282355]  [<ffffffff81092a9d>] ? ha=
ndle_edge_irq+0xa2/0xc9
Mar 19 14:53:44 sleepy kernel: [171828.282359]  [<ffffffff8100f835>] ? ha=
ndle_irq+0x1d/0x21
Mar 19 14:53:44 sleepy kernel: [171828.282363]  [<ffffffff8100f565>] ? do=
_IRQ+0x42/0x98
Mar 19 14:53:44 sleepy kernel: [171828.282367]  [<ffffffff813409ee>] ? co=
mmon_interrupt+0x6e/0x6e
Mar 19 14:53:44 sleepy kernel: [171828.282369]  <EOI>  [<ffffffff811e3929=
>] ? intel_idle+0xea/0x119
Mar 19 14:53:44 sleepy kernel: [171828.282375]  [<ffffffff811e3908>] ? in=
tel_idle+0xc9/0x119
Mar 19 14:53:44 sleepy kernel: [171828.282380]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.282384]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.282388]  [<ffffffff816a9b3d>] ? st=
art_kernel+0x3bd/0x3c8
Mar 19 14:53:44 sleepy kernel: [171828.282391]  [<ffffffff816a9140>] ? ea=
rly_idt_handlers+0x140/0x140
Mar 19 14:53:44 sleepy kernel: [171828.282395]  [<ffffffff816a93c4>] ? x8=
6_64_start_kernel+0x104/0x111
Mar 19 14:53:44 sleepy kernel: [171828.282500] NMI backtrace for cpu 1
Mar 19 14:53:44 sleepy kernel: [171828.282503] CPU 1=20
Mar 19 14:53:44 sleepy kernel: [171828.282505] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171828.282597]=20
Mar 19 14:53:44 sleepy kernel: [171828.282600] Pid: 2638, comm: Xorg Tain=
ted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product Na=
me/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171828.282605] RIP: 0010:[<ffffffffa0354e=
80>]  [<ffffffffa0354e80>] _ZN19ExecutableUnitsR60015submitTimeStampE12_Q=
S_CP_RING_+0xc0/0xc0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.282694] RSP: 0018:ffff880624dbfbc0=
  EFLAGS: 00000246
Mar 19 14:53:44 sleepy kernel: [171828.282697] RAX: ffffffffa03d7a10 RBX:=
 ffff880624dbfc08 RCX: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.282700] RDX: ffffc90014859020 RSI:=
 0000000000000000 RDI: ffffc90014c7d7a0
Mar 19 14:53:44 sleepy kernel: [171828.282703] RBP: ffffffffa03d8150 R08:=
 ffffffffa03d8150 R09: 000000000001e848
Mar 19 14:53:44 sleepy kernel: [171828.282706] R10: ffffc9001485a200 R11:=
 ffff8806246c4068 R12: 00000001028f521f
Mar 19 14:53:44 sleepy kernel: [171828.282709] R13: 00000001028ea2d4 R14:=
 0000000000000000 R15: ffffc90014c7d800
Mar 19 14:53:44 sleepy kernel: [171828.282712] FS:  00007ffbe863d880(0000=
) GS:ffff88063fc20000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.282716] CS:  0010 DS: 0000 ES: 000=
0 CR0: 0000000080050033
Mar 19 14:53:44 sleepy kernel: [171828.282718] CR2: 00007f1b6730a000 CR3:=
 0000000622b9f000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171828.282721] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.282724] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171828.282728] Process Xorg (pid: 2638, t=
hreadinfo ffff880624dbe000, task ffff880623b100c0)
Mar 19 14:53:44 sleepy kernel: [171828.282732]  ffffffffa035aaaa ffff8806=
24dbfc08 ffffffffa0359bcb ffffc90014859020
Mar 19 14:53:44 sleepy kernel: [171828.282738]  ffffc90014c7d7a0 ffffc900=
13eea080 0000000000000000 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.282743]  ffffffffa035483e ffffffff=
a03d8150 ffffc90014859020 ffffc9001485a200
Mar 19 14:53:44 sleepy kernel: [171828.282831]  [<ffffffffa035aaaa>] ? _Z=
N4Asic16Is_WPTR_equ_RPTR19ConditionSuccessfulEv+0x1a/0x60 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.282916]  [<ffffffffa0359bcb>] ? _Z=
N4Asic9WaitUntil15WaitForCompleteEv+0x2b/0xf0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283013]  [<ffffffffa035483e>] ? _Z=
N15ExecutableUnits10CPRingIdleE15idle_WaitMethod12_QS_CP_RING_+0x11e/0x1e=
0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283112]  [<ffffffffa035539a>] ? _Z=
N21ExecutableUnitsCayman14AllCPRingsIdleE15idle_WaitMethod+0x1a/0x90 [fgl=
rx]
Mar 19 14:53:44 sleepy kernel: [171828.283209]  [<ffffffffa03546cc>] ? _Z=
N15ExecutableUnits7PM4idleE15idle_WaitMethod+0x4c/0x90 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283254]  [<ffffffffa02b2d53>] ? dr=
m_alloc+0xc3/0x1a0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283348]  [<ffffffffa034a8f1>] ? _Z=
N15QS_PRIVATE_CORE9QsPM4idleE15idle_WaitMethod+0x31/0x60 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283438]  [<ffffffffa03356ce>] ? _Z=
N10QS_PRIVATE11synchronizeEv+0xce/0xe0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283530]  [<ffffffffa033ed35>] ? _Z=
8uCWDDEQCmjjPvjS_+0x3b5/0x10c0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283536]  [<ffffffff8103642f>] ? sh=
ould_resched+0x5/0x23
Mar 19 14:53:44 sleepy kernel: [171828.283541]  [<ffffffff81070759>] ? ar=
ch_local_irq_save+0x11/0x17
Mar 19 14:53:44 sleepy kernel: [171828.283601]  [<ffffffffa02df352>] ? fi=
regl_cmmqs_CWDDE_32+0x332/0x440 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283662]  [<ffffffffa02ddd50>] ? fi=
regl_cmmqs_CWDDE32+0x70/0x100 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283723]  [<ffffffffa02ddce0>] ? fi=
regl_cmmqs_enableqs+0x1c0/0x1c0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283770]  [<ffffffffa02baa2d>] ? fi=
regl_ioctl+0x1ed/0x250 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283804]  [<ffffffffa02adb28>] ? ip=
_firegl_unlocked_ioctl+0x6/0xa [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.283810]  [<ffffffff81105cb5>] ? do=
_vfs_ioctl+0x459/0x49a
Mar 19 14:53:44 sleepy kernel: [171828.283816]  [<ffffffff81105d41>] ? sy=
s_ioctl+0x4b/0x72
Mar 19 14:53:44 sleepy kernel: [171828.283821]  [<ffffffff810f8cf3>] ? sy=
s_read+0x5f/0x6b
Mar 19 14:53:44 sleepy kernel: [171828.283827]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171828.283880] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171828.283975]  [<ffffffffa035aaaa>] ? _Z=
N4Asic16Is_WPTR_equ_RPTR19ConditionSuccessfulEv+0x1a/0x60 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284071]  [<ffffffffa0359bcb>] ? _Z=
N4Asic9WaitUntil15WaitForCompleteEv+0x2b/0xf0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284168]  [<ffffffffa035483e>] ? _Z=
N15ExecutableUnits10CPRingIdleE15idle_WaitMethod12_QS_CP_RING_+0x11e/0x1e=
0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284266]  [<ffffffffa035539a>] ? _Z=
N21ExecutableUnitsCayman14AllCPRingsIdleE15idle_WaitMethod+0x1a/0x90 [fgl=
rx]
Mar 19 14:53:44 sleepy kernel: [171828.284363]  [<ffffffffa03546cc>] ? _Z=
N15ExecutableUnits7PM4idleE15idle_WaitMethod+0x4c/0x90 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284408]  [<ffffffffa02b2d53>] ? dr=
m_alloc+0xc3/0x1a0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284501]  [<ffffffffa034a8f1>] ? _Z=
N15QS_PRIVATE_CORE9QsPM4idleE15idle_WaitMethod+0x31/0x60 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284591]  [<ffffffffa03356ce>] ? _Z=
N10QS_PRIVATE11synchronizeEv+0xce/0xe0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284682]  [<ffffffffa033ed35>] ? _Z=
8uCWDDEQCmjjPvjS_+0x3b5/0x10c0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284687]  [<ffffffff8103642f>] ? sh=
ould_resched+0x5/0x23
Mar 19 14:53:44 sleepy kernel: [171828.284692]  [<ffffffff81070759>] ? ar=
ch_local_irq_save+0x11/0x17
Mar 19 14:53:44 sleepy kernel: [171828.284752]  [<ffffffffa02df352>] ? fi=
regl_cmmqs_CWDDE_32+0x332/0x440 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284812]  [<ffffffffa02ddd50>] ? fi=
regl_cmmqs_CWDDE32+0x70/0x100 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284874]  [<ffffffffa02ddce0>] ? fi=
regl_cmmqs_enableqs+0x1c0/0x1c0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284921]  [<ffffffffa02baa2d>] ? fi=
regl_ioctl+0x1ed/0x250 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284954]  [<ffffffffa02adb28>] ? ip=
_firegl_unlocked_ioctl+0x6/0xa [fglrx]
Mar 19 14:53:44 sleepy kernel: [171828.284959]  [<ffffffff81105cb5>] ? do=
_vfs_ioctl+0x459/0x49a
Mar 19 14:53:44 sleepy kernel: [171828.284965]  [<ffffffff81105d41>] ? sy=
s_ioctl+0x4b/0x72
Mar 19 14:53:44 sleepy kernel: [171828.284969]  [<ffffffff810f8cf3>] ? sy=
s_read+0x5f/0x6b
Mar 19 14:53:44 sleepy kernel: [171828.284975]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171828.284979] NMI backtrace for cpu 2
Mar 19 14:53:44 sleepy kernel: [171828.284983] CPU 2=20
Mar 19 14:53:44 sleepy kernel: [171828.284985] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171828.285101]=20
Mar 19 14:53:44 sleepy kernel: [171828.285105] Pid: 7825, comm: udevd Tai=
nted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product N=
ame/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171828.285112] RIP: 0010:[<ffffffff813407=
24>]  [<ffffffff81340724>] _raw_spin_lock_irqsave+0x21/0x25
Mar 19 14:53:44 sleepy kernel: [171828.285122] RSP: 0018:ffff8805ad78de88=
  EFLAGS: 00000893
Mar 19 14:53:44 sleepy kernel: [171828.285125] RAX: 0000000000000246 RBX:=
 ffff880623382850 RCX: 0000000000008178
Mar 19 14:53:44 sleepy kernel: [171828.285129] RDX: 0000000081784740 RSI:=
 ffff880621c6bf30 RDI: ffff880623382850
Mar 19 14:53:44 sleepy kernel: [171828.285133] RBP: ffff880621c6bf30 R08:=
 0000000000000032 R09: ffff880626679000
Mar 19 14:53:44 sleepy kernel: [171828.285137] R10: 0000000000000206 R11:=
 0000000000000206 R12: ffff880621c6bf18
Mar 19 14:53:44 sleepy kernel: [171828.285141] R13: 0000000000000003 R14:=
 ffff880622b5e0c0 R15: ffff880622b5e0d8
Mar 19 14:53:44 sleepy kernel: [171828.285146] FS:  00007f228ba037a0(0000=
) GS:ffff88063fc40000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.285150] CS:  0010 DS: 0000 ES: 000=
0 CR0: 0000000080050033
Mar 19 14:53:44 sleepy kernel: [171828.285153] CR2: 00007f228b13d640 CR3:=
 00000005290f6000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171828.285157] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.285161] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171828.285165] Process udevd (pid: 7825, =
threadinfo ffff8805ad78c000, task ffff8805e24c50c0)
Mar 19 14:53:44 sleepy kernel: [171828.285171]  ffff880623382850 ffffffff=
8105f565 0000000000000206 ffff880623382850
Mar 19 14:53:44 sleepy kernel: [171828.285178]  ffff880622b5e0c0 ffffffff=
81127995 ffff88060618ede0 ffff8805f87ea240
Mar 19 14:53:44 sleepy kernel: [171828.285185]  ffff88062298f380 ffffffff=
81128bd8 ffff8805aeb3ec40 ffff8805f87ea240
Mar 19 14:53:44 sleepy kernel: [171828.285199]  [<ffffffff8105f565>] ? ad=
d_wait_queue+0x12/0x3c
Mar 19 14:53:44 sleepy kernel: [171828.285206]  [<ffffffff81127995>] ? ep=
_ptable_queue_proc+0x55/0x7e
Mar 19 14:53:44 sleepy kernel: [171828.285211]  [<ffffffff81128bd8>] ? si=
gnalfd_poll+0x34/0xa9
Mar 19 14:53:44 sleepy kernel: [171828.285216]  [<ffffffff8112830a>] ? sy=
s_epoll_ctl+0x22e/0x4be
Mar 19 14:53:44 sleepy kernel: [171828.285222]  [<ffffffff81127940>] ? ep=
_set_mstimeout+0x4a/0x4a
Mar 19 14:53:44 sleepy kernel: [171828.285228]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171828.285281] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171828.285286]  [<ffffffff8105f565>] ? ad=
d_wait_queue+0x12/0x3c
Mar 19 14:53:44 sleepy kernel: [171828.285291]  [<ffffffff81127995>] ? ep=
_ptable_queue_proc+0x55/0x7e
Mar 19 14:53:44 sleepy kernel: [171828.285296]  [<ffffffff81128bd8>] ? si=
gnalfd_poll+0x34/0xa9
Mar 19 14:53:44 sleepy kernel: [171828.285301]  [<ffffffff8112830a>] ? sy=
s_epoll_ctl+0x22e/0x4be
Mar 19 14:53:44 sleepy kernel: [171828.285306]  [<ffffffff81127940>] ? ep=
_set_mstimeout+0x4a/0x4a
Mar 19 14:53:44 sleepy kernel: [171828.285311]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171828.285316] NMI backtrace for cpu 3
Mar 19 14:53:44 sleepy kernel: [171828.285320] CPU 3=20
Mar 19 14:53:44 sleepy kernel: [171828.285322] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171828.285437]=20
Mar 19 14:53:44 sleepy kernel: [171828.285441] Pid: 0, comm: swapper/3 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171828.285448] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171828.285456] RSP: 0018:ffff880626a65e68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171828.285460] RAX: 0000000000000020 RBX:=
 0000000000000008 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171828.285464] RDX: 0000000000000000 RSI:=
 ffff880626a65fd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171828.285467] RBP: 0000000000000003 R08:=
 0000000000000000 R09: 000000000000073c
Mar 19 14:53:44 sleepy kernel: [171828.285471] R10: 0000000000000206 R11:=
 ffff880626a60f40 R12: ffff88063fc79970
Mar 19 14:53:44 sleepy kernel: [171828.285475] R13: 0000000000000020 R14:=
 127ccd369624a337 R15: 0000000000000003
Mar 19 14:53:44 sleepy kernel: [171828.285480] FS:  0000000000000000(0000=
) GS:ffff88063fc60000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.285484] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171828.285488] CR2: 00007ffbd7f14000 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171828.285491] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.285495] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171828.285500] Process swapper/3 (pid: 0,=
 threadinfo ffff880626a64000, task ffff880626a60f40)
Mar 19 14:53:44 sleepy kernel: [171828.285505]  ffffffff810135b2 ffffffff=
81264602 0000000000000000 00000000001c4448
Mar 19 14:53:44 sleepy kernel: [171828.285512]  0000000000000000 00000003=
001c4448 ffff88063fc79970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171828.285519]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171828.285532]  [<ffffffff810135b2>] ? re=
ad_tsc+0x5/0x14
Mar 19 14:53:44 sleepy kernel: [171828.285538]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171828.285544]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.285550]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.285555]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.285609] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171828.285614]  [<ffffffff810135b2>] ? re=
ad_tsc+0x5/0x14
Mar 19 14:53:44 sleepy kernel: [171828.285619]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171828.285624]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.285630]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.285634]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.285639] NMI backtrace for cpu 4
Mar 19 14:53:44 sleepy kernel: [171828.285642] CPU 4=20
Mar 19 14:53:44 sleepy kernel: [171828.285644] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171828.285758]=20
Mar 19 14:53:44 sleepy kernel: [171828.285761] Pid: 0, comm: swapper/4 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171828.285768] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171828.285775] RSP: 0018:ffff880626a99e68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171828.285778] RAX: 0000000000000020 RBX:=
 0000000000000008 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171828.285782] RDX: 0000000000000000 RSI:=
 ffff880626a99fd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171828.285785] RBP: 0000000000000003 R08:=
 0000000000000000 R09: 0000000000000f71
Mar 19 14:53:44 sleepy kernel: [171828.285789] R10: 0000000000000046 R11:=
 ffff880626a98000 R12: ffff88063fc99970
Mar 19 14:53:44 sleepy kernel: [171828.285793] R13: 0000000000000020 R14:=
 127ccd369623ac50 R15: 0000000000000004
Mar 19 14:53:44 sleepy kernel: [171828.285798] FS:  0000000000000000(0000=
) GS:ffff88063fc80000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.285802] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171828.285805] CR2: 00007ffbece8e848 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171828.285809] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.285813] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171828.285817] Process swapper/4 (pid: 0,=
 threadinfo ffff880626a98000, task ffff880626a6e8a0)
Mar 19 14:53:44 sleepy kernel: [171828.285822]  0000000000000000 ffffffff=
81264602 0000000000000000 00000000003c52a6
Mar 19 14:53:44 sleepy kernel: [171828.285829]  0000000000000000 00000004=
003c52a6 ffff88063fc99970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171828.285836]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171828.285848]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171828.285854]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.285859]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.285864]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.285918] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171828.285922]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171828.285928]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.285933]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.285938]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.285943] NMI backtrace for cpu 5
Mar 19 14:53:44 sleepy kernel: [171828.285946] CPU 5=20
Mar 19 14:53:44 sleepy kernel: [171828.285948] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171828.286075]=20
Mar 19 14:53:44 sleepy kernel: [171828.286078] Pid: 0, comm: swapper/5 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171828.286086] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171828.286094] RSP: 0018:ffff880626aade68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171828.286098] RAX: 0000000000000020 RBX:=
 0000000000000008 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171828.286103] RDX: 0000000000000000 RSI:=
 ffff880626aadfd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171828.286107] RBP: 0000000000000003 R08:=
 0000000000000000 R09: 0000000000000f6e
Mar 19 14:53:44 sleepy kernel: [171828.286111] R10: ffff8805ad390ec0 R11:=
 ffff880626aac000 R12: ffff88063fcb9970
Mar 19 14:53:44 sleepy kernel: [171828.286116] R13: 0000000000000020 R14:=
 127ccd369604a03c R15: 0000000000000005
Mar 19 14:53:44 sleepy kernel: [171828.286121] FS:  0000000000000000(0000=
) GS:ffff88063fca0000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.286126] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171828.286130] CR2: 00007ffbc0726000 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171828.286134] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.286138] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171828.286143] Process swapper/5 (pid: 0,=
 threadinfo ffff880626aac000, task ffff880626a9c200)
Mar 19 14:53:44 sleepy kernel: [171828.286149]  0000000000000000 ffffffff=
81264602 0000000000000000 00000000003c4906
Mar 19 14:53:44 sleepy kernel: [171828.286157]  0000000000000000 00000005=
003c4906 ffff88063fcb9970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171828.286165]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171828.286178]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171828.286185]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.286191]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.286197]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.286258] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171828.286263]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171828.286269]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.286275]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.286281]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.286286] NMI backtrace for cpu 6
Mar 19 14:53:44 sleepy kernel: [171828.286289] CPU 6=20
Mar 19 14:53:44 sleepy kernel: [171828.286291] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171828.286406]=20
Mar 19 14:53:44 sleepy kernel: [171828.286410] Pid: 0, comm: swapper/6 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171828.286417] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171828.286424] RSP: 0018:ffff880626ae5e68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171828.286428] RAX: 0000000000000020 RBX:=
 0000000000000008 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171828.286432] RDX: 0000000000000000 RSI:=
 ffff880626ae5fd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171828.286436] RBP: 0000000000000003 R08:=
 0000000000000000 R09: 0000000000000f70
Mar 19 14:53:44 sleepy kernel: [171828.286440] R10: 0000000000000293 R11:=
 ffff880626ae4000 R12: ffff88063fcd9970
Mar 19 14:53:44 sleepy kernel: [171828.286444] R13: 0000000000000020 R14:=
 127ccd36960499da R15: 0000000000000006
Mar 19 14:53:44 sleepy kernel: [171828.286448] FS:  0000000000000000(0000=
) GS:ffff88063fcc0000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.286453] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171828.286456] CR2: 00007f1b67461000 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171828.286460] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.286464] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171828.286469] Process swapper/6 (pid: 0,=
 threadinfo ffff880626ae4000, task ffff880626ae3720)
Mar 19 14:53:44 sleepy kernel: [171828.286474]  0000000000000000 ffffffff=
81264602 0000000000000000 00000000003c4f5c
Mar 19 14:53:44 sleepy kernel: [171828.286481]  0000000000000000 00000006=
003c4f5c ffff88063fcd9970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171828.286488]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171828.286501]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171828.286507]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.286513]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.286518]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.286573] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171828.286578]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171828.286583]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.286589]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.286594]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.286598] NMI backtrace for cpu 7
Mar 19 14:53:44 sleepy kernel: [171828.286602] CPU 7=20
Mar 19 14:53:44 sleepy kernel: [171828.286603] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171828.286720]=20
Mar 19 14:53:44 sleepy kernel: [171828.286723] Pid: 0, comm: swapper/7 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171828.286731] RIP: 0010:[<ffffffff813407=
1a>]  [<ffffffff8134071a>] _raw_spin_lock_irqsave+0x17/0x25
Mar 19 14:53:44 sleepy kernel: [171828.286739] RSP: 0018:ffff880626b17d68=
  EFLAGS: 00000097
Mar 19 14:53:44 sleepy kernel: [171828.286743] RAX: 0000000000000002 RBX:=
 ffffffff81787600 RCX: 000000000000d556
Mar 19 14:53:44 sleepy kernel: [171828.286747] RDX: 00000000d556d555 RSI:=
 0000000000000005 RDI: ffffffff81787600
Mar 19 14:53:44 sleepy kernel: [171828.286751] RBP: ffff88063fceda80 R08:=
 0000000000000000 R09: 0000000000000f70
Mar 19 14:53:44 sleepy kernel: [171828.286755] R10: 0000000000000046 R11:=
 ffff880626b16000 R12: 0000000000000007
Mar 19 14:53:44 sleepy kernel: [171828.286759] R13: ffffffff81614f80 R14:=
 0000000000000005 R15: 0000000000000007
Mar 19 14:53:44 sleepy kernel: [171828.286764] FS:  0000000000000000(0000=
) GS:ffff88063fce0000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.286768] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171828.286772] CR2: 00007f1b67784000 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171828.286776] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171828.286780] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171828.286785] Process swapper/7 (pid: 0,=
 threadinfo ffff880626b16000, task ffff880626aef080)
Mar 19 14:53:44 sleepy kernel: [171828.286790]  ffff880626b17e94 ffffffff=
8106b3a8 ffff880626b17e94 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171828.286798]  00000000ffffffff 00000000=
00000000 127ccd3696049b12 ffffffff8106ad59
Mar 19 14:53:44 sleepy kernel: [171828.286805]  ffff88063fceda80 ffffffff=
811ac345 ffff88063fcee8b0 ffff880626b17e94
Mar 19 14:53:44 sleepy kernel: [171828.286818]  [<ffffffff8106b3a8>] ? ti=
ck_broadcast_oneshot_control+0x54/0x102
Mar 19 14:53:44 sleepy kernel: [171828.286824]  [<ffffffff8106ad59>] ? ti=
ck_notify+0x210/0x367
Mar 19 14:53:44 sleepy kernel: [171828.286831]  [<ffffffff811ac345>] ? rb=
_insert_color+0x5f/0xd9
Mar 19 14:53:44 sleepy kernel: [171828.286837]  [<ffffffff81343716>] ? no=
tifier_call_chain+0x2e/0x5b
Mar 19 14:53:44 sleepy kernel: [171828.286843]  [<ffffffff8106a393>] ? cl=
ockevents_notify+0x2f/0x157
Mar 19 14:53:44 sleepy kernel: [171828.286848]  [<ffffffff811e3943>] ? in=
tel_idle+0x104/0x119
Mar 19 14:53:44 sleepy kernel: [171828.286854]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.286859]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.286865]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171828.286920] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171828.286925]  [<ffffffff8106b3a8>] ? ti=
ck_broadcast_oneshot_control+0x54/0x102
Mar 19 14:53:44 sleepy kernel: [171828.286930]  [<ffffffff8106ad59>] ? ti=
ck_notify+0x210/0x367
Mar 19 14:53:44 sleepy kernel: [171828.286936]  [<ffffffff811ac345>] ? rb=
_insert_color+0x5f/0xd9
Mar 19 14:53:44 sleepy kernel: [171828.286941]  [<ffffffff81343716>] ? no=
tifier_call_chain+0x2e/0x5b
Mar 19 14:53:44 sleepy kernel: [171828.286947]  [<ffffffff8106a393>] ? cl=
ockevents_notify+0x2f/0x157
Mar 19 14:53:44 sleepy kernel: [171828.286952]  [<ffffffff811e3943>] ? in=
tel_idle+0x104/0x119
Mar 19 14:53:44 sleepy kernel: [171828.286957]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171828.286963]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171828.286968]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.093509] sending NMI to all CPUs:
Mar 19 14:53:44 sleepy kernel: [171829.093513] NMI backtrace for cpu 0
Mar 19 14:53:44 sleepy kernel: [171829.093515] CPU 0=20
Mar 19 14:53:44 sleepy kernel: [171829.093516] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171829.093620]=20
Mar 19 14:53:44 sleepy kernel: [171829.093623] Pid: 0, comm: swapper/0 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171829.093629] RIP: 0010:[<ffffffff81023d=
d8>]  [<ffffffff81023dd8>] native_safe_apic_wait_icr_idle+0x1d/0x32
Mar 19 14:53:44 sleepy kernel: [171829.093638] RSP: 0018:ffff88063fc03db8=
  EFLAGS: 00000006
Mar 19 14:53:44 sleepy kernel: [171829.093641] RAX: 0000000000001400 RBX:=
 00000000000003e9 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171829.093644] RDX: 0000000000000001 RSI:=
 0000000000000002 RDI: 0000000000000300
Mar 19 14:53:44 sleepy kernel: [171829.093647] RBP: 0000000000001000 R08:=
 0000000000000000 R09: ffffffff8168ca80
Mar 19 14:53:44 sleepy kernel: [171829.093649] R10: 7fffffffffffffff R11:=
 7fffffffffffffff R12: 0000000000000002
Mar 19 14:53:44 sleepy kernel: [171829.093652] R13: ffffffff8168ca80 R14:=
 0000000000000001 R15: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.093656] FS:  0000000000000000(0000=
) GS:ffff88063fc00000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.093659] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171829.093662] CR2: 00007ffbd0be9000 CR3:=
 000000060619f000 CR4: 00000000000006f0
Mar 19 14:53:44 sleepy kernel: [171829.093665] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.093668] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171829.093672] Process swapper/0 (pid: 0,=
 threadinfo ffffffff81600000, task ffffffff8160d020)
Mar 19 14:53:44 sleepy kernel: [171829.093676]  7fffffffffffffff 00000000=
00000002 0000000000000002 ffffffff81024723
Mar 19 14:53:44 sleepy kernel: [171829.093681]  0000000000000001 00000000=
00000086 000000000000da42 ffffffff8102478f
Mar 19 14:53:44 sleepy kernel: [171829.093686]  0000000000002710 ffffffff=
8161fb00 ffffffff8161fc00 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171829.093699]  [<ffffffff81024723>] ? __=
default_send_IPI_dest_field.constprop.0+0x19/0x4d
Mar 19 14:53:44 sleepy kernel: [171829.093705]  [<ffffffff8102478f>] ? de=
fault_send_IPI_mask_sequence_phys+0x38/0x6a
Mar 19 14:53:44 sleepy kernel: [171829.093710]  [<ffffffff810248a2>] ? ar=
ch_trigger_all_cpu_backtrace+0x4d/0x7b
Mar 19 14:53:44 sleepy kernel: [171829.093716]  [<ffffffff81095590>] ? __=
rcu_pending+0x21a/0x337
Mar 19 14:53:44 sleepy kernel: [171829.093720]  [<ffffffff81011885>] ? ar=
ch_local_irq_save+0x5/0x13
Mar 19 14:53:44 sleepy kernel: [171829.093726]  [<ffffffff8106ba90>] ? ti=
ck_nohz_handler+0xd0/0xd0
Mar 19 14:53:44 sleepy kernel: [171829.093731]  [<ffffffff810959f9>] ? rc=
u_check_callbacks+0xaf/0xcc
Mar 19 14:53:44 sleepy kernel: [171829.093735]  [<ffffffff810526f7>] ? up=
date_process_times+0x31/0x63
Mar 19 14:53:44 sleepy kernel: [171829.093739]  [<ffffffff8106bafa>] ? ti=
ck_sched_timer+0x6a/0x90
Mar 19 14:53:44 sleepy kernel: [171829.093744]  [<ffffffff81061e0e>] ? __=
run_hrtimer+0xac/0x135
Mar 19 14:53:44 sleepy kernel: [171829.093748]  [<ffffffff8106253e>] ? hr=
timer_interrupt+0xdb/0x195
Mar 19 14:53:44 sleepy kernel: [171829.093752]  [<ffffffff81023eb3>] ? sm=
p_apic_timer_interrupt+0x6f/0x82
Mar 19 14:53:44 sleepy kernel: [171829.093758]  [<ffffffff813461de>] ? ap=
ic_timer_interrupt+0x6e/0x80
Mar 19 14:53:44 sleepy kernel: [171829.093765]  [<ffffffff811e3929>] ? in=
tel_idle+0xea/0x119
Mar 19 14:53:44 sleepy kernel: [171829.093769]  [<ffffffff811e3908>] ? in=
tel_idle+0xc9/0x119
Mar 19 14:53:44 sleepy kernel: [171829.093775]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.093781]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.093785]  [<ffffffff816a9b3d>] ? st=
art_kernel+0x3bd/0x3c8
Mar 19 14:53:44 sleepy kernel: [171829.093789]  [<ffffffff816a9140>] ? ea=
rly_idt_handlers+0x140/0x140
Mar 19 14:53:44 sleepy kernel: [171829.093793]  [<ffffffff816a93c4>] ? x8=
6_64_start_kernel+0x104/0x111
Mar 19 14:53:44 sleepy kernel: [171829.093833] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171829.093834]  <IRQ>  [<ffffffff81024723=
>] ? __default_send_IPI_dest_field.constprop.0+0x19/0x4d
Mar 19 14:53:44 sleepy kernel: [171829.093843]  [<ffffffff8102478f>] ? de=
fault_send_IPI_mask_sequence_phys+0x38/0x6a
Mar 19 14:53:44 sleepy kernel: [171829.093848]  [<ffffffff810248a2>] ? ar=
ch_trigger_all_cpu_backtrace+0x4d/0x7b
Mar 19 14:53:44 sleepy kernel: [171829.093853]  [<ffffffff81095590>] ? __=
rcu_pending+0x21a/0x337
Mar 19 14:53:44 sleepy kernel: [171829.093856]  [<ffffffff81011885>] ? ar=
ch_local_irq_save+0x5/0x13
Mar 19 14:53:44 sleepy kernel: [171829.093861]  [<ffffffff8106ba90>] ? ti=
ck_nohz_handler+0xd0/0xd0
Mar 19 14:53:44 sleepy kernel: [171829.093865]  [<ffffffff810959f9>] ? rc=
u_check_callbacks+0xaf/0xcc
Mar 19 14:53:44 sleepy kernel: [171829.093869]  [<ffffffff810526f7>] ? up=
date_process_times+0x31/0x63
Mar 19 14:53:44 sleepy kernel: [171829.093873]  [<ffffffff8106bafa>] ? ti=
ck_sched_timer+0x6a/0x90
Mar 19 14:53:44 sleepy kernel: [171829.093876]  [<ffffffff81061e0e>] ? __=
run_hrtimer+0xac/0x135
Mar 19 14:53:44 sleepy kernel: [171829.093880]  [<ffffffff8106253e>] ? hr=
timer_interrupt+0xdb/0x195
Mar 19 14:53:44 sleepy kernel: [171829.093885]  [<ffffffff81023eb3>] ? sm=
p_apic_timer_interrupt+0x6f/0x82
Mar 19 14:53:44 sleepy kernel: [171829.093889]  [<ffffffff813461de>] ? ap=
ic_timer_interrupt+0x6e/0x80
Mar 19 14:53:44 sleepy kernel: [171829.093891]  <EOI>  [<ffffffff811e3929=
>] ? intel_idle+0xea/0x119
Mar 19 14:53:44 sleepy kernel: [171829.093898]  [<ffffffff811e3908>] ? in=
tel_idle+0xc9/0x119
Mar 19 14:53:44 sleepy kernel: [171829.093902]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.093906]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.093910]  [<ffffffff816a9b3d>] ? st=
art_kernel+0x3bd/0x3c8
Mar 19 14:53:44 sleepy kernel: [171829.093914]  [<ffffffff816a9140>] ? ea=
rly_idt_handlers+0x140/0x140
Mar 19 14:53:44 sleepy kernel: [171829.093918]  [<ffffffff816a93c4>] ? x8=
6_64_start_kernel+0x104/0x111
Mar 19 14:53:44 sleepy kernel: [171829.094052] NMI backtrace for cpu 1
Mar 19 14:53:44 sleepy kernel: [171829.094055] CPU 1=20
Mar 19 14:53:44 sleepy kernel: [171829.094057] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171829.094150]=20
Mar 19 14:53:44 sleepy kernel: [171829.094153] Pid: 0, comm: swapper/1 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171829.094158] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171829.094165] RSP: 0018:ffff880626a1be68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171829.094168] RAX: 0000000000000010 RBX:=
 0000000000000004 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171829.094171] RDX: 0000000000000000 RSI:=
 ffff880626a1bfd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171829.094174] RBP: 0000000000000002 R08:=
 0000000000000000 R09: 0000000000000afc
Mar 19 14:53:44 sleepy kernel: [171829.094177] R10: 0000000000000293 R11:=
 ffff8806269dc0c0 R12: ffff88063fc39970
Mar 19 14:53:44 sleepy kernel: [171829.094180] R13: 0000000000000010 R14:=
 127ccd36c67c242c R15: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171829.094183] FS:  0000000000000000(0000=
) GS:ffff88063fc20000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.094187] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171829.094190] CR2: 00007f1b6e5bd8f8 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171829.094193] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.094196] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171829.094199] Process swapper/1 (pid: 0,=
 threadinfo ffff880626a1a000, task ffff8806269dc0c0)
Mar 19 14:53:44 sleepy kernel: [171829.094204]  ffffffff810135b2 ffffffff=
81264602 0000000000000000 00000000002aea04
Mar 19 14:53:44 sleepy kernel: [171829.094209]  0000000000000000 00000001=
002aea04 ffff88063fc39970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171829.094214]  00000000fffffff0 00000000=
00000002 ffffffff81645730 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171829.094225]  [<ffffffff810135b2>] ? re=
ad_tsc+0x5/0x14
Mar 19 14:53:44 sleepy kernel: [171829.094230]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.094235]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.094239]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.094244]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.094284] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171829.094287]  [<ffffffff810135b2>] ? re=
ad_tsc+0x5/0x14
Mar 19 14:53:44 sleepy kernel: [171829.094292]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.094296]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.094300]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.094304]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.094308] NMI backtrace for cpu 2
Mar 19 14:53:44 sleepy kernel: [171829.094311] CPU 2=20
Mar 19 14:53:44 sleepy kernel: [171829.094313] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171829.094403]=20
Mar 19 14:53:44 sleepy kernel: [171829.094406] Pid: 7825, comm: udevd Tai=
nted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product N=
ame/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171829.094412] RIP: 0010:[<ffffffff813407=
1a>]  [<ffffffff8134071a>] _raw_spin_lock_irqsave+0x17/0x25
Mar 19 14:53:44 sleepy kernel: [171829.094420] RSP: 0018:ffff8805ad78de88=
  EFLAGS: 00000893
Mar 19 14:53:44 sleepy kernel: [171829.094423] RAX: 0000000000000246 RBX:=
 ffff880623382850 RCX: 0000000000008178
Mar 19 14:53:44 sleepy kernel: [171829.094426] RDX: 0000000081784740 RSI:=
 ffff880621c6bf30 RDI: ffff880623382850
Mar 19 14:53:44 sleepy kernel: [171829.094429] RBP: ffff880621c6bf30 R08:=
 0000000000000032 R09: ffff880626679000
Mar 19 14:53:44 sleepy kernel: [171829.094432] R10: 0000000000000206 R11:=
 0000000000000206 R12: ffff880621c6bf18
Mar 19 14:53:44 sleepy kernel: [171829.094435] R13: 0000000000000003 R14:=
 ffff880622b5e0c0 R15: ffff880622b5e0d8
Mar 19 14:53:44 sleepy kernel: [171829.094439] FS:  00007f228ba037a0(0000=
) GS:ffff88063fc40000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.094442] CS:  0010 DS: 0000 ES: 000=
0 CR0: 0000000080050033
Mar 19 14:53:44 sleepy kernel: [171829.094445] CR2: 00007f228b13d640 CR3:=
 00000005290f6000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171829.094448] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.094451] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171829.094454] Process udevd (pid: 7825, =
threadinfo ffff8805ad78c000, task ffff8805e24c50c0)
Mar 19 14:53:44 sleepy kernel: [171829.094459]  ffff880623382850 ffffffff=
8105f565 0000000000000206 ffff880623382850
Mar 19 14:53:44 sleepy kernel: [171829.094464]  ffff880622b5e0c0 ffffffff=
81127995 ffff88060618ede0 ffff8805f87ea240
Mar 19 14:53:44 sleepy kernel: [171829.094469]  ffff88062298f380 ffffffff=
81128bd8 ffff8805aeb3ec40 ffff8805f87ea240
Mar 19 14:53:44 sleepy kernel: [171829.094481]  [<ffffffff8105f565>] ? ad=
d_wait_queue+0x12/0x3c
Mar 19 14:53:44 sleepy kernel: [171829.094486]  [<ffffffff81127995>] ? ep=
_ptable_queue_proc+0x55/0x7e
Mar 19 14:53:44 sleepy kernel: [171829.094490]  [<ffffffff81128bd8>] ? si=
gnalfd_poll+0x34/0xa9
Mar 19 14:53:44 sleepy kernel: [171829.094494]  [<ffffffff8112830a>] ? sy=
s_epoll_ctl+0x22e/0x4be
Mar 19 14:53:44 sleepy kernel: [171829.094499]  [<ffffffff81127940>] ? ep=
_set_mstimeout+0x4a/0x4a
Mar 19 14:53:44 sleepy kernel: [171829.094504]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171829.094553] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171829.094558]  [<ffffffff8105f565>] ? ad=
d_wait_queue+0x12/0x3c
Mar 19 14:53:44 sleepy kernel: [171829.094563]  [<ffffffff81127995>] ? ep=
_ptable_queue_proc+0x55/0x7e
Mar 19 14:53:44 sleepy kernel: [171829.094568]  [<ffffffff81128bd8>] ? si=
gnalfd_poll+0x34/0xa9
Mar 19 14:53:44 sleepy kernel: [171829.094573]  [<ffffffff8112830a>] ? sy=
s_epoll_ctl+0x22e/0x4be
Mar 19 14:53:44 sleepy kernel: [171829.094578]  [<ffffffff81127940>] ? ep=
_set_mstimeout+0x4a/0x4a
Mar 19 14:53:44 sleepy kernel: [171829.094583]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171829.094588] NMI backtrace for cpu 3
Mar 19 14:53:44 sleepy kernel: [171829.094591] CPU 3=20
Mar 19 14:53:44 sleepy kernel: [171829.094593] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171829.094702]=20
Mar 19 14:53:44 sleepy kernel: [171829.094706] Pid: 2638, comm: Xorg Tain=
ted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product Na=
me/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171829.094713] RIP: 0010:[<ffffffffa035aa=
d4>]  [<ffffffffa035aad4>] _ZN4Asic16Is_WPTR_equ_RPTR19ConditionSuccessfu=
lEv+0x44/0x60 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.094817] RSP: 0018:ffff880624dbfbc8=
  EFLAGS: 00000202
Mar 19 14:53:44 sleepy kernel: [171829.094821] RAX: ffffc90014c7d800 RBX:=
 ffff880624dbfc08 RCX: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.094825] RDX: ffffc90014859020 RSI:=
 0000000000000000 RDI: ffffc90014c7d7a0
Mar 19 14:53:44 sleepy kernel: [171829.094829] RBP: ffffffffa03d8150 R08:=
 ffffffffa03d8150 R09: 000000000001e848
Mar 19 14:53:44 sleepy kernel: [171829.094833] R10: ffffc9001485a200 R11:=
 ffff8806246c4068 R12: 00000001028f52f1
Mar 19 14:53:44 sleepy kernel: [171829.094837] R13: 00000001028ea3a6 R14:=
 0000000000000000 R15: ffffc90014c7d800
Mar 19 14:53:44 sleepy kernel: [171829.094841] FS:  00007ffbe863d880(0000=
) GS:ffff88063fc60000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.094846] CS:  0010 DS: 0000 ES: 000=
0 CR0: 0000000080050033
Mar 19 14:53:44 sleepy kernel: [171829.094849] CR2: 00007ffbd5d7b000 CR3:=
 0000000622b9f000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171829.094853] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.094857] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171829.094861] Process Xorg (pid: 2638, t=
hreadinfo ffff880624dbe000, task ffff880623b100c0)
Mar 19 14:53:44 sleepy kernel: [171829.094867]  ffff880624dbfc08 ffffffff=
a0359bcb ffffc90014859020 ffffc90014c7d7a0
Mar 19 14:53:44 sleepy kernel: [171829.094874]  ffffc90013eea080 00000000=
00000000 0000000000000000 ffffffffa035483e
Mar 19 14:53:44 sleepy kernel: [171829.094881]  ffffffffa03d8150 ffffc900=
14859020 ffffc9001485a200 000000000000afc8
Mar 19 14:53:44 sleepy kernel: [171829.094985]  [<ffffffffa0359bcb>] ? _Z=
N4Asic9WaitUntil15WaitForCompleteEv+0x2b/0xf0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095082]  [<ffffffffa035483e>] ? _Z=
N15ExecutableUnits10CPRingIdleE15idle_WaitMethod12_QS_CP_RING_+0x11e/0x1e=
0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095181]  [<ffffffffa035539a>] ? _Z=
N21ExecutableUnitsCayman14AllCPRingsIdleE15idle_WaitMethod+0x1a/0x90 [fgl=
rx]
Mar 19 14:53:44 sleepy kernel: [171829.095278]  [<ffffffffa03546cc>] ? _Z=
N15ExecutableUnits7PM4idleE15idle_WaitMethod+0x4c/0x90 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095324]  [<ffffffffa02b2d53>] ? dr=
m_alloc+0xc3/0x1a0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095418]  [<ffffffffa034a8f1>] ? _Z=
N15QS_PRIVATE_CORE9QsPM4idleE15idle_WaitMethod+0x31/0x60 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095508]  [<ffffffffa03356ce>] ? _Z=
N10QS_PRIVATE11synchronizeEv+0xce/0xe0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095599]  [<ffffffffa033ed35>] ? _Z=
8uCWDDEQCmjjPvjS_+0x3b5/0x10c0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095605]  [<ffffffff8103642f>] ? sh=
ould_resched+0x5/0x23
Mar 19 14:53:44 sleepy kernel: [171829.095611]  [<ffffffff81070759>] ? ar=
ch_local_irq_save+0x11/0x17
Mar 19 14:53:44 sleepy kernel: [171829.095671]  [<ffffffffa02df352>] ? fi=
regl_cmmqs_CWDDE_32+0x332/0x440 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095732]  [<ffffffffa02ddd50>] ? fi=
regl_cmmqs_CWDDE32+0x70/0x100 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095793]  [<ffffffffa02ddce0>] ? fi=
regl_cmmqs_enableqs+0x1c0/0x1c0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095841]  [<ffffffffa02baa2d>] ? fi=
regl_ioctl+0x1ed/0x250 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095874]  [<ffffffffa02adb28>] ? ip=
_firegl_unlocked_ioctl+0x6/0xa [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.095880]  [<ffffffff81105cb5>] ? do=
_vfs_ioctl+0x459/0x49a
Mar 19 14:53:44 sleepy kernel: [171829.095886]  [<ffffffff81105d41>] ? sy=
s_ioctl+0x4b/0x72
Mar 19 14:53:44 sleepy kernel: [171829.095891]  [<ffffffff810f8cf3>] ? sy=
s_read+0x5f/0x6b
Mar 19 14:53:44 sleepy kernel: [171829.095896]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171829.095949] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171829.096045]  [<ffffffffa0359bcb>] ? _Z=
N4Asic9WaitUntil15WaitForCompleteEv+0x2b/0xf0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096142]  [<ffffffffa035483e>] ? _Z=
N15ExecutableUnits10CPRingIdleE15idle_WaitMethod12_QS_CP_RING_+0x11e/0x1e=
0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096240]  [<ffffffffa035539a>] ? _Z=
N21ExecutableUnitsCayman14AllCPRingsIdleE15idle_WaitMethod+0x1a/0x90 [fgl=
rx]
Mar 19 14:53:44 sleepy kernel: [171829.096337]  [<ffffffffa03546cc>] ? _Z=
N15ExecutableUnits7PM4idleE15idle_WaitMethod+0x4c/0x90 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096383]  [<ffffffffa02b2d53>] ? dr=
m_alloc+0xc3/0x1a0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096476]  [<ffffffffa034a8f1>] ? _Z=
N15QS_PRIVATE_CORE9QsPM4idleE15idle_WaitMethod+0x31/0x60 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096566]  [<ffffffffa03356ce>] ? _Z=
N10QS_PRIVATE11synchronizeEv+0xce/0xe0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096657]  [<ffffffffa033ed35>] ? _Z=
8uCWDDEQCmjjPvjS_+0x3b5/0x10c0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096662]  [<ffffffff8103642f>] ? sh=
ould_resched+0x5/0x23
Mar 19 14:53:44 sleepy kernel: [171829.096667]  [<ffffffff81070759>] ? ar=
ch_local_irq_save+0x11/0x17
Mar 19 14:53:44 sleepy kernel: [171829.096727]  [<ffffffffa02df352>] ? fi=
regl_cmmqs_CWDDE_32+0x332/0x440 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096787]  [<ffffffffa02ddd50>] ? fi=
regl_cmmqs_CWDDE32+0x70/0x100 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096848]  [<ffffffffa02ddce0>] ? fi=
regl_cmmqs_enableqs+0x1c0/0x1c0 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096896]  [<ffffffffa02baa2d>] ? fi=
regl_ioctl+0x1ed/0x250 [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096929]  [<ffffffffa02adb28>] ? ip=
_firegl_unlocked_ioctl+0x6/0xa [fglrx]
Mar 19 14:53:44 sleepy kernel: [171829.096935]  [<ffffffff81105cb5>] ? do=
_vfs_ioctl+0x459/0x49a
Mar 19 14:53:44 sleepy kernel: [171829.096940]  [<ffffffff81105d41>] ? sy=
s_ioctl+0x4b/0x72
Mar 19 14:53:44 sleepy kernel: [171829.096945]  [<ffffffff810f8cf3>] ? sy=
s_read+0x5f/0x6b
Mar 19 14:53:44 sleepy kernel: [171829.096950]  [<ffffffff81345712>] ? sy=
stem_call_fastpath+0x16/0x1b
Mar 19 14:53:44 sleepy kernel: [171829.096955] NMI backtrace for cpu 4
Mar 19 14:53:44 sleepy kernel: [171829.096957] CPU 4=20
Mar 19 14:53:44 sleepy kernel: [171829.096959] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171829.097070]=20
Mar 19 14:53:44 sleepy kernel: [171829.097074] Pid: 0, comm: swapper/4 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171829.097080] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171829.097087] RSP: 0018:ffff880626a99e68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171829.097091] RAX: 0000000000000020 RBX:=
 0000000000000008 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171829.097094] RDX: 0000000000000000 RSI:=
 ffff880626a99fd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171829.097098] RBP: 0000000000000003 R08:=
 0000000000000000 R09: 0000000000000f7c
Mar 19 14:53:44 sleepy kernel: [171829.097102] R10: 0000000000000293 R11:=
 ffff880626a98000 R12: ffff88063fc99970
Mar 19 14:53:44 sleepy kernel: [171829.097106] R13: 0000000000000020 R14:=
 127ccd36c66a8c1d R15: 0000000000000004
Mar 19 14:53:44 sleepy kernel: [171829.097110] FS:  0000000000000000(0000=
) GS:ffff88063fc80000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.097114] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171829.097118] CR2: 00007f1b78ee6000 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171829.097121] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.097125] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171829.097129] Process swapper/4 (pid: 0,=
 threadinfo ffff880626a98000, task ffff880626a6e8a0)
Mar 19 14:53:44 sleepy kernel: [171829.097134]  0000000000000000 ffffffff=
81264602 0000000000000000 00000000003c800f
Mar 19 14:53:44 sleepy kernel: [171829.097141]  0000000000000000 00000004=
003c800f ffff88063fc99970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171829.097148]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171829.097160]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.097165]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.097171]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.097176]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.097229] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171829.097233]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.097239]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.097244]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.097248]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.097254] NMI backtrace for cpu 5
Mar 19 14:53:44 sleepy kernel: [171829.097256] CPU 5=20
Mar 19 14:53:44 sleepy kernel: [171829.097257] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171829.097347]=20
Mar 19 14:53:44 sleepy kernel: [171829.097350] Pid: 0, comm: swapper/5 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171829.097355] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171829.097361] RSP: 0018:ffff880626aade68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171829.097364] RAX: 0000000000000020 RBX:=
 0000000000000008 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171829.097367] RDX: 0000000000000000 RSI:=
 ffff880626aadfd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171829.097370] RBP: 0000000000000003 R08:=
 0000000000000000 R09: 0000000000000f81
Mar 19 14:53:44 sleepy kernel: [171829.097372] R10: 0000000000000206 R11:=
 ffff880626aac000 R12: ffff88063fcb9970
Mar 19 14:53:44 sleepy kernel: [171829.097375] R13: 0000000000000020 R14:=
 127ccd36c66a7cec R15: 0000000000000005
Mar 19 14:53:44 sleepy kernel: [171829.097379] FS:  0000000000000000(0000=
) GS:ffff88063fca0000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.097382] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171829.097385] CR2: 00000000013b3f64 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171829.097388] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.097391] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171829.097394] Process swapper/5 (pid: 0,=
 threadinfo ffff880626aac000, task ffff880626a9c200)
Mar 19 14:53:44 sleepy kernel: [171829.097398]  0000000000000000 ffffffff=
81264602 0000000000000000 00000000003c936b
Mar 19 14:53:44 sleepy kernel: [171829.097403]  0000000000000000 00000005=
003c936b ffff88063fcb9970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171829.097408]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171829.097418]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.097423]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.097428]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.097432]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.097471] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171829.097475]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.097479]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.097483]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.097487]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.097491] NMI backtrace for cpu 6
Mar 19 14:53:44 sleepy kernel: [171829.097494] CPU 6=20
Mar 19 14:53:44 sleepy kernel: [171829.097496] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171829.097613]=20
Mar 19 14:53:44 sleepy kernel: [171829.097617] Pid: 0, comm: swapper/6 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171829.097624] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171829.097632] RSP: 0018:ffff880626ae5e68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171829.097635] RAX: 0000000000000020 RBX:=
 0000000000000008 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171829.097640] RDX: 0000000000000000 RSI:=
 ffff880626ae5fd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171829.097643] RBP: 0000000000000003 R08:=
 0000000000000000 R09: 0000000000000f89
Mar 19 14:53:44 sleepy kernel: [171829.097647] R10: ffff8806232d2200 R11:=
 ffff880626ae4000 R12: ffff88063fcd9970
Mar 19 14:53:44 sleepy kernel: [171829.097651] R13: 0000000000000020 R14:=
 127ccd36c66a57f7 R15: 0000000000000006
Mar 19 14:53:44 sleepy kernel: [171829.097656] FS:  0000000000000000(0000=
) GS:ffff88063fcc0000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.097660] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171829.097664] CR2: 00007f7f5ba3b000 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171829.097668] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.097672] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171829.097677] Process swapper/6 (pid: 0,=
 threadinfo ffff880626ae4000, task ffff880626ae3720)
Mar 19 14:53:44 sleepy kernel: [171829.097682]  0000000000000000 ffffffff=
81264602 0000000000000000 00000000003cb1ae
Mar 19 14:53:44 sleepy kernel: [171829.097689]  0000000000000000 00000006=
003cb1ae ffff88063fcd9970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171829.097696]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171829.097709]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.097715]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.097721]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.097726]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.097781] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171829.097786]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.097792]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.097797]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.097802]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.097807] NMI backtrace for cpu 7
Mar 19 14:53:44 sleepy kernel: [171829.097811] CPU 7=20
Mar 19 14:53:44 sleepy kernel: [171829.097813] Modules linked in: nls_utf=
8 nls_cp437 vfat fat usb_storage uas ip6table_filter ip6_tables ebtable_n=
at ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parpo=
rt rfcomm bnep acpi_cpufreq mperf bluetooth cpufreq_userspace rfkill cpuf=
req_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fuse =
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon_v=
id coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gener=
ic cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_rea=
ltek snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq fglrx(P) snd_hda=
_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse =
snd_timer snd_seq_device i2c_i801 serio_raw evdev mxm_wmi snd pcspkr soun=
dcore i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_support i7core_edac ed=
ac_co
Mar 19 14:53:44 sleepy kernel: re asus_atk0110 wmi button processor therm=
al_sys ext3 jbd mbcache dm_mod sr_mod sd_mod cdrom usbhid hid crc_t10dif =
xhci_hcd uhci_hcd r8169 firewire_ohci mii firewire_core crc_itu_t ahci li=
bahci libata scsi_mod ehci_hcd usbcore usb_common [last unloaded: scsi_wa=
it_scan]
Mar 19 14:53:44 sleepy kernel: [171829.097940]=20
Mar 19 14:53:44 sleepy kernel: [171829.097944] Pid: 0, comm: swapper/7 Ta=
inted: P        W  O 3.2.0-1-amd64 #1 System manufacturer System Product =
Name/SABERTOOTH X58
Mar 19 14:53:44 sleepy kernel: [171829.097951] RIP: 0010:[<ffffffff811e38=
f8>]  [<ffffffff811e38f8>] intel_idle+0xb9/0x119
Mar 19 14:53:44 sleepy kernel: [171829.097960] RSP: 0018:ffff880626b17e68=
  EFLAGS: 00000046
Mar 19 14:53:44 sleepy kernel: [171829.097963] RAX: 0000000000000020 RBX:=
 0000000000000008 RCX: 0000000000000001
Mar 19 14:53:44 sleepy kernel: [171829.097968] RDX: 0000000000000000 RSI:=
 ffff880626b17fd8 RDI: ffffffff81611480
Mar 19 14:53:44 sleepy kernel: [171829.097972] RBP: 0000000000000003 R08:=
 0000000000000000 R09: 0000000000000f8d
Mar 19 14:53:44 sleepy kernel: [171829.097977] R10: 0000000000000293 R11:=
 ffff880626b16000 R12: ffff88063fcf9970
Mar 19 14:53:44 sleepy kernel: [171829.097981] R13: 0000000000000020 R14:=
 127ccd36c66a5237 R15: 0000000000000007
Mar 19 14:53:44 sleepy kernel: [171829.097986] FS:  0000000000000000(0000=
) GS:ffff88063fce0000(0000) knlGS:0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.097991] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Mar 19 14:53:44 sleepy kernel: [171829.097995] CR2: 00000000019f7000 CR3:=
 0000000001605000 CR4: 00000000000006e0
Mar 19 14:53:44 sleepy kernel: [171829.097999] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Mar 19 14:53:44 sleepy kernel: [171829.098004] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 14:53:44 sleepy kernel: [171829.098009] Process swapper/7 (pid: 0,=
 threadinfo ffff880626b16000, task ffff880626aef080)
Mar 19 14:53:44 sleepy kernel: [171829.098015]  0000000000000000 ffffffff=
81264602 0000000000000000 00000000003cc02c
Mar 19 14:53:44 sleepy kernel: [171829.098022]  0000000000000000 00000007=
003cc02c ffff88063fcf9970 ffffffff81645680
Mar 19 14:53:44 sleepy kernel: [171829.098030]  00000000fffffff0 00000000=
00000003 ffffffff81645778 ffffffff81263733
Mar 19 14:53:44 sleepy kernel: [171829.098044]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.098050]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.098057]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.098062]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db
Mar 19 14:53:44 sleepy kernel: [171829.098123] Call Trace:
Mar 19 14:53:44 sleepy kernel: [171829.098129]  [<ffffffff81264602>] ? me=
nu_select+0x198/0x2c1
Mar 19 14:53:44 sleepy kernel: [171829.098135]  [<ffffffff81263733>] ? cp=
uidle_idle_call+0xec/0x179
Mar 19 14:53:44 sleepy kernel: [171829.098141]  [<ffffffff8100d255>] ? cp=
u_idle+0xa5/0xf2
Mar 19 14:53:44 sleepy kernel: [171829.098146]  [<ffffffff81332cda>] ? st=
art_secondary+0x1d5/0x1db

--------------000100000006000905080509
Content-Type: text/plain;
 name="ver_linux"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ver_linux"

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
=20
Linux sleepy 3.2.0-1-amd64 #1 SMP Sun Feb 5 15:17:15 UTC 2012 x86_64 GNU/=
Linux
=20
Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.19.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.7
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.3
oprofile               0.9.6
Sh-utils               8.13
Modules Loaded         usb_storage uas ip6table_filter ip6_tables ebtable=
_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defr=
ag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tc=
pudp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp par=
port rfcomm bnep acpi_cpufreq bluetooth mperf rfkill cpufreq_userspace cp=
ufreq_powersave cpufreq_stats cpufreq_conservative binfmt_misc uinput fus=
e nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 crc16 hwmon=
_vid coretemp loop firewire_sbp2 sha256_generic cryptd aes_x86_64 aes_gen=
eric cbc dm_crypt kvm_intel kvm snd_hda_codec_hdmi joydev snd_hda_codec_r=
ealtek fglrx snd_pcm_oss snd_hda_intel snd_mixer_oss snd_hda_codec snd_hw=
dep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer=
 evdev mxm_wmi snd_seq_device psmouse serio_raw snd pcspkr i2c_i801 sound=
core i2c_core iTCO_wdt snd_page_alloc iTCO_vendor_support i7core_edac eda=
c_core asus_atk0110 wmi button processor thermal_sys ext3 jbd mbcache dm_=
mod sr_mod sd_mod cdrom usbhid hid crc_t10dif uhci_hcd firewire_ohci ahci=
 firewire_core r8169 crc_itu_t libahci mii libata scsi_mod ehci_hcd xhci_=
hcd usbcore usb_common

--------------000100000006000905080509--

--------------ms090000060505060002060309
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIUXjCC
BjQwggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDE1NVoXDTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOr
lr6KMoOMpohBllVHrdRvEg/q6r8jR+EK75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSM
zR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6
qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxDz2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSD
kOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr/+N2JLKutIxMYqQOJebr/f/h5t95
m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFcfH6WNU7y1LhRgjAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqD
CH14qywGXLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy
6QMVQjbbMXltUfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPI
zKKR9tQW8gGK+2+RHxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKf
KSETEPrHh7p5shuuNktvsv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HOR
z9v3vQwR4e3ksLc2JZOAFK+ssS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9
sIPP7ON0fz095HdThKjiVJe6vofq+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCie
uoBJ9OlqmsVWQvifIYf40dJPZkk9YgGTzWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7t
w1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGqUp/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQ
G2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb19mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t
5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIHDzCCBfegAwIBAgIDA3XdMA0GCSqGSIb3DQEB
BQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20g
Q2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTExMjI5MDIwMTE1
WhcNMTIxMjI5MDcwOTU0WjBaMSAwHgYDVQQNExc2MDM2NDAtdk9JNkVYMzh3QWJnajNoOTEX
MBUGA1UEAwwObWF0ZUBzcmxhYnMuZGUxHTAbBgkqhkiG9w0BCQEWDm1hdGVAc3JsYWJzLmRl
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy34IQMIt7s+kkiFJPGs5LdAz/p/h
N6m9TTEkq9bxDgFNgJU4VyEJ76hNuPNEhchZ4KDwGpmsmd71Zp7B2itq92tf3XyBi+75fO6Z
mWkSv0Nr6tYkVYkwzSGUrzpXv977y6zPfIH+o5ZVssMpqK3XlLJaBezg3uYIjlNqK9UVZLXK
LuwLJZNl89qFKQdYsM046grguyHlfVzv9jgqDxcBvIvH593T6TUYpOV53+1P2tnlYyGo+qIh
KkgG2xqj/uxjifbpsu+qJ4IFHuyJ+SUjOLc7VmYnQjhGhtWgxzwwiklHjcpIoEaKNDWCL/qQ
Py3DBabM4U+4hKFZtkVSVFRq6wIDAQABo4IDqTCCA6UwCQYDVR0TBAIwADALBgNVHQ8EBAMC
BLAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBTI3pdodapXL5ph
A705sPRZG/HigTAfBgNVHSMEGDAWgBRTcu2SnODaywFcfH6WNU7y1LhRgjAZBgNVHREEEjAQ
gQ5tYXRlQHNybGFicy5kZTCCAiEGA1UdIASCAhgwggIUMIICEAYLKwYBBAGBtTcBAgIwggH/
MC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMDQGCCsG
AQUFBwIBFihodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9pbnRlcm1lZGlhdGUucGRmMIH3Bggr
BgEFBQcCAjCB6jAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+
VGhpcyBjZXJ0aWZpY2F0ZSB3YXMgaXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMSBW
YWxpZGF0aW9uIHJlcXVpcmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCByZWxp
YW5jZSBvbmx5IGZvciB0aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRo
ZSByZWx5aW5nIHBhcnR5IG9ibGlnYXRpb25zLjCBnAYIKwYBBQUHAgIwgY8wJxYgU3RhcnRD
b20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwAwIBAhpkTGlhYmlsaXR5IGFuZCB3YXJyYW50
aWVzIGFyZSBsaW1pdGVkISBTZWUgc2VjdGlvbiAiTGVnYWwgYW5kIExpbWl0YXRpb25zIiBv
ZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
LnN0YXJ0c3NsLmNvbS9jcnR1MS1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUF
BzABhi1odHRwOi8vb2NzcC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMS9jbGllbnQvY2EwQgYI
KwYBBQUHMAKGNmh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczEuY2xp
ZW50LmNhLmNydDAjBgNVHRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZI
hvcNAQEFBQADggEBAHeHBdBPPObrXaZ+lQ47D/5oAMnUzc2WZbuzRFRCXvkCznNQieTPvA9+
Qq6PHEhaQj2FOOtXpotspiowgtkilE9Ci+6w/WEQ0zOPDVkPtwoYrDlyedjVqykKG8eYDuH6
6PFt97VB5VWR1wIsTQ+GEoJM7YGUZpx52EGfU1KnqUczaKerY5OakFKhCo5PI0mabgQElwRR
OksLrg14WL2j6j71exvisZ7/XdxzVDOtWwW0OSZq1NHZ7oWbv60XcA1hC4u6XHlowEdTv5d2
aAD8nA6aFFhokqgLtjsXRtjHFrs9L3w5O8GJdYgTAWVCGN5+ErBdtuitQLVEckOsDE4gAdUw
ggcPMIIF96ADAgECAgMDdd0wDQYJKoZIhvcNAQEFBQAwgYwxCzAJBgNVBAYTAklMMRYwFAYD
VQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0
ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRp
YXRlIENsaWVudCBDQTAeFw0xMTEyMjkwMjAxMTVaFw0xMjEyMjkwNzA5NTRaMFoxIDAeBgNV
BA0TFzYwMzY0MC12T0k2RVgzOHdBYmdqM2g5MRcwFQYDVQQDDA5tYXRlQHNybGFicy5kZTEd
MBsGCSqGSIb3DQEJARYObWF0ZUBzcmxhYnMuZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDLfghAwi3uz6SSIUk8azkt0DP+n+E3qb1NMSSr1vEOAU2AlThXIQnvqE2480SF
yFngoPAamayZ3vVmnsHaK2r3a1/dfIGL7vl87pmZaRK/Q2vq1iRViTDNIZSvOle/3vvLrM98
gf6jllWywymordeUsloF7ODe5giOU2or1RVktcou7Aslk2Xz2oUpB1iwzTjqCuC7IeV9XO/2
OCoPFwG8i8fn3dPpNRik5Xnf7U/a2eVjIaj6oiEqSAbbGqP+7GOJ9umy76onggUe7In5JSM4
tztWZidCOEaG1aDHPDCKSUeNykigRoo0NYIv+pA/LcMFpszhT7iEoVm2RVJUVGrrAgMBAAGj
ggOpMIIDpTAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwHQYDVR0OBBYEFMjel2h1qlcvmmEDvTmw9Fkb8eKBMB8GA1UdIwQYMBaAFFNy
7ZKc4NrLAVx8fpY1TvLUuFGCMBkGA1UdEQQSMBCBDm1hdGVAc3JsYWJzLmRlMIICIQYDVR0g
BIICGDCCAhQwggIQBgsrBgEEAYG1NwECAjCCAf8wLgYIKwYBBQUHAgEWImh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cuc3RhcnRz
c2wuY29tL2ludGVybWVkaWF0ZS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0YXJ0Q29tIENl
cnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1
ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRzIG9m
IHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRl
ZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlv
bnMuMIGcBggrBgEFBQcCAjCBjzAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTADAgECGmRMaWFiaWxpdHkgYW5kIHdhcnJhbnRpZXMgYXJlIGxpbWl0ZWQhIFNlZSBzZWN0
aW9uICJMZWdhbCBhbmQgTGltaXRhdGlvbnMiIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ku
MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5j
cmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3Ns
LmNvbS9zdWIvY2xhc3MxL2NsaWVudC9jYTBCBggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFy
dHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMS5jbGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG9w0BAQUFAAOCAQEAd4cF0E885utdpn6V
DjsP/mgAydTNzZZlu7NEVEJe+QLOc1CJ5M+8D35Cro8cSFpCPYU461emi2ymKjCC2SKUT0KL
7rD9YRDTM48NWQ+3ChisOXJ52NWrKQobx5gO4fro8W33tUHlVZHXAixND4YSgkztgZRmnHnY
QZ9TUqepRzNop6tjk5qQUqEKjk8jSZpuBASXBFE6SwuuDXhYvaPqPvV7G+Kxnv9d3HNUM61b
BbQ5JmrU0dnuhZu/rRdwDWELi7pceWjAR1O/l3ZoAPycDpoUWGiSqAu2OxdG2McWuz0vfDk7
wYl1iBMBZUIY3n4SsF226K1AtURyQ6wMTiAB1TGCA9AwggPMAgEBMIGUMIGMMQswCQYDVQQG
EwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwg
Q2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5
IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwN13TAJBgUrDgMCGgUAoIICEDAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMjAzMTkxNDUxNDNaMCMGCSqGSIb3
DQEJBDEWBBRpgERC8/8i/2VcwGnfD/g2Gc/VPTBfBgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgwgaUGCSsGAQQBgjcQBDGBlzCBlDCBjDELMAkGA1UEBhMCSUwx
FjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRp
ZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRl
cm1lZGlhdGUgQ2xpZW50IENBAgMDdd0wgacGCyqGSIb3DQEJEAILMYGXoIGUMIGMMQswCQYD
VQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0
YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmlt
YXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwN13TANBgkqhkiG9w0BAQEFAASCAQBV+7Sr
AIsFZP8MSOZL1f0zuRFjG9ytIL/4IT1hyykHvfpmH2dLX/HpLFFMTJTMmS7X7iBEKeEdb3Ia
4mRJK/NU68021tahq3tHQDLI7UFJ4z4+bz00qrff+ZFXoHAZY7qP5y7s5qAwzkRZIQFE+jTU
jgdY664KXwO3Chhcek8O4lHKeLVGs53RKeWclMVhY+igRzBh5nYBWQNANxPmKAD52g5+lknb
M8d0l3R+VPsPndjIn0Gbxo+sy1mkFmNzzOiOY/dEW45ZFQnoaDDuc0zq40dCvv++t6q9jF4t
Tzxn2eY9CkzDDW6g1tOUHpHnGv1euWKk3RsJxn3qW3O3y6DgAAAAAAAA
--------------ms090000060505060002060309--
