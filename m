Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0JNMWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:22:19 -0400
Received: from nm15-vm1.bullet.mail.ukl.yahoo.com ([217.146.183.253]:25252
	"HELO nm15-vm1.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753451Ab0JNMWS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:22:18 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 886747.7552.bm@omp1010.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=s8xS2GzngRHBa460GrmvPLHikMBWMCNxfHiOYcaQ3lehR2BUnrVvBSNcpuMg2gvRKYzjJshBbpKKcfrUkFmTQiXyhdQVQA8cFn2qfN+AJtvjo+2zWG9Kk7aOr5iOePcsSnMU+pBD/5K3251XYNa9Hg7/2XAFHupGcsvmfindkrA=;
Message-ID: <736145.17319.qm@web25403.mail.ukl.yahoo.com>
X-YMail-OSG: 05RmOt0VM1mGrWWOSHULIZJNKEhvCETXE.MHWQLcIgPOIWT
 h4uX2v09bR9XLRbtI1IETAiEFEOG3TEEezEK4Wu3Vatfv01.GK89YqAyj5Z7
 ZEDSaSPPPNiimVLbBVoLjUc7QzxFx5HjtaiJLWA8AcyRHBAAjHIDo8H4ctfH
 4fU4ZSAfy3wBtbYk9GGkV5y4sRamKeFlOFxdTQia5wJj5WxWAKYoIE17BxuC
 j5spWGi0TjcHbyN24TWFDL6dvJ77IlCV9cAprc7xyDpHybobNFWogyucczIp
 PO6CnIQlGFbguP5r5ZaAmcDO3KVbrVQiw
X-Mailer: YahooMailRC/504.5 YahooMailWebService/0.8.106.282862
Date: Thu, 14 Oct 2010 13:22:14 +0100 (BST)
From: fabio tirapelle <ftirapelle@yahoo.it>
Subject: Re: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@kernellabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WinTV did work correctly with ubuntu 9.10. In this version of Ubuntu the 
package linux-firmware-nonfree didn't include the dvb-fe-tda10048-1.0.fw. I 
remember that Ubuntu 9.10 used  dvb-fe-tda10046.fw. 

Now, Ubuntu 10.04 loads for my card the dvb-fe-tda10048-1.0.fw
Its seems that with the 9.10 version, the card is recognized as WinTV-HVR-1100 
or 1110 and now as WinTV-HVR-1120.
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1110
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1120

How recognize Linux the version of the card?

Thanks



----- Messaggio originale -----
> Da: fabio tirapelle <ftirapelle@yahoo.it>
> A: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Cc: linux-kernel@vger.kernel.org; Michael Krufky <mkrufky@kernellabs.com>
> Inviato: Mer 13 ottobre 2010, 23:26:02
> Oggetto: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
> 
> 
>  Yesterday I have installed (added not substituted) a new tuner: Hauppauge 
> Nova-T Stick 3
>  Today the  WinTV-HVR-1120 doesn't works.
>  I  attach my /var/log/messages
> 
>  lsusb
> 
>  Bus 004 Device 001: ID  1d6b:0001 Linux Foundation 1.1 root hub
>  Bus 003 Device 002: ID 15c2:0036  SoundGraph Inc.
>  Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root  hub
>  Bus 002 Device 002: ID 2040:7070 Hauppauge Nova-T Stick 3
>  Bus 002  Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>  Bus 001 Device 001:  ID 1d6b:0002 Linux Foundation 2.0 root hub
> 
> 
>  lscpi
> 
>  00:00.0 RAM  memory: nVidia Corporation MCP78S [GeForce 8200] Memory 
>Controller
>  (rev  a2)
>  00:01.0 ISA bridge: nVidia Corporation MCP78S [GeForce 8200] LPC Bridge  (rev 

> a2)
>  00:01.1 SMBus: nVidia Corporation MCP78S [GeForce 8200] SMBus  (rev a1)
>  00:01.2 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory  
>Controller
>  (rev a1)
>  00:01.3 Co-processor: nVidia Corporation MCP78S  [GeForce 8200] Co-Processor 
> (rev
>  a2)
>  00:01.4 RAM memory: nVidia  Corporation MCP78S [GeForce 8200] Memory 
>Controller
>  (rev a1)
>  00:02.0 USB  Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 
1.1
>  Controller  (rev a1)
>  00:02.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200]  EHCI USB 
2.0
>  Controller (rev a1)
>  00:04.0 USB Controller: nVidia  Corporation MCP78S [GeForce 8200] OHCI USB 
1.1
>  Controller (rev a1)
>   00:04.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI USB  
>2.0
>  Controller (rev a1)
>  00:06.0 IDE interface: nVidia Corporation MCP78S  [GeForce 8200] IDE (rev a1)
>  00:07.0 Audio device: nVidia Corporation  MCP72XE/MCP72P/MCP78U/MCP78S High
>  Definition Audio (rev a1)
>  00:08.0 PCI  bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev 

> a1)
>   00:09.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] SATA  
>Controller
>  (non-AHCI mode) (rev a2)
>  00:0a.0 Ethernet controller: nVidia  Corporation MCP77 Ethernet (rev a2)
>  00:0b.0 PCI bridge: nVidia Corporation  MCP78S [GeForce 8200] PCI Express 
>Bridge
>  (rev a1)
>  00:10.0 PCI bridge:  nVidia Corporation MCP78S [GeForce 8200] PCI Express 
>Bridge
>  (rev a1)
>   00:12.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express  
>Bridge
>  (rev a1)
>  00:18.0 Host bridge: Advanced Micro Devices [AMD] K8  [Athlon64/Opteron]
>  HyperTransport Technology Configuration
>  00:18.1 Host  bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
>Address
>  Map
>   00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM
>   Controller
>  00:18.3 Host bridge: Advanced Micro Devices [AMD] K8  [Athlon64/Opteron]
>  Miscellaneous Control
>  01:06.0 Multimedia controller:  Philips Semiconductors 
SAA7131/SAA7133/SAA7135
>  Video Broadcast Decoder (rev  d1)
>  01:07.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII  DVB 
>chip 
>
> /
>  Technisat SkyStar2 DVB card (rev 02)
>  02:00.0 VGA  compatible controller: nVidia Corporation C77 [GeForce 8200] 
(rev
>   a2)
> 
> 
> > ----- Messaggio originale -----
> > > Da: Bjorn   Helgaas <bjorn.helgaas@hp.com>
> > > A:  fabio  tirapelle <ftirapelle@yahoo.it>
> > > Cc: linux-kernel@vger.kernel.org;   Michael Krufky 
<mkrufky@kernellabs.com>
> >  >  Inviato: Mer 13 ottobre 2010, 21:54:31
> > > Oggetto: Re:  Hauppauge  WinTV-HVR-1120 on Unbuntu 10.04
> > > 
> > > On  Wednesday, October 13, 2010  01:02:11 pm fabio tirapelle wrote:
> >  > > After  upgrading from  Ubuntu 9.10 to Ubuntu 10.04 my  Hauppauge 
> >WinTV-HVR-1120 
> >
> > >
> > >   >  (sometimes) doesn't work correctly.
> > > > I get random  the  following  errors:
> > > > 
> > > >  tda18271_write_regs: ERROR:  idx = 0x5, len = 1,  i2c_transfer  
>returned: 
>
> -5
> > > > tda18271_init:  error -5 on line  826
> > > >  tda18271_tune: error -5 on line  904
> >  > > tda18271_set_params: error -5 on  line 985
> > > 
> >  > I cc'd Michael since he made several recent tda18271    changes.
> > > 
> > > This page: http://cvs.linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
> >  >  suggests  that the card might work, despite the error  messages.   Does
> > > yours  work?
> > > 
> > >  I see that tda18271_write_regs()  uses i2c_transfer(), which uses   the
> > > adap->algo->master_xfer  function pointer, but I  don't know enough  to
> > > figure out which  master_xfer  implementation might be used on  your
> > > system.  A   complete dmesg log and lspci output might have a  hint.
> > > 
> > >  Can you reproduce this on an upstream kernel?  It would  be  good  to
> > > make sure that it's not something introduced  by an Ubuntu patch   or
> > > fixed since the Ubuntu kernel  snapshot.
> > > 
> > >  Bjorn
> > > 
> > > >  Part of  dmesg of 11-OCT-2010
> > > > 
> > > > [    53.216153] DVB: registering new  adapter  (saa7133[0])
> > >  > [   53.216156] DVB: registering adapter 2   frontend 0 (NXP  TDA10048HN 

> > >DVB-T)...
> > > > [     53.840013]  tda10048_firmware_upload: waiting for firmware upload 
> >  >  >  (dvb-fe-tda10048-1.0.fw)...
> > > > [    53.840019] saa7134  0000:01:06.0:  firmware: requesting 
> >  >dvb-fe-tda10048-1.0.fw
> > >  > [   53.880505]   tda10048_firmware_upload: firmware read 24878  bytes.
> > > >  [   53.880509]  tda10048_firmware_upload: firmware   uploading
> > > > [   58.280136]   tda10048_firmware_upload:  firmware uploaded
> > > > [    59.024537]  tda18271_write_regs:  ERROR: idx = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > > returned:    -5
> > > > [   59.024541]  tda18271c2_rf_tracking_filters_correction:  error  -5 on 

> >line 
> >
> > >264
> > > > [   59.420153]   tda18271_write_regs: ERROR: idx =  0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > >  > returned: -5
> > > > [    59.420157]  tda18271_toggle_output:  error -5 on line 47
> > >  > [   91.004019]  Clocksource tsc  unstable (delta =  -295012684 ns)
> > > > [  256.293639]  eth0:  link  up.
> > > > [  256.294750] ADDRCONF(NETDEV_CHANGE): eth0:   link  becomes ready
> > > > [  263.523498] eth0: link   down.
> > > > [   265.258740] eth0: link up.
> > > >  [   266.460026] eth0: no IPv6 routers  present
> > > > [  9869.636167]  tda18271_write_regs: ERROR: idx = 0x5, len = 1,  
> >i2c_transfer 
> >
> > 
> > >  > returned:  -5
> > > > [ 9869.636178] tda18271_init: error  -5 on  line  826
> > > > [ 9872.636220] tda18271_write_regs: ERROR: idx =  0x5,  len  = 1, 
> >i2c_transfer 
> >
> > 
> > >  > returned: -5
> > > > [  9872.636232]   tda18271_toggle_output: error -5 on line 47
> > > > [   9998.240167]  tda18271_write_regs: ERROR: idx = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > > returned:   -5
> > > > [ 9998.240178] tda18271_init:  error -5 on line  826
> > > >  [10001.240179] tda18271_write_regs:  ERROR: idx  = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > >  returned: -5
> > >  > [10001.240190] tda18271_toggle_output:  error -5 on  line 47
> > >  > 
> > > > And this is  the dmesg of today: even the same   errors.
> > > > 
> > >  > [  741.252183] tda18271_init: error -5  on line  826
> >  > > [  741.252188] tda18271_tune: error -5 on  line 904
> >  > >  [  741.252193] tda18271_set_params: error -5 on  line  985
> > > > [   742.268174] tda18271_write_regs: ERROR: idx  =  0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > >  returned: -5
> > > > [   742.268184] tda18271_init: error -5  on  line 826
> > > > [   742.268189] tda18271_tune: error -5  on line 904
> > > >  [   742.268194] tda18271_set_params:  error -5 on line 985
> > > > [    743.284174]  tda18271_write_regs: ERROR: idx = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > > returned: -5
> > > > [   743.284184] tda18271_init:  error -5 on  line 826
> > > >  [  743.284190] tda18271_tune: error  -5 on line 904
> > >  >  [  743.284194] tda18271_set_params: error  -5 on line  985
> > > > [   744.300169] tda18271_write_regs: ERROR: idx   = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > >  returned: -5
> > > > [   744.300180] tda18271_init: error -5  on  line 826
> > > > [   744.300185] tda18271_tune: error -5  on line 904
> > > >  [   744.300190] tda18271_set_params:  error -5 on line 985
> > > > [    745.320172]  tda18271_write_regs: ERROR: idx = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > > returned: -5
> > > > [   745.320183] tda18271_init:  error -5 on  line 826
> > > >  [  745.320188] tda18271_tune: error  -5 on line 904
> > >  >  [  745.320193] tda18271_set_params: error  -5 on line  985
> > > > [   746.336174] tda18271_write_regs: ERROR: idx   = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > >  returned: -5
> > > > [   746.336185] tda18271_init: error -5  on  line 826
> > > > [   746.336190] tda18271_tune: error -5  on line 904
> > > >  [   746.336195] tda18271_set_params:  error -5 on line 985
> > > > [    747.352170]  tda18271_write_regs: ERROR: idx = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > > returned: -5
> > > > [   747.352181] tda18271_init:  error -5 on  line 826
> > > >  [  747.352187] tda18271_tune: error  -5 on line 904
> > >  >  [  747.352192] tda18271_set_params: error  -5 on line  985
> > > > [   748.368172] tda18271_write_regs: ERROR: idx   = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > >  returned: -5
> > > > [   748.368183] tda18271_init: error -5  on  line 826
> > > > [   748.368188] tda18271_tune: error -5  on line 904
> > > >  [   748.368193] tda18271_set_params:  error -5 on line 985
> > > > [    749.384179]  tda18271_write_regs: ERROR: idx = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > > returned: -5
> > > > [   749.384191] tda18271_init:  error -5 on  line 826
> > > >  [  749.384196] tda18271_tune: error  -5 on line 904
> > >  >  [  749.384202] tda18271_set_params: error  -5 on line  985
> > > > [   750.400172] tda18271_write_regs: ERROR: idx   = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > >  returned: -5
> > > > [   750.400182] tda18271_init: error -5  on  line 826
> > > > [   750.400188] tda18271_tune: error -5  on line 904
> > > >  [   750.400194] tda18271_set_params:  error -5 on line 985
> > > > [    751.424170]  tda18271_write_regs: ERROR: idx = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > > returned: -5
> > > > [   751.424181] tda18271_init:  error -5 on  line 826
> > > >  [  751.424186] tda18271_tune: error  -5 on line 904
> > >  >  [  751.424192] tda18271_set_params: error  -5 on line  985
> > > > [   752.440172] tda18271_write_regs: ERROR: idx   = 0x5, len = 1, 
> >i2c_transfer 
> >
> > 
> > > >  returned: -5
> > > >                                                                           
>    
>
> >       
> >
> > >                                                                   
> > >
> > > >  
> > >  > 
> > >  > Any  ideas?
> > > > Thanks
> >  > > 
> > > > 
> > >  >      
> > > > 
> > > 
> > 
> > 
> >      
> 
> 
>       


      
