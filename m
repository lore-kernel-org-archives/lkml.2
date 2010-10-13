Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab0JMV0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:26:11 -0400
Received: from nm15-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.252]:38288
	"HELO nm15-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751093Ab0JMV0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:26:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 584040.77393.bm@omp1005.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=GExX5y5TZJVYbt6HXZlm+qX2+eDFubIS8Zg3LQ4/MzgvGQc0au+2RwXNTjKK5LFNR552WGeaoZuuUDeEangrhhwtpaKA7J3mJgiEVnWZfiBMECAvtSp0P4QL2xLOgYG9TXmZv0AAjpX8VfnNCz74GnmtQYd032puxpZwwBa43is=;
Message-ID: <525063.83798.qm@web25404.mail.ukl.yahoo.com>
X-YMail-OSG: U0VZwNwVM1liLmFbyIPUJsxpG9PpS7Q99sZBNIGQjfYHXYJ
 9WSSvWtR6NdiEPGLdxIoWvsrodO0wbAK02jFPwnhNmG4ADUAIQf_qNYf7G7d
 19U9jJp80g9wnAfoF5E6eD5DSQOUr_O3ND77JSDC2fGwS8lqWkyPhXo0vt7F
 w_BUOxfTx53VKUM_.Qx.LqCNfZGVVtFYuGCfSNOXwhgTehnrxNcWvL7gB2sD
 ZbxcacSm0AiSj0cBU49ZEoBUItQbojC1O8.q7KNqaMh7CSR7h4SxjG0I1Ozl
 d.qmdG2MybEB6ke8HvJ0.0qbD3Q7su.aQ
X-Mailer: YahooMailRC/504.5 YahooMailWebService/0.8.106.282862
Date: Wed, 13 Oct 2010 22:26:02 +0100 (BST)
From: fabio tirapelle <ftirapelle@yahoo.it>
Subject: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@kernellabs.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1768804196-1287005162=:83798"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1768804196-1287005162=:83798
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

=0A Yesterday I have installed (added not substituted) a new tuner: Hauppau=
ge =0ANova-T Stick 3=0A Today the  WinTV-HVR-1120 doesn't works.=0A I attac=
h my /var/log/messages=0A=0A lsusb=0A=0A Bus 004 Device 001: ID 1d6b:0001 L=
inux Foundation 1.1 root hub=0A Bus 003 Device 002: ID 15c2:0036 SoundGraph=
 Inc.=0A Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub=0A =
Bus 002 Device 002: ID 2040:7070 Hauppauge Nova-T Stick 3=0A Bus 002 Device=
 001: ID 1d6b:0002 Linux Foundation 2.0 root hub=0A Bus 001 Device 001: ID =
1d6b:0002 Linux Foundation 2.0 root hub=0A=0A=0A lscpi=0A=0A 00:00.0 RAM me=
mory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller=0A (rev a2=
)=0A 00:01.0 ISA bridge: nVidia Corporation MCP78S [GeForce 8200] LPC Bridg=
e (rev =0Aa2)=0A 00:01.1 SMBus: nVidia Corporation MCP78S [GeForce 8200] SM=
Bus (rev a1)=0A 00:01.2 RAM memory: nVidia Corporation MCP78S [GeForce 8200=
] Memory Controller=0A (rev a1)=0A 00:01.3 Co-processor: nVidia Corporation=
 MCP78S [GeForce 8200] Co-Processor =0A(rev=0A a2)=0A 00:01.4 RAM memory: n=
