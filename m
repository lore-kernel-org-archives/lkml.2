Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab2AXNYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 08:24:31 -0500
Received: from jcz.nl ([213.196.18.5]:53520 "EHLO jcz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab2AXNYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 08:24:30 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jan 2012 08:24:29 EST
Message-ID: <4F1EAF68.8030807@jcz.nl>
Date: Tue, 24 Jan 2012 14:17:28 +0100
From: Jaap Crezee <jaap@jcz.nl>
Reply-To: jaap@jcz.nl
Organization: JCZ-Automatisering
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: hald-addon-stor oops on removing USB storage device
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030901070605080205020101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms030901070605080205020101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello all,

I sometimes (1 out of 10, maybe 20) get the following oops on removing a =
usb stick after running umount & sync (and waiting for them to complete).=

I am running linux 3.2.1. Is this a known issue of some kind? It looks as=
 if this behauviour was not present in kernel versions prior to 2.6.39 bu=
t I have no exact clue...
3.x.y all had the same problem over here.

Jan 24 14:02:33 jaaplaptop kernel: [24025.754785] Oops: 0000 [#1] PREEMPT=
 SMP
Jan 24 14:02:33 jaaplaptop kernel: [24025.754813] CPU 0
Jan 24 14:02:33 jaaplaptop kernel: [24025.754824] Modules linked in: ipaq=
 pl2303 ftdi_sio usbserial nls_cp437 vfat fat usb_storage uas tun nfsd ex=
portfs nfs nfs_acl lockd auth_rpcgss fscache sunrpc
ipv6 ext3 jbd snd_hda_codec_hdmi snd_hda_codec_idt joydev hid_microsoft u=
sbhid hid btusb bluetooth arc4 iwlwifi snd_hda_intel snd_hda_codec snd_hw=
dep snd_pcm snd_page_alloc snd_timer mac80211 snd
cfg80211 pcmcia i915 drm_kms_helper dell_wmi sparse_keymap ppdev evdev dr=
m parport_pc firewire_ohci sdhci_pci yenta_socket rfkill intel_agp sdhci =
pcmcia_rsrc firewire_core iTCO_wdt pcmcia_core
crc_itu_t iTCO_vendor_support psmouse e1000e serio_raw i2c_i801 i2c_algo_=
bit wmi processor ac parport intel_gtt mmc_core intel_ips soundcore butto=
n battery video kvm_intel kvm synaptics_i2c i2c_core
coretemp vboxnetflt(O) vboxdrv(O) ext4 mbcache jbd2 crc16 sr_mod cdrom sd=
_mod ahci libahci libata scsi_mod ehci_hcd usbcore usb_common [last unloa=
ded: ftdi_sio]
Jan 24 14:02:33 jaaplaptop kernel: [24025.755480]
Jan 24 14:02:33 jaaplaptop kernel: [24025.755491] Pid: 19567, comm: hald-=
addon-stor Tainted: G           O 3.2.1-1-ARCH #1 Dell Inc. Latitude E651=
0/02K3Y4
Jan 24 14:02:33 jaaplaptop kernel: [24025.755533] RIP: 0010:[<ffffffffa00=
710e5>]  [<ffffffffa00710e5>] sd_revalidate_disk+0x35/0x1c90 [sd_mod]
Jan 24 14:02:33 jaaplaptop kernel: [24025.755572] RSP: 0018:ffff880210413=
a28  EFLAGS: 00010246
Jan 24 14:02:33 jaaplaptop kernel: [24025.755592] RAX: 0000000000000000 R=
BX: 0000000000000000 RCX: 0000000000000002
Jan 24 14:02:33 jaaplaptop kernel: [24025.755617] RDX: 0000000000000000 R=
SI: ffff8800cd8b6400 RDI: ffff8801f0989400
Jan 24 14:02:33 jaaplaptop kernel: [24025.755642] RBP: ffff880210413ae8 R=
08: 0000000800000000 R09: 00000008ffffffff
Jan 24 14:02:33 jaaplaptop kernel: [24025.755672] R10: 0000000000000001 R=
11: ffffc90000808000 R12: ffff8801f0989400
Jan 24 14:02:33 jaaplaptop kernel: [24025.755704] R13: 00000000ffffff85 R=
14: ffff880210138718 R15: ffff8801f0989400
Jan 24 14:02:33 jaaplaptop kernel: [24025.755738] FS:  00007f286a6bd700(0=
000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
Jan 24 14:02:33 jaaplaptop kernel: [24025.755779] CS:  0010 DS: 0000 ES: =
0000 CR0: 000000008005003b
Jan 24 14:02:33 jaaplaptop kernel: [24025.755812] CR2: 0000000000000008 C=
R3: 00000001f0a3a000 CR4: 00000000000006f0
Jan 24 14:02:33 jaaplaptop kernel: [24025.755847] DR0: 0000000000000000 D=
R1: 0000000000000000 DR2: 0000000000000000
Jan 24 14:02:33 jaaplaptop kernel: [24025.755883] DR3: 0000000000000000 D=
R6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 24 14:02:33 jaaplaptop kernel: [24025.755920] Process hald-addon-stor=
 (pid: 19567, threadinfo ffff880210412000, task ffff8801bfda63c0)
Jan 24 14:02:33 jaaplaptop kernel: [24025.755965] Stack:
Jan 24 14:02:33 jaaplaptop kernel: [24025.755979]  ffff880210413a78 fffff=
fff811817a4 ffff880210413a78 ffffffff8119d700
Jan 24 14:02:33 jaaplaptop kernel: [24025.756023]  ffff8801f098d020 ffff8=
801f0989448 0000000000000000 00000000ffffff85
Jan 24 14:02:33 jaaplaptop kernel: [24025.756072]  ffff880210413a98 fffff=
fff81169423 ffff8801f0989400 ffff8802101387f8
Jan 24 14:02:33 jaaplaptop kernel: [24025.756121] Call Trace:
Jan 24 14:02:33 jaaplaptop kernel: [24025.756144]  [<ffffffff811817a4>] ?=
 iget5_locked+0x94/0x1f0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756173]  [<ffffffff8119d700>] ?=
 bdev_test+0x20/0x20
Jan 24 14:02:33 jaaplaptop kernel: [24025.756200]  [<ffffffff81169423>] ?=
 get_super+0x73/0xd0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756224]  [<ffffffff81181948>] ?=
 iput+0x48/0x210
Jan 24 14:02:33 jaaplaptop kernel: [24025.756252]  [<ffffffff811d359a>] r=
escan_partitions+0xaa/0x4d0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756292]  [<ffffffff8119f06e>] _=
_blkdev_get+0x2ce/0x430
Jan 24 14:02:33 jaaplaptop kernel: [24025.756324]  [<ffffffff8117a120>] ?=
 poll_freewait+0xe0/0xe0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756356]  [<ffffffff8119f223>] b=
