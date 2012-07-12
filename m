Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab2GLGQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:16:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16391 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab2GLGQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:16:39 -0400
Message-ID: <4FFE6BB9.4060106@oracle.com>
Date: Thu, 12 Jul 2012 14:16:25 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Dave, Tushar N" <tushar.n.dave@intel.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 82571EB: Detected Hardware Unit Hang
References: <4FFA9B96.6040901@oracle.com> <4FFBDC50.5090800@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EE41F@ORSMSX102.amr.corp.intel.com> <4FFCCA22.8060006@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EEC8B@ORSMSX102.amr.corp.intel.com> <4FFCDA6C.8020708@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EED74@ORSMSX102.amr.corp.intel.com> <4FFCF314.6020400@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EEDD7@ORSMSX102.amr.corp.intel.com> <4FFD0908.6080506@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EF8AD@ORSMSX102.amr.corp.intel.com> <4FFE3505.8060407@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F018D@ORSMSX102.amr.corp.intel.com> <4FFE3D27.7020500@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F01BE@ORSMSX102.amr.corp.intel.com> <4FFE40A9.4060807@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274F02D7@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <061C8A8601E8EE4CA8D8FD6990CEA891274F02D7@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/12 13:57, Dave, Tushar N wrote:
>> -----Original Message-----
>> From: Joe Jin [mailto:joe.jin@oracle.com]
>> Sent: Wednesday, July 11, 2012 8:13 PM
>> To: Dave, Tushar N
>> Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: 82571EB: Detected Hardware Unit Hang
>>
>> On 07/12/12 11:07, Dave, Tushar N wrote:
>>>> -----Original Message-----
>>>> From: Joe Jin [mailto:joe.jin@oracle.com]
>>>> Sent: Wednesday, July 11, 2012 7:58 PM
>>>> To: Dave, Tushar N
>>>> Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>>>> kernel@vger.kernel.org
>>>> Subject: Re: 82571EB: Detected Hardware Unit Hang
>>>>
>>>> On 07/12/12 10:52, Dave, Tushar N wrote:
>>>>> What is the exact error messages in BIOS log?
>>>>
>>>> Error message from BIOS event log:
>>>> 07/12/12 05:54:00
>>>>    PCI Express Non-Fatal Error
>>>>
>>>> Thanks,
>>>> Joe
>> Hi Tushar,
>>
>> Please find eeprom from attachment.
> 
> Do you have lspci -vvv dump of entire system before and after issue occurs? If you have can you send it to me?
> 

Before:
05:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Oracle Corporation x4 PCI-Express Quad Gigabit Ethernet UTP Low Profile Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin B routed to IRQ 80
	Region 0: Memory at fbde0000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at fbdc0000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at dc00 [size=32]
	Expansion ROM at fbda0000 [disabled] [size=128K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee33000  Data: 407c
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt- UnxCmplt- RxOF- MalfTLP+ ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 12, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-15-17-ff-ff-b9-77-9c
	Kernel driver in use: e1000e
	Kernel modules: e1000e


After:
05:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (Copper) (rev 06)
	Subsystem: Oracle Corporation x4 PCI-Express Quad Gigabit Ethernet UTP Low Profile Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin B routed to IRQ 80
	Region 0: Memory at fbde0000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at fbdc0000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at dc00 [size=32]
	Expansion ROM at fbda0000 [disabled] [size=128K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee33000  Data: 407c
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr+ UnsuppReq+ AuxPwr+ TransPend+
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt- UnxCmplt- RxOF- MalfTLP+ ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 12, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-15-17-ff-ff-b9-77-9c
	Kernel driver in use: e1000e
	Kernel modules: e1000e

Different of them:
Before:		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
After		DevSta:	CorrErr- UncorrErr+ FatalErr+ UnsuppReq+ AuxPwr+ TransPend+


Thanks,
Joe