Vidia Corporation MCP78S [GeForce 8200] Memory Controller=0A (rev a1)=0A 00=
:02.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 1.1=
=0A Controller (rev a1)=0A 00:02.1 USB Controller: nVidia Corporation MCP78=
S [GeForce 8200] EHCI USB 2.0=0A Controller (rev a1)=0A 00:04.0 USB Control=
ler: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 1.1=0A Controller (r=
ev a1)=0A 00:04.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] =
EHCI USB 2.0=0A Controller (rev a1)=0A 00:06.0 IDE interface: nVidia Corpor=
ation MCP78S [GeForce 8200] IDE (rev a1)=0A 00:07.0 Audio device: nVidia Co=
rporation MCP72XE/MCP72P/MCP78U/MCP78S High=0A Definition Audio (rev a1)=0A=
 00:08.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (r=
ev =0Aa1)=0A 00:09.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200=
] SATA Controller=0A (non-AHCI mode) (rev a2)=0A 00:0a.0 Ethernet controlle=
r: nVidia Corporation MCP77 Ethernet (rev a2)=0A 00:0b.0 PCI bridge: nVidia=
 Corporation MCP78S [GeForce 8200] PCI Express Bridge=0A (rev a1)=0A 00:10.=
0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express Bridge=
=0A (rev a1)=0A 00:12.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200=
] PCI Express Bridge=0A (rev a1)=0A 00:18.0 Host bridge: Advanced Micro Dev=
ices [AMD] K8 [Athlon64/Opteron]=0A HyperTransport Technology Configuration=
=0A 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 Address=0A Map=0A 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [At=
hlon64/Opteron] DRAM=0A Controller=0A 00:18.3 Host bridge: Advanced Micro D=
evices [AMD] K8 [Athlon64/Opteron]=0A Miscellaneous Control=0A 01:06.0 Mult=
imedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135=0A Video =
Broadcast Decoder (rev d1)=0A 01:07.0 Network controller: Techsan Electroni=
cs Co Ltd B2C2 FlexCopII DVB chip =0A/=0A Technisat SkyStar2 DVB card (rev =
02)=0A 02:00.0 VGA compatible controller: nVidia Corporation C77 [GeForce 8=
200] (rev=0A a2)=0A=0A=0A> ----- Messaggio originale -----=0A> > Da: Bjorn =
 Helgaas <bjorn.helgaas@hp.com>=0A> > A: fabio  tirapelle <ftirapelle@yahoo=
.it>=0A> > Cc: linux-kernel@vger.kernel.org;  Michael Krufky <mkrufky@kerne=
llabs.com>=0A> >  Inviato: Mer 13 ottobre 2010, 21:54:31=0A> > Oggetto: Re:=
 Hauppauge  WinTV-HVR-1120 on Unbuntu 10.04=0A> > =0A> > On Wednesday, Octo=
ber 13, 2010  01:02:11 pm fabio tirapelle wrote:=0A> > > After  upgrading f=
rom  Ubuntu 9.10 to Ubuntu 10.04 my Hauppauge =0A>WinTV-HVR-1120 =0A>=0A> >=
=0A> >  >  (sometimes) doesn't work correctly.=0A> > > I get random the  fo=
llowing  errors:=0A> > > =0A> > > tda18271_write_regs: ERROR:  idx =3D 0x5,=
 len =3D 1,  i2c_transfer returned: =0A-5=0A> > > tda18271_init:  error -5 =
on line 826=0A> > >  tda18271_tune: error -5 on line  904=0A> > > tda18271_=
set_params: error -5 on  line 985=0A> > =0A> > I cc'd Michael since he made=
 several recent tda18271   changes.=0A> > =0A> > This page: http://cvs.linu=
xtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner=0A> >  suggests  that the card=
 might work, despite the error messages.   Does=0A> > yours  work?=0A> > =
=0A> > I see that tda18271_write_regs()  uses i2c_transfer(), which uses  t=
he=0A> > adap->algo->master_xfer  function pointer, but I don't know enough=
  to=0A> > figure out which  master_xfer implementation might be used on  y=
our=0A> > system.  A  complete dmesg log and lspci output might have a  hin=
t.=0A> > =0A> >  Can you reproduce this on an upstream kernel?  It would be=
  good  to=0A> > make sure that it's not something introduced by an Ubuntu =
