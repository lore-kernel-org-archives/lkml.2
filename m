Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab1IMUgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:36:07 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:35928 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932506Ab1IMUgE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:36:04 -0400
From: Philip Rakity <prakity@marvell.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Manoj Iyer <manoj.iyer@canonical.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 13 Sep 2011 13:29:10 -0700
Subject: Re: SDHCI regression since 2.6.39
Thread-Topic: SDHCI regression since 2.6.39
Thread-Index: AcxyU8uwRMjPALA9QpOPl5WCZYlo2A==
Message-ID: <C016063E-B2A9-472E-AD9B-B5ACF2551FD5@marvell.com>
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org>
 <4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org>
 <4E6FA44F.1050705@goop.org> <m2aaa89t1m.fsf@bob.laptop.org>
 <alpine.DEB.2.02.1109131419430.3556@lazy> <4E6FBCA1.6040307@goop.org>
In-Reply-To: <4E6FBCA1.6040307@goop.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


What card are you using ?


On Sep 13, 2011, at 1:27 PM, Jeremy Fitzhardinge wrote:

> On 09/13/2011 12:29 PM, Manoj Iyer wrote:
>> 
>> @Jeremy, Could the problem be BIOS related? we have seen a number of
>> issues with older bioses on the x220s.
> 
> I have 1.17 installed at the moment.  It looks like 1.21 is current, so
> I could try updating it.  But the Fedora 15 2.6.38 kernel worked fine
> with this controller and cards, so I don't think BIOS version is an
> issue.  Also, there's nothing obviously related to the SD controller in
> the release notes (not that I trust their competeness).
> 
>    J
> 
> 
>> 
>> Here are a few cards I tested with the 3.1 RC4 kernel on Ubuntu
>> running on
>> a Lenovo X220. with Ricoh e823 card reader.
>> 
>> == kernel version ==
>> Linux u 3.1.0-0301rc4-generic #201108290905 SMP MonO Aug 29 09:11:07
>> UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
>> This is the upstream RC4 kernel build for ubuntu.
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/
>> 
>> == LSPCI output for SD card reader ==
>> 0d:00.0 System peripheral [0880]: Ricoh Co Ltd Device [1180:e823] (rev
>> 04) (prog-if 01)
>>    Subsystem: Lenovo Device [17aa:21db]
>>    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>    Latency: 0, Cache Line Size: 64 bytes
>>    Interrupt: pin A routed to IRQ 16
>>    Region 0: Memory at 91500000 (32-bit, non-prefetchable) [size=256]
>>    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>>        Address: 0000000000000000  Data: 0000
>>    Capabilities: [78] Power Management version 3
>>        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
>>    Capabilities: [80] Express (v1) Endpoint, MSI 00
>>        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>> unlimited, L1 unlimited
>>            ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
>>        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>            MaxPayload 128 bytes, MaxReadReq 128 bytes
>>        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
>> TransPend-
>>        LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 <4us, L1 unlimited
>>            ClockPM+ Surprise- LLActRep- BwNot-
>>        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
>> CommClk+
>>            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>    Capabilities: [100 v1] Virtual Channel
>>        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
>>        Arb:    Fixed- WRR32- WRR64- WRR128-
>>        Ctrl:    ArbSelect=Fixed
>>        Status:    InProgress-
>>        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>            Status:    NegoPending- InProgress-
>>    Capabilities: [800 v1] Advanced Error Reporting
>>        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
>> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
>> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
>> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>>        CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
>> ChkEn-
>>    Kernel driver in use: sdhci-pci
>>    Kernel modules: sdhci-pci
>> 
>> == Sandisk Extreme Pro 16GB ==
>> Was able to mount Ultra high speed SDHC card 45MB/s, read and write
>> works.
>> 
>> [   60.578630] mmc0: new ultra high speed SDHC card at address e624
>> [   60.611808] mmcblk0: mmc0:e624 SD16G 14.8 GiB [   60.644314] 
>> mmcblk0: p1
>> [   60.947772] mmcblk0: error -84 transferring data, sector 8192, nr
>> 8, cmd response 0x900, card status 0xb00
>> [   60.947777] mmcblk0: retrying using single block read
>> 
>> /dev/mmcblk0p1 on /media/New Volume type vfat
>> (rw,nosuid,nodev,uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush,uhelper=udisks)
>> 
>> == Sandisk 2GB SD card ==
>> Was able to mount Sandisk SD card, read and write works.
>> [  298.540999] mmc0: new SD card at address 0002
>> [  298.541306] mmcblk0: mmc0:0002 00000 1.86 GiB [  298.543157] 
>> mmcblk0: p1
>> 
>> /dev/mmcblk0p1 on /media/E0FD-1813 type vfat
>> (rw,nosuid,nodev,uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush,uhelper=udisks)
>> 
>> == Transcend 2GB MMC plus card ==
>> Was able to mount and read/write. Shows up as SD card.
>> [  734.032981] mmc0: error -110 whilst initialising MMC card
>> [  734.132920] mmc0: error -110 whilst initialising MMC card
>> [  734.228244] mmc0: new MMC card at address 0001
>> [  734.228631] mmcblk0: mmc0:0001 MMC    1.87 GiB [  734.229834] 
>> mmcblk0: p1
>> u@u:~$
>> 
>> /dev/mmcblk0p1 on /media/New Volume type vfat
>> (rw,nosuid,nodev,uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush,uhelper=udisks)
>> 
>> Cheers
>> -- 
>> ====================
>> Manoj Iyer
>> Ubuntu/Canonical
>> Hardware Enablement
>> ====================
>> 
>> 
>> On Tue, 13 Sep 2011, Chris Ball wrote:
>> 
>>> Hi,
>>> 
>>> On Tue, Sep 13 2011, Jeremy Fitzhardinge wrote:
>>>>> If it is running, and not helping, can I persuade you to try a full
>>>>> bisection?
>>>> 
>>>> OK, will do.
>>> 
>>> Thank you!
>>> 
>>>>>  I don't think we have other reports of this bug, and the
>>>>> only other person who has reported something like it wasn't a kernel
>>>>> hacker.
>>>> 
>>>> That's interesting; the X220 is a pretty common machine these days, I
>>>> think.  I wonder if there's variations in the SD controller or
>>>> something?
>>> 
>>> I just asked Matthew Garrett to check his X220, and his has the same
>>> e823
>>> controller as you, is running a 3.1-rc kernel, and everything's working.
>>> 
>>> So it's not even variation in the controller model, it's something even
>>> more subtle.  Perhaps try some different cards?  What capacity/speed is
>>> the one you're trying?  If there is a per-card difference, I suppose
>>> we'd expect it to be that slower cards work and faster cards fail
>>> (given the nature of the patch I linked in my last mail).
>>> 
>>> Thanks,
>>> 
>>> - Chris.
>>> -- 
>>> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
>>> One Laptop Per Child
>>> 
>>> 
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