lkdev_get+0x53/0x310
Jan 24 14:02:33 jaaplaptop kernel: [24025.756384]  [<ffffffff8119f53d>] b=
lkdev_open+0x5d/0x80
Jan 24 14:02:33 jaaplaptop kernel: [24025.756418]  [<ffffffff81165060>] _=
_dentry_open+0x310/0x3f0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756449]  [<ffffffff8119f4e0>] ?=
 blkdev_get+0x310/0x310
Jan 24 14:02:33 jaaplaptop kernel: [24025.756482]  [<ffffffff81172f60>] ?=
 do_lookup+0x50/0x3d0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756515]  [<ffffffff81166371>] n=
ameidata_to_filp+0x71/0x80
Jan 24 14:02:33 jaaplaptop kernel: [24025.756551]  [<ffffffff81176575>] d=
o_last+0x185/0x970
Jan 24 14:02:33 jaaplaptop kernel: [24025.756582]  [<ffffffff81176e72>] p=
ath_openat+0xd2/0x3c0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756614]  [<ffffffff81177282>] d=
o_filp_open+0x42/0xa0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756649]  [<ffffffff811839ac>] ?=
 alloc_fd+0xec/0x140
Jan 24 14:02:33 jaaplaptop kernel: [24025.756683]  [<ffffffff81166477>] d=
o_sys_open+0xf7/0x1d0
Jan 24 14:02:33 jaaplaptop kernel: [24025.756717]  [<ffffffff81166570>] s=
ys_open+0x20/0x30
Jan 24 14:02:33 jaaplaptop kernel: [24025.756751]  [<ffffffff814290c2
Jan 24 14:02:33 jaaplaptop kernel: [24025.756787]
Jan 24 14:02:33 jaaplaptop kernel: [24025.757094] RIP  [<ffffffffa00710e5=
>] sd_revalidate_disk+0x35/0x1c90 [sd_mod]
Jan 24 14:02:33 jaaplaptop kernel: [24
Jan 24 14:02:33 jaaplaptop kernel: [24025.757171] CR2: 0000000000000008
Jan 24 14:02:33 jaaplaptop kernel: [24025.880389] ---[ end trace 57e76


Kind regards,

Jaap Crezee


--------------ms030901070605080205020101
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFbTCC
BWkwggNRoAMCAQICAwnAGTANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xMTAx
MjgwODEzMDZaFw0xMzAxMjcwODEzMDZaMGIxHjAcBgNVBAMTFUphY29iIEJlbmphbWluIENy
ZXplZTEaMBgGCSqGSIb3DQEJARYLamFhcEBqY3oubmwxJDAiBgkqhkiG9w0BCQEWFWphYXAu
Y3JlemVlQGltdGVjaC5ubDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANnfQCy6
Zrxwlai9XI3qiMDrGK1fFs1OrFjujjwfGCddd/WoXA+5F0dLUtfSxO1YrqTrxRL3WUI/q4Zi
B6AqoPDsp0BcytjTkfILUxwzV2oBkJ29Ksz76fuaroK1IaeOzRujNSzoqKUJNiykISxyIuQM
odYWpuZxMifCKoRUNtMYzOJH1N8dd4IpY1DK7pfTqm9Z/ToY7J7zNlgsC9DYKat1iNGO1HN2
hhjPRAqT9Obc/1Bj9BtbObVi7aa88kzbnzNyenkDH+JmfY75I06SHZXOp37ErQcV3SUBeHWS
uftf/xyKekrhDWL4JM3ELaj9r0+TdhbyV4S1bG03D5IU0zMCAwEAAaOCAQ8wggELMAwGA1Ud
EwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBm
b3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMEAGA1UdJQQ5MDcG
CCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4QgQB
MDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9yZzAt
BgNVHREEJjAkgQtqYWFwQGpjei5ubIEVamFhcC5jcmV6ZWVAaW10ZWNoLm5sMA0GCSqGSIb3
DQEBBQUAA4ICAQB8quzWe1GvQwx1HFBCwMbB+0hthvbmDJP3eJRp2ADumRonhrmuRWaH4pqr
wLmT6V65n56WPmO3Vb1FaZuzSP3sozBYJttwZCtptVny1SCI2E1zTpwii+I0+dmFMD3p5WE6
s+p0pzqdi6uFgKAPtsMh5ZtR/eiSXpzT7MJ892c/t6WvEdNIZHhUan7QhyJfaebrfvdcgdVp
26TYc0AkcLYUrQHNGG9qGykB78VJsPxF25qli2N+p0lQXJNcO4bUE5o7TxF3Q1BwGrVR+Z0C
CLg1HVXUwUNQc/nClhNjy3MFyy0FsvEBERgAtIpm6XZ2qE7IyiwUcXwQlmP1BrOqgXPpoxhn
KuYwNlbn08vxPsNo6/HZx3S8gMQNmcDQ7d/r4Zl8FmDxULHu3I+w83tUq8WfsfbJvry69MMR
Y2OXtd84vai4Bv2Af6cXCBLZtz2aU57EFiIai8dgfa3fbQm5PJPt5u6DYmYR80GVV4P+oN8Q
/EKOGH27VQQmgJq/CYrwFW1Dac5r0/kZP6z8lKtSRWdq6O6RRK5WpiRieOKnJBm0p0/cB5Om
ytuZkW/wkSRXokbGedKhHRO4Ws/Lr0n9Z7yByVKVkWMGvQiFqv34cfTdduAv0xi55v/zL91u
HsS1rSlnVWxLHxVeAOgk8KKaeYiIAquyk4n5xOWIBUdEGNUJ8zGCA5QwggOQAgEBMIGAMHkx
EDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAG
A1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9y
dEBjYWNlcnQub3JnAgMJwBkwCQYFKw4DAhoFAKCCAegwGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMTIwMTI0MTMxNzI4WjAjBgkqhkiG9w0BCQQxFgQUKoVR
gvVDagEm93Q02kkgZfDrdzgwXwYJKoZIhvcNAQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3
DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UE
CxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0
aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAwnAGTCBkwYLKoZI
hvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3
dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJ
KoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAwnAGTANBgkqhkiG9w0BAQEFAASCAQCG
bIUe1Gk4jjJGVeXgUJdCM87g4f79O2MVah7IJcXY5oXUCABxq6UORXB1r/LjNnNR8t/BD7tZ
H3TleXxRdMSowj+NON7N3v17W/eK2KdAbCBh9Dhr2CTWfa8tWn4GtSbCklXoyOXfYGjn/SmY
yAPA+wNTaVlTyGmUfcGJSz2FRPdbuM7arm4zs5dAiCj2hP5/pBnGacQ0nj5LPmZ46PNOZHdG
j2Q9psJhWzhMjHPYubTePaK40Bf//phFLUd4LGKv73Qfn7HW94Ie4G+aQs4YriJRi6jgj8OF
vTHEgziBwaumtPUTYxXtg0rkPG7CF/e6gGR2TD6MorB09KtjUa7lAAAAAAAA
--------------ms030901070605080205020101--
