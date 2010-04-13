Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab0DMSox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:44:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:52300 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0DMSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=VZD9dOPE+7/HQumL05m+2Jh0cmXaIXhQ12ve/6RPoPOLEc2grTlrsN9SvDDOF329lx
         jk5BG9ZWxB7tZrCgyTczxUxZgE5bNZW/2jUoPec29hc0CxANAbXDqZdsbaPKG7B1gI8A
         3hZLlbv2yBkWUIAkWFm/1vAldccTBUgqlcU3c=
From: =?utf-8?q?Pawe=C5=82_Drobek?= <pawel.drobek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Possible issue with pcmcia data card since 2.6.27 kernel
Date: Tue, 13 Apr 2010 20:44:37 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-gentoo; KDE/4.4.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2488807.Y0cVWplMvR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201004132044.42056.pawel.drobek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2488807.Y0cVWplMvR
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

[1.] ZTE MF 330 as modem, not as usb 2.0 hub
=2D-------------------------------------------
[2.] Since 2.6.27-r7 there is support for this pcmcia data card by usbserial
 module. In option.c file there isn't correct ID for ZTE MF 330 modem. I=20
assume that for somebody is correct but not for me and possibly other.=20
=2D-------------------------------------------
[3.] usbserial.ko, option.ko, zte mf 330
=2D-------------------------------------------
[4.] Linux version 2.6.33-gentoo (root@pd-mainframe) (gcc version 4.4.3=20
(Gentoo 4.4.3 p1.0) ) #5 SMP Sat Apr 10 21:56:07 CEST 2010
=2D-------------------------------------------
[5.] N/A
=2D-------------------------------------------
[6.] N/A
=2D-------------------------------------------
[7.] Environment
[7.1.] Linux pd-mainframe 2.6.33-gentoo #5 SMP Sat Apr 10 21:56:07 CEST 201=
0=20
x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ AuthenticAMD GNU/Linux
=20
Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20.1.20100303
util-linux             2.17.2
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.11
pcmciautils            016
PPP                    2.4.4
Linux C Library        2.11
Dynamic linker (ldd)   2.11
Procps                 3.2.8
Net-tools              1.60_p20100101055920
Kbd                    1.15.1
Sh-utils               8.4
wireless-tools         29
Modules Loaded         ipv6 iptable_filter iptable_mangle ipt_MASQUERADE=20
xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_raw=20
ipt_addrtype xt_DSCP xt_dscp xt_string xt_NFQUEUE xt_multiport xt_MARK xt_m=
ark=20
xt_hashlimit xt_conntrack xt_CONNMARK xt_connmark nf_conntrack ip_tables=20
x_tables w83627ehf hwmon_vid snd_seq_oss snd_seq_midi_event snd_seq=20
snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_codec_realtek nvidia=20
tuner_simple tuner_types tuner tvaudio tda7432 bttv snd_hda_intel v4l2_comm=
on=20
snd_hda_codec i2c_algo_bit videobuf_dma_sg videobuf_core snd_hwdep snd_pcm=
=20
btcx_risc irtty_sir sir_dev tveeprom snd_timer usbserial snd yenta_socket i=
rda=20
rtc_cmos i2c_nforce2 rsrc_nonstatic thermal k8temp snd_page_alloc i2c_core=
=20
forcedeth pcspkr processor button crc_ccitt scsi_transport_iscsi tg3 libphy=
=20
e1000 fuse nfs lockd sunrpc raid10 raid456 async_raid6_recov async_memcpy=20
async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_bbr dm_snapshot=20
dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci139=
4=20
ieee1394 usbhid aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox=20
megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas=20
scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase=
=20
atp870u dc395x qla1280 imm dmx3191d sym53c8xx gdth advansys initio BusLogic=
=20
arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv=
=20
ata_piix sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_via sata_svw=20
sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via=20
pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_o=
ld=20
pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmci=
a=20
pcmcia firmware_class pcmcia_core pata_ns87415 pata_ns87410 pata_serverwork=
s=20
pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3=
=20
pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680=20
pata_radisys pata_pdc2027x pata_mpiix
=2D-------------------------------------------
[7.2-7.7] N/A
=2D-------------------------------------------
[X.] Simply when i have changed option.c file in=20
/usr/src/linux/drivers/usb/serial/option.c by adding=20

{ USB_DEVICE(0x1D6B, 0x0002) }, /*ZTE MF 330*/

to static struct usb_device_id option_ids[]
my pc data card was correct detected by kernel.=20
=2D-------------------------------------------
=2D-=20

Z wyrazami szacunku Pawel D

Generic mail phrase generated by fortune

"You're a creature of the night, Michael. Wait'll Mom hears about this." --=
=20
from the movie "The Lost Boys"

=2D----------------------User data-------------------------
Pawel Drobek aka Boss
Linux counter id:349664
Kadu(gg)  - 2355716
Jabber        - p.d@jabster.pl||pawel.drobek@gmail.com
=2D----------------------OS data---------------------------
System      - GNU/Linux
Id               - Gentoo current amd64 12/05/2009
Kernel      - 2.6.33-gentoo
Logged as - pd
=2D--------------------End of data------------------------

--nextPart2488807.Y0cVWplMvR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAkvEu5kACgkQ3aTwtJt4clISwgCfdu5t4rOLaAKeGnwX1genSigR
MewAnjmz9pTgZ+5bdpsamYrs6bd8y0Jn
=uveK
-----END PGP SIGNATURE-----

--nextPart2488807.Y0cVWplMvR--
