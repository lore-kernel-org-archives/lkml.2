Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2GOOgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 10:36:48 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:45265 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2GOOgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 10:36:40 -0400
Message-ID: <5002D56C.6020306@xs4all.nl>
Date: Sun, 15 Jul 2012 16:36:28 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Alan Stern <stern@rowland.harvard.edu>,
        Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <Pine.LNX.4.44L0.1207121049590.1413-100000@iolanthe.rowland.org> <5002D378.8030800@xs4all.nl>
In-Reply-To: <5002D378.8030800@xs4all.nl>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-15 16:28, Udo van den Heuvel wrote:

> After disabling:

And somewhat later:

bus pci, device 0000:00:12.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x083 HCFS=operational CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead cf820000
hcca frame 0x523f
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80002844 FRT FR=0x2844
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000103 PPS PES CCS
roothub.portstatus [2] 0x00000100 PPS
bus pci, device 0000:00:12.1
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x083 HCFS=operational CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead cf862050
ed_bulkhead cf8620a0
hcca frame 0x5203
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80002249 FRT FR=0x2249
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000103 PPS PES CCS
roothub.portstatus [2] 0x00000100 PPS
bus pci, device 0000:00:13.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x0af HCFS=operational BLE IE PLE CBSR=3
cmdstatus 0x10004 SOC=1 BLF
intrstatus 0x00000025 FNO SF SO
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead cf840050
ed_bulkhead cf8400f0
ed_bulkcurrent cf8400f0
hcca frame 0x51c7
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80001ec8 FRT FR=0x1ec8
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000103 PPS PES CCS
roothub.portstatus [1] 0x00000103 PPS PES CCS
roothub.portstatus [2] 0x00000100 PPS
bus pci, device 0000:00:13.1
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x083 HCFS=operational CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
ed_controlhead cf822000
hcca frame 0x517a
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80002254 FRT FR=0x2254
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS
roothub.portstatus [2] 0x00000103 PPS PES CCS
bus pci, device 0000:00:14.5
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers, rh state running
control 0x083 HCFS=operational CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000024 FNO SF
intrenable 0x8000005a MIE RHSC UE RD WDH
hcca frame 0x5057
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80001864 FRT FR=0x1864
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 02000202 POTPGT=2 NPS NDP=2(2)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS

T:  Bus=07 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.04
S:  Manufacturer=Linux 3.4.4 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:14.5
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.04
S:  Manufacturer=Linux 3.4.4 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:13.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=06 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  4 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=02(comm.) Sub=00 Prot=00 MxPS=64 #Cfgs=  2
P:  Vendor=0525 ProdID=a4a2 Rev= 2.16
S:  Manufacturer=Linux 2.6.21-omap1/musb_hdrc
S:  Product=RNDIS/Ethernet Gadget
C:  #Ifs= 2 Cfg#= 2 Atr=e0 MxPwr=  8mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=ff Driver=
E:  Ad=82(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=  8mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=06 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_subset
I:* If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_subset
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.04
S:  Manufacturer=Linux 3.4.4 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:12.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 3
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.04
S:  Manufacturer=Linux 3.4.4 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=04 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0471 ProdID=0311 Rev= 0.03
S:  SerialNumber=01690000A5000000
C:* #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 0 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
I:  If#= 0 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 292 Ivl=1ms
I:  If#= 0 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 448 Ivl=1ms
I:  If#= 0 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 592 Ivl=1ms
I:  If#= 0 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 704 Ivl=1ms
I:  If#= 0 Alt= 6 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 776 Ivl=1ms
I:  If#= 0 Alt= 7 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 840 Ivl=1ms
I:  If#= 0 Alt= 8 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 896 Ivl=1ms
I:  If#= 0 Alt= 9 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:  If#= 0 Alt=10 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:* If#= 1 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=00 Driver=snd-usb-audio
I:* If#= 2 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
I:  If#= 2 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  90 Ivl=1ms
I:  If#= 2 Alt= 2 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  46 Ivl=1ms
I:  If#= 2 Alt= 3 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 2 Alt= 4 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  16 Ivl=1ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 3
B:  Alloc= 22/900 us ( 2%), #Int=  1, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.04
S:  Manufacturer=Linux 3.4.4 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:13.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0a12 ProdID=0001 Rev=31.64
C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0471 ProdID=0311 Rev= 0.03
S:  SerialNumber=01690000A5000000
C:* #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 0 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
I:  If#= 0 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 292 Ivl=1ms
I:  If#= 0 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 448 Ivl=1ms
I:  If#= 0 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 592 Ivl=1ms
I:  If#= 0 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 704 Ivl=1ms
I:  If#= 0 Alt= 6 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 776 Ivl=1ms
I:  If#= 0 Alt= 7 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 840 Ivl=1ms
I:  If#= 0 Alt= 8 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 896 Ivl=1ms
I:  If#= 0 Alt= 9 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:  If#= 0 Alt=10 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   1 Ivl=32ms
E:  Ad=85(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:* If#= 1 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=00 Driver=snd-usb-audio
I:* If#= 2 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
I:  If#= 2 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  90 Ivl=1ms
I:  If#= 2 Alt= 2 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  46 Ivl=1ms
I:  If#= 2 Alt= 3 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 2 Alt= 4 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=84(I) Atr=01(Isoc) MxPS=  16 Ivl=1ms

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 3
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.04
S:  Manufacturer=Linux 3.4.4 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:12.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=03f0 ProdID=1904 Rev= 1.00
S:  Manufacturer=Hewlett-Packard
S:  Product=DeskJet 3820
S:  SerialNumber=CN2BO1N17618
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=07(print) Sub=01 Prot=02 Driver=usblp
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 3
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.04
S:  Manufacturer=Linux 3.4.4 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:12.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=067b ProdID=2303 Rev= 3.00
S:  Manufacturer=Prolific Technology Inc.
S:  Product=USB-Serial Controller
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=pl2303
E:  Ad=81(I) Atr=03(Int.) MxPS=  10 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms


