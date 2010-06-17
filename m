Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab0FQMSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:18:07 -0400
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:43451 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752316Ab0FQMSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:18:04 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2010 08:18:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ameritech.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=i7uMsGr8ZgNYwN+rCHkJ8KRs/xxlWkUHl8VKydd9fRIv8YEU0znlvLxGnNm6u1HNPm47Zj86IOh3tjSkJ8LrAI+BzFmEbs+iwiaxyt9XyqPTW66Nxk2bKdYP5veWXwBTnnL2NdmRpW5uQhbDrI8gXWtD2uFgHVnBMdkXud+/4JE=  ;
X-Yahoo-SMTP: YbXY4QiswBDIwUvpBHqjGlM60e.1oHNBgoHih_YhU30ZyW4-
X-YMail-OSG: CFx42lgVM1mDEJggVatDGFP0OjVEgHl.pdO2mwRTD_c1gUfWPVw0ij8YwY_47pxe1219Gz28IboObX5LW.fnGaI.4hQTVCvtF_fNb47nTh7Pfdy5Wg2bbLzf3PB3CHsPu5IyYxn_l3i.cyt2Gzk3tCrCsX79FS8TEGT_ucNuapWpB.7HHcDUjGe6URnf4.bgpLEC5CyWCjZcAkHceC48fXN0dfvQS0FEDTPVYToZ1HIb262Dq8VepWb97yGguhofVn_ATOlbGIOZUOyKX9Oq0iWfAjXmK1jEdursUJE-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4C1A10DA.4080304@ameritech.net>
Date: Thu, 17 Jun 2010 08:11:06 -0400
From: "F. Heitkamp" <heitkamp@ameritech.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Giuliano Pochini <pochini@shiny.it>
CC: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       linux-audio-user@lists.linuxaudio.org,
       Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
       alsa-user@lists.sourceforge.net
Subject: Re: [Alsa-user] [alsa-devel] Crash 2.6.32.x, Echo 3G, Alsa, SCSI
References: <73211.74714.qm@web180714.mail.sp1.yahoo.com>	<4B684513.8090201@ladisch.de> <20100202230911.71e8b600@Jay>	<4C040864.8010205@ameritech.net> <20100531225936.4a9344df@Jay>	<4C04FC3F.70905@ameritech.net> <20100603000828.04af4bdc@Jay>
In-Reply-To: <20100603000828.04af4bdc@Jay>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 06/02/10 18:08, Giuliano Pochini wrote:
> On Tue, 01 Jun 2010 08:25:35 -0400
> "F. Heitkamp"<heitkamp@ameritech.net>  wrote:
>
>>>> I've tried some newer kernels.  Still having problems with the echo 3G.
>>>> This is kernel version:
>>>> 2.6.32.13.  The above patches posted to the linux kernel list seemed to
>>>> get rid of the crashes, but evidently did not go into the main kernel tree.
>>>>
>>> Indeed. I've just checked 2.6.33 and the patch isn't there. It's in 2.6.34.
>>>
>>> If you need 2.6.32.13 you can apply the above patch to the kernel tree or
>>> download ftp://ftp.alsa-project.org/pub/driver/alsa-driver-1.0.23.tar.bz2,
>>> otherwise just use the latest kernel.
>>>
>> I tried 2.6.34.   I have jack 1.9..5 installed.  I was able to use
>> rhythmbox to play mp3s.  I could not use the echomixer app.  It complained
>> about a channels mismatch.
> I'm running 2.6.34 now. Both a very old version of echomixer (2005!) and
> the latest version I just compiled from alsa-tools-1.0.23 work fine with my
> Gina3G. Please quote the error message.
>
>
>> My goal is to be able to plug in a MIDI keyboard, or USB guitar
>> interface and play along with songs etc.
>>
>> I plugged in a MIDI keyboard, "/proc/asound/cards" showed the keyboard
>> was recognized.  The keyboard has a USB and MIDI interface.
>> I am not sure if they both work at the same time.  I had the MIDI cable
>> plugged into the Gina3G, but I could not tell if the keyboard was
>> recognized.
>> I compiled csound5.  When I engaged it the system immediately froze and
>> started spitting out:
>> [...]
> Ok, I compiled csound, but I don't know how to use it. How can I reproduce
> the problem ?
>
Sorry I took so long to get back to you.
It turns out Csound is not related to the problem.

In this case I am only using kernel 2.6.33.5-rt23-amd64, alsa lib 1.0.2, 
but 2.6.34 does it too.
I bring up firefox.  Web pages attempt to play sound.   The kernel 
begans doing:

[ 2879.766331] allocate_pipes: ch=1 int=2
[ 2879.766332] allocate_pipes: channel already open
[ 2879.766333] allocate_pipes(1) err=-11
[ 2879.766334] pcm_hw_freed
[ 2.821190] pcm_analog_out_open  cs=0  oc=2  r=44100
[ 2879.821266] allocate_pipes: ch=1 int=2
[ 2879.821267] allocate_pipes: channel already open

,infinitely.  The system is unusable at this point and I have to 
Alt-SysRq-k to get back in.

Let me know what other information to provide.

Here is hwinfo on the system:
cpu:
                        Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz, 
2400 MHz
                        Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz, 
2400 MHz
keyboard:
   /dev/input/input0    EzKEY USB-compliant keyboard
printer:
                        HP deskjet 5600
graphics card:
                        PC Partner VGA compatible controller
sound:
                        PC Partner Audio device
storage:
                        LSI Logic / Symbios Logic 53c1030 PCI-X 
Fusion-MPT Dual Ultra320 SCSI
                        LSI Logic / Symbios Logic 53c1030 PCI-X 
Fusion-MPT Dual Ultra320 SCSI
                        Intel 82801G (ICH7 Family) IDE Controller
network:
   eth1                 Tyan 82573E Gigabit Ethernet Controller (Copper)
   eth0                 Tyan 82573E Gigabit Ethernet Controller (Copper)
network interface:
   eth1                 Ethernet network interface
   eth0                 Ethernet network interface
   lo                   Loopback network interface
usb controller:
                        Intel 82801G (ICH7 Family) USB2 EHCI Controller
                        Intel 82801G (ICH7 Family) USB UHCI #4
                        Intel 82801G (ICH7 Family) USB UHCI #3
                        Intel 82801G (ICH7 Family) USB UHCI #2
                        Intel 82801G (ICH7 Family) USB UHCI #1
bios:
                        BIOS
bridge:
                        Texas Instruments PCI bridge
                        Intel 6702PXH PCI Express-to-PCI Bridge A
                        Intel 82801GB/GR (ICH7 Family) LPC Interface Bridge
                        Intel 82801 PCI Bridge
                        Intel 82801GR/GH/GHM (ICH7 Family) PCI Express 
Port 6
                        Intel 82801GR/GH/GHM (ICH7 Family) PCI Express 
Port 5
                        Intel 82801G (ICH7 Family) PCI Express Port 1
                        Intel 975X Express PCI Express Root Port
                        Intel E7230 PCI Express Root Port
                        Intel E7230 Memory Controller Hub
hub:
                        ATEN International Hub
                        Linux 2.6.33.5-rt23-amd64 uhci_hcd UHCI Host 
Controller
                        Linux 2.6.33.5-rt23-amd64 uhci_hcd UHCI Host 
Controller
                        Linux 2.6.33.5-rt23-amd64 uhci_hcd UHCI Host 
Controller
                        Linux 2.6.33.5-rt23-amd64 uhci_hcd UHCI Host 
Controller
                        Linux 2.6.33.5-rt23-amd64 ehci_hcd EHCI Host 
Controller
memory:
                        Main Memory
firewire controller:
                        Timedia TSB82AA2 IEEE-1394b Link Layer Controller
unknown:
                        FPU
                        DMA controller
                        PIC
                        Timer
                        Keyboard controller
   /dev/lp0             Parallel controller
                        Echo Digital Audio 3G
                        Intel 82801G (ICH7 Family) SMBus Controller
                        PnP Unclassified device
                        PnP Unclassified device
                        PnP Unclassified device
                        Unclassified device
                        PnP Unclassified device
                        PnP Unclassified device
                        PnP Unclassified device
                        PnP Unclassified device
                        PnP Unclassified device
                        PnP Unclassified device
                        PnP Unclassified device
                        PnP Unclassified device
                        Serial controller
   /dev/input/input2    Logitech Trackball
   /dev/input/input1    EzKEY USB-compliant keyboard
                        Belkin UPS