patch   or=0A> > fixed since the Ubuntu kernel snapshot.=0A> > =0A> >  Bjor=
n=0A> > =0A> > > Part of  dmesg of 11-OCT-2010=0A> > > =0A> > > [   53.2161=
53] DVB: registering new  adapter  (saa7133[0])=0A> > > [   53.216156] DVB:=
 registering adapter 2   frontend 0 (NXP TDA10048HN =0A> >DVB-T)...=0A> > >=
 [    53.840013]  tda10048_firmware_upload: waiting for firmware upload =0A=
> >  >  (dvb-fe-tda10048-1.0.fw)...=0A> > > [   53.840019] saa7134  0000:01=
:06.0:  firmware: requesting =0A> >dvb-fe-tda10048-1.0.fw=0A> >  > [   53.8=
80505]  tda10048_firmware_upload: firmware read 24878  bytes.=0A> > > [   5=
3.880509]  tda10048_firmware_upload: firmware  uploading=0A> > > [   58.280=
136]  tda10048_firmware_upload:  firmware uploaded=0A> > > [   59.024537]  =
tda18271_write_regs:  ERROR: idx =3D 0x5, len =3D 1, =0A>i2c_transfer =0A>=
=0A> =0A> > > returned:   -5=0A> > > [   59.024541] tda18271c2_rf_tracking_=
filters_correction:  error  -5 on =0A>line =0A>=0A> >264=0A> > > [   59.420=
153]  tda18271_write_regs: ERROR: idx =3D  0x5, len =3D 1, =0A>i2c_transfer=
 =0A>=0A> =0A> >  > returned: -5=0A> > > [   59.420157]  tda18271_toggle_ou=
tput:  error -5 on line 47=0A> > > [   91.004019]  Clocksource tsc  unstabl=
e (delta =3D -295012684 ns)=0A> > > [  256.293639]  eth0:  link up.=0A> > >=
 [  256.294750] ADDRCONF(NETDEV_CHANGE): eth0:  link  becomes ready=0A> > >=
 [  263.523498] eth0: link  down.=0A> > > [   265.258740] eth0: link up.=0A=
> > > [   266.460026] eth0: no IPv6 routers  present=0A> > > [ 9869.636167]=
  tda18271_write_regs: ERROR: idx =3D 0x5, len =3D 1,  =0A>i2c_transfer =0A=
>=0A> =0A> >  > returned: -5=0A> > > [ 9869.636178] tda18271_init: error  -=
5 on  line 826=0A> > > [ 9872.636220] tda18271_write_regs: ERROR: idx =3D 0=
x5,  len  =3D 1, =0A>i2c_transfer =0A>=0A> =0A> > > returned: -5=0A> > > [ =
 9872.636232]  tda18271_toggle_output: error -5 on line 47=0A> > > [  9998.=
240167]  tda18271_write_regs: ERROR: idx =3D 0x5, len =3D 1, =0A>i2c_transf=
er =0A>=0A> =0A> > > returned:  -5=0A> > > [ 9998.240178] tda18271_init:  e=
rror -5 on line 826=0A> > >  [10001.240179] tda18271_write_regs:  ERROR: id=
x =3D 0x5, len =3D 1, =0A>i2c_transfer =0A>=0A> =0A> > > returned: -5=0A> >=
  > [10001.240190] tda18271_toggle_output: error -5 on  line 47=0A> >  > =
=0A> > > And this is the dmesg of today: even the same   errors.=0A> > > =
=0A> > > [  741.252183] tda18271_init: error -5  on line  826=0A> > > [  74=
1.252188] tda18271_tune: error -5 on  line 904=0A> > >  [  741.252193] tda1=
8271_set_params: error -5 on  line 985=0A> > > [   742.268174] tda18271_wri=
te_regs: ERROR: idx =3D  0x5, len =3D 1, =0A>i2c_transfer =0A>=0A> =0A> > >=
 returned: -5=0A> > > [   742.268184] tda18271_init: error -5 on  line 826=
=0A> > > [   742.268189] tda18271_tune: error -5 on line 904=0A> > >  [   7=
42.268194] tda18271_set_params: error -5 on line 985=0A> > > [    743.28417=
4] tda18271_write_regs: ERROR: idx =3D 0x5, len =3D 1, =0A>i2c_transfer =0A=
>=0A> =0A> > > returned: -5=0A> > > [  743.284184] tda18271_init:  error -5=
 on  line 826=0A> > > [  743.284190] tda18271_tune: error  -5 on line 904=
=0A> > >  [  743.284194] tda18271_set_params: error  -5 on line 985=0A> > >=
 [   744.300169] tda18271_write_regs: ERROR: idx  =3D 0x5, len =3D 1, =0A>i=
2c_transfer =0A>=0A> =0A> > > returned: -5=0A> > > [   744.300180] tda18271=
_init: error -5 on  line 826=0A> > > [   744.300185] tda18271_tune: error -=
5 on line 904=0A> > >  [   744.300190] tda18271_set_params: error -5 on lin=
e 985=0A> > > [    745.320172] tda18271_write_regs: ERROR: idx =3D 0x5, len=
 =3D 1, =0A>i2c_transfer =0A>=0A> =0A> > > returned: -5=0A> > > [  745.3201=
83] tda18271_init:  error -5 on  line 826=0A> > > [  745.320188] tda18271_t=
une: error  -5 on line 904=0A> > >  [  745.320193] tda18271_set_params: err=
or  -5 on line 985=0A> > > [   746.336174] tda18271_write_regs: ERROR: idx =
 =3D 0x5, len =3D 1, =0A>i2c_transfer =0A>=0A> =0A> > > returned: -5=0A> > =
> [   746.336185] tda18271_init: error -5 on  line 826=0A> > > [   746.3361=
90] tda18271_tune: error -5 on line 904=0A> > >  [   746.336195] tda18271_s=
et_params: error -5 on line 985=0A> > > [    747.352170] tda18271_write_reg=
s: ERROR: idx =3D 0x5, len =3D 1, =0A>i2c_transfer =0A>=0A> =0A> > > return=
ed: -5=0A> > > [  747.352181] tda18271_init:  error -5 on  line 826=0A> > >=
 [  747.352187] tda18271_tune: error  -5 on line 904=0A> > >  [  747.352192=
] tda18271_set_params: error  -5 on line 985=0A> > > [   748.368172] tda182=
71_write_regs: ERROR: idx  =3D 0x5, len =3D 1, =0A>i2c_transfer =0A>=0A> =
=0A> > > returned: -5=0A> > > [   748.368183] tda18271_init: error -5 on  l=
ine 826=0A> > > [   748.368188] tda18271_tune: error -5 on line 904=0A> > >=
  [   748.368193] tda18271_set_params: error -5 on line 985=0A> > > [    74=
9.384179] tda18271_write_regs: ERROR: idx =3D 0x5, len =3D 1, =0A>i2c_trans=
fer =0A>=0A> =0A> > > returned: -5=0A> > > [  749.384191] tda18271_init:  e=
rror -5 on  line 826=0A> > > [  749.384196] tda18271_tune: error  -5 on lin=
e 904=0A> > >  [  749.384202] tda18271_set_params: error  -5 on line 985=0A=
> > > [   750.400172] tda18271_write_regs: ERROR: idx  =3D 0x5, len =3D 1, =
=0A>i2c_transfer =0A>=0A> =0A> > > returned: -5=0A> > > [   750.400182] tda=
18271_init: error -5 on  line 826=0A> > > [   750.400188] tda18271_tune: er=
ror -5 on line 904=0A> > >  [   750.400194] tda18271_set_params: error -5 o=
n line 985=0A> > > [    751.424170] tda18271_write_regs: ERROR: idx =3D 0x5=
, len =3D 1, =0A>i2c_transfer =0A>=0A> =0A> > > returned: -5=0A> > > [  751=
.424181] tda18271_init:  error -5 on  line 826=0A> > > [  751.424186] tda18=
271_tune: error  -5 on line 904=0A> > >  [  751.424192] tda18271_set_params=
: error  -5 on line 985=0A> > > [   752.440172] tda18271_write_regs: ERROR:=
 idx  =3D 0x5, len =3D 1, =0A>i2c_transfer =0A>=0A> =0A> > > returned: -5=
=0A> > >                                                                   =
         =0A>      =0A>=0A> >                                              =
                   =0A> >=0A> > >  =0A> > > =0A> >  > Any  ideas?=0A> > > T=
hanks=0A> > > =0A> > > =0A> >  >      =0A> > > =0A> > =0A> =0A> =0A>       =
=0A=0A=0A      
--0-1768804196-1287005162=:83798
Content-Type: application/zip; name="messages.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="messages.zip"

UEsDBBQAAAAIAJewTT3SkmCVjmwAAI71AQAIABwAbWVzc2FnZXNVVAkAA90Q
tkwWEbZMdXgLAAEE6AMAAAToAwAAvF1rU9tI1v7+/opTNR+G7GDSrbtcL1tr
DElcweDBMJlaKkXJUhu0yJJHkgnMr99zWpKxDUZqo6yrJka35+k+p/vcuuU5
93PgGnC3y3iX63CXz33InrIouQ2AH5gH7BdzMVnE+cLoQiqy3Evzg/87Xz6l
sa5uFU91OjDsXXzF75XrxlvX8WFWc/1NfLz4Nj6vwcfreldziuv3Io1F1IVr
cEzXOGCccZ19h5ub1MtFFM7CvAvcAd+Loonn32eQLeZzFEkmgsaABv8Os6f8
bpomcS7i4FrHc9+7kInbqbeIcvBysLgV2JrlQjgHpgtLTHUXsjlM9KlhTgIG
Ik2TFAwIY4jCye95P0nFQZYcGAfWgXatCyYYY79ptoVf31ea9rYseY0stRpZ
ajX4Wg2+XoOv1+Drb+HrwN4ca8V17IK5oTru6jo/0BxNd3EsRGHq34SzJO7C
4ALmSZqDHyXLAbBEsV5FcRzT4DgAgjCbR97TG8+XA0g8hnkY30ISQxbexl4E
3FzeifIwu4apMmOXT220bxBnc+FLqo+TJMk/jp+yXMwOZt68o+Gg0rWOZnRu
RSzS0H8bqu/FcZLDNIwDwMfxj0jUsJ8mXiACcBwbZ1f2NJskUQY4QWZgGzBL
gkUkshqIa8APO2Dy8x37g3LzovBv6pF/myaLOU7WCQoJ/PkiE3mLaEpQp2G8
eIQHkWYh6vSFaGFvsgijIPjX3ItmIv0Ae7e+v7zdwAmuw96V1G1x1DEKTZsf
4AP8Yuid8uJ4OILLO/wWc+AWcKPL7a6uw9VlH40mZ0uUZRMO8OGqFcXJA27+
FqQzXT8wPyh18uvJxdnJqbSOOMBRsyTzrhIEoNDR5sJnES/CWMgDRYDe8Bh6
i/xOxHno44Hi42fjPrIngYDJEx0oPt5/SsPH4l+cXLnwAlUAbLe3SKvvL+gc
MkWIy9SLs5nIvUqMl8NHx9oZZPlXf3SlCHI17K/+p/T00eB83JmnyUNIRmJ+
95SF6IHhojck+6I4rCSYcNCRANv4QGf1lCt8PLW3yLxJJNSG/xaSAnGNxJO8
e2ijRfogglZohL7ZF87ap+GbItPtqVvQtCWyJeI6iZAkvf5oAIGXe+3wiBc8
gj3znP0xboVGvOyOEC2rBjGnmzQOa30ETGkwr9PQKd46jXhJM22/N9PpBg2v
Lu1KczwcAOUGaL3VQpcePkhNhEDkGJKJoFsczjBe9JM0XcxziJIfZP/24UeS
3lNQ4mFMgvFWqMgVeVl+M5/GcAjsUc43pHm88VL/bnm6kIQSLDoZGPUuQcRk
CbAD6P+B7UMSBQhoM4NRYiK/9yEWP+RJXp7EbyWysY8BJ8mAoRSEh4EjpkYk
oJmYJelSZhg/KcFi2BlOw/c7nAqnzt/wd43pV1n4S5b3eLVXOVp3aq+ytO7T
XmNp26W95PgpHu11mrYd2qssrfuzV1lad2cvWX6GN3uNpX1n9gpL+74sxPz3
pjCnN2gB52htX5qzzrPKipGhRHGVkQknx5GJ2xk6TZD1tgzyBJAxTR7DmZcL
OPsTvWpCjlHVoKP5Ph6Mv3aB2mcVAsLRZU+ZsVlSqXHQUZT4HqW15LqWsIw5
Qivljj5sogo7TB5EhVYUP1YFarHNmUYNN0g8L4kNtf6gRejCxfh4RPDTiWkz
+oMbsPeAqHS5N1QbMEvIS1jaPPzPkJAcmKW5zJXXucGoistcOgfD8afLso+u
vQvlJ/wqKLWC0lmnpOstUx4ve2mYSNk7OdILSuhxZvDi31IAxSwcnF2eUgMs
xrm+Yy/HsLTyJFi1yVag9EaDftFw3S1kxdZkRddbltWw/+lzKSsuKfX+GuX5
yVDe0iIlQh6VsjIkpa1tUh613Msvo5NiREz0spfOJiXdwlqkHJx9Oi976RMl
19bHPZkVuqVFyrM/vhwXlHxKlNrGVJM34GxskXJcTbWJTlON0b+SsgdDGACM
zr+dXJydf1s6PlkDXB6pUdo4br4MPn8ZngzBe/DCiEJAtfTKcQjk9PzbOzCA
co45OhtKaVJvho5GOq4dfCy0ghFTSZStQFVm7b2ItO5ACwakKs4qd8fRz6kB
7rkgvDR6giLY8ShSyD7A4eE/Cwoxg2vGVpr9HLJ8V2z5L+wFlBxp5eUijceQ
HuberZAt2Hq7KjOvoPgqlFZehpM/4RKDidH56eDsZJX55e2qzFoFtRaT2BUz
fl5nfnm7KrNeQK0lak4QiIkjmS9P/ryE495lD47G42fm125XZTbKTqymu3x5
uVB0FVuv9PmV21WZzQLKCVYyOkdwTfMraZefo4uvz8yv3a7KbJWdWCsj8Gps
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
KTXYDMk2DIdXE+LkUfgLahOHCcZQ93JJpvhxmY7c6wJC3iGrGr3hqVxvaMbj
YEyuLXelxDjR5qnAf5UqcxJlGZDuLXO+MYMxh7EOYwPGDX+IhbBMq8Iqhmq5
ZWoqS0DYOPkieZED3jYGdd3/lVVwHJMbq2T0cjfpfgm/3G+Noa/coTNL8juR
ThIvDZ53OjRns9ZmdmV/ik2g1YbEoseQocVuNjbot3b00ijDNy+N5buTg7ic
IuBTMpMtZrICK4feNb2R9B1FZej7kN0liyigMiwtzFZ5ycd8gmqLso7OjWYD
Apuh6csBcZbgbEeXUxagiu3HzWYnApnWck6Rpb1Av4UBTRig27rGE/QGBumn
23TjCEI6NE3JUZUPdhk/4LRb8+SXlV8Rki9FHut3yHeso+duNq8kvLUVvtqF
2BBLY46xgaUdsC1NZXDM4Vjbpc2aTM628Ki2mVP9dgNrm3jf02auO1t5lNv8
Qs7GT5EzfyFnY2c5ay/kbPwUOWv6yzbvKmdd29SZvVXOOzRV1zdntr2zeA1r
U7zeTxkSBtUTt/Aot9ndFO/kp7TZLPZ6vcqj2mbb0NaxOPspbbYNZyuPYpt1
nMgbWD/FLCOPvZVHtc2asWniHMIq3nHAcAdDp4n0q80Aua1RHfLZMw+WYd5p
GN/D9enZ1x4658HF75n8TUCbfsyUux/gHw1TaaQwTKOG4mgLRbNyDFJYJquh
6L9OwfaXKmgYzHDbMfQasuPWyBxmaG+Tsffqh36ltIZii3526Y+h1wiPtacp
x9JrhgVrUVOOVjPM+RZN7UDmMm7XkLWnM1fjNWOQt6cz12BWDVl7OnMtVjMa
tW2zq6lpch3Gayha0xS9y1ozBrXWNIU5EsUpb5K1pin0fG7NGNRbm10aM52a
Mai3qDPbqetZizpz7Rqd6e3pjGN08TaZ0Z7OuG7V6MxoT2fctGqiJqM9nWF0
U+PFjBZ15po1jsVU15m9hQzlWGMbTXWdbSXTjRrbaKrrbCuZqdfMM1NdZ1vJ
7LqYympRZ65eozOrPZ3pvC6mstrTma7zmjjYak9nuslrdGa3pzPdrgvg7BZ1
5rKaoW+3pzOD85rRaLenM0Ov6dnVEavINAYaB43+DxOv5WJbKcya6PfqSNtC
sblGspXCrokRh73+e3vhsrc9Vu/fvXf2wuTszSE9/nxx9V4KvaYX4+HRForN
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
/XL6PRFq6KIGQp6tSm22wvhBChy5DCBaivmkv+d8AjZ6ABNB338+AQYB5pdg
9ppPSFiwOXBG7oa13yaQ0df2k7F+sOdk77IHBDf25A3cew924OpuI+4ug13u
zA+EZjMhD3a9NtgD6cFuK6Yx1+uMdx3sSOhWDHbjgMFOMMjLsASz32C3FQsn
SLOlxWO+ca6vHdc1PzNpEpcGce+2x3cLvf6ZhkYtQfNom4glPuCA8nk1IoQD
Hb3J7RwMW1XgbYqjtoRGACJLiT/Ou7nCwyGOLeWEfhg8OuQ0IAJVYbSzBNp5
+LMJVE5PA6qLyMAR0hdwW+RnWsXhBM4NaJhhA4WQw2P5saVqMBSYZv5Pf5yk
fCrotMXXe6SZisWr9xzmQ7YvOctsVYeOVgek92LFV7D6kpfitexUU3Wc3eMB
ZHLwpuMUIeCzRCCV6lvoTU/Em/58IlS1CKwv4pepNz5hzy20utz1IBHxRihv
4taYfRHbYsbpONrzROantJDKAvLxcQ0wSmjItgXpsOap0uJ3eZDalkLzVD2u
7mJTOMMG41YAYf47NeCTl+GwSJbcwgVbjXw8G2W4p3parBAco3Y4dgU01psm
aJjYxEGLZ+pyu+1Mgw0fYsa3q4mfZyxHROMo9U6lh5CtOiVSlQxNKQ4epDEQ
OcifzJAHqF0EXH+Em1kMgwA4L8uKOoJym6HGYTyTBNKU0uzHnw0WEu9INzFC
PUnYyci2s2ZiBo2SBb+zHq0Bnv8mLhENGiNBdjZqNnS1rUWzpeEwmCa4yIqT
19YzCamr3GVv1/wVC+kjjjT0Iku69Fgczc+iNWTakLtgpaI5HDt0sWj4jWiL
YRTAeN4WR7qa+7YivR5/KGdGx+D6Krg6B7cIXKmBy9kDMLi5Cq7NwQ1qIqcG
LucezuD2Krg+B9cI3KqBSw98h026auDGHJy2jJpRA5czlQY4onHWwc0KPCRs
rYYtGZ2BwdeMFqsC93k12R/cWAW3K3BPHKn1/twFfM1ocSpw6k91peSyCpNj
41S4iNrfuyYdstV/Ih3Mn2WcoEkaBqGtF5SWzEuf08wjbbNaySShXNXlzLQ3
3iOJ5nzz0haqQU/YbUORFVyuBlNGvo6DHYKT72Jyg6Oxl/lPkuZPhKSra3S/
IiFG6U7Dru/QrhCEv4X/CbdMJfNAeuKC+ZisgCNikr2cMOOy2yXR7ed571+Q
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
baUYgBHc7V33kgsoLJMj7day2VtWxWqRTKP+Z77WGJIeH8NVNEq562n/N0xX
suYYIesVDa/GiZFQJXnPd0R2Se2zv37bTVoX19Mizg/t8pgdvoCPU3Yvtt3d
RM1kD5N5Zqze3yNh292Pxm0PkJ2LQXDTmXlkZgu6ImUh9E2LTnBlWUqecfgr
3vidmVXHJEFGotfG9X7h/pZ8WML9E3F5JVPsED444/mM5swbDoegF2injZoK
OPCBAJO5Ns7E/eOnT3mqyh0InJyABn+P1v03zaT9lCexTjJGsKSXyNDgNzDu
/xAFFTQ6Qm71Kc1a/5hCBRbcg3qolMF5E2OBQ0PxPX2nZf2TJWiG5DuOX9S6
vP0a9xd4Jyl6nNcIGlQnl2mxr4uI+Tf4VOPy/me+bzDjCSTXW8u8UpAiczqL
kZFrl5M5oKjCJeSk2PN1LdGVoqtE1xHdjUQs9VhOkRZXD9XMZWrIR0B5Fk+9
B3w2BkWq8/+MVggC114jQ3A3ZF/AF/7Wo6x66Hgyf4lnug5J4elgzmavzexc
/2gn0NwhUbdYcIVJI2Tk2lHZNkP8Gs0Sjp28S7IpokuIp4sxn8Dy0PsdEUl/
UFc56iyvc9qLBS5m833JxbxHYntNW0o6ZgPCRkRQMUQfJjTbuajSSsF6s9lJ
QK6/VuTnE61bZNCMBrRs/U7fQAQG5NM2dRwhyAD16bFQZQ+2LXku4a15+4+V
LEIcFHmjXojvRtHKbTavGN6vhc+9EA2xbCt0S1g2J6utelVL3EhxY+/zzsQT
1PLs+s58WlbCquveQ96ZT9FqeHZ+541+dr5JP8uNfnb27mfb2Xznb9HP9kY/
O3v3s4J2WsPya/t5j1dVTnlm+3t3Ly/ma1jRNxkSTmDV8uz6zq5V7t7eN3ln
V5b7ubf3O/uuWseS1jd5Z9+zanl2fGdlqVL75TdRy8oqTxe5t1pWtlsezwGw
dIwDmTtkOvV4XTUDJCPUpPzeCfIFc05AnzbWQoan4r8Nt9JE4TRSXNVQmB3H
EIXnbC3oQBTX1RTWWSECQ2NG+oGzPb/9w083RyMLrCYy61D5BLbyGihq5LNP
e5zlfqWG7HiSCjzczW4lO6KkguXVQDWZrJHUHmShJRuGhTyezELb8hvIjiez
0LFUA9nxZBZ6VoNqsutml6lqCv2wofPsI0oqDBuGhX00SSGNdBPZ0SRFK1/Q
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
AE4AAADQbAAAAAA=

--0-1768804196-1287005162=:83798--
