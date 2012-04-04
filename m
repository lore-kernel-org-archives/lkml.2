Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab2DDTd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:33:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab2DDTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:33:55 -0400
Message-ID: <4F7CA21C.2000907@onlinehome.de>
Date: Wed, 04 Apr 2012 21:33:48 +0200
From: Martin <marogge@onlinehome.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net
Subject: Re: 3.3.1 ath9k regression
References: <iM4WB-6k6-3@gated-at.bofh.it> <iM56i-6N7-11@gated-at.bofh.it>
In-Reply-To: <iM56i-6N7-11@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:YMVfXMt2CsNCdrvi+CNk1YFliHsgfjuY5wnRMTMbzRj
 npI+ewxcTSJe0ibtqGU/4XRUynBITQ9gE2ya/9SXworsNIL0t7
 7ezUjOrEc1x8D8XLzZuOIXSsGlBkWc+X6QBGqZiQEQBT6bvGoI
 OOgbnZ3s784X4FmQY1JK3gI7eDJf/bOGdg6s/lExkeXblEK1AB
 GRblbA+qFrfNTPpc6ZJTjc2CMVCJPVTB3V6O4JqABf5RsYooWK
 ulkgHgYupHSgo9HN18bF+vm1FwTQNIdMDKcstzjhcZ14NjLEn1
 PlLUr9OvNQ0kO9l6MNxIzRUqL3oF5iRXt8S2SsW5+KLVwLRuQ3
 n7YiFXA/rNsZAM/Vt7RQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 08:10 AM, Ben Greear wrote:
> Ath9k list should be interested in this...
>
> Ben
>
> On 04/02/2012 10:46 PM, Kelly Anderson wrote:
>> This patch in 3.3.1 is causing ath9k device not to show/work on bootup.
>> ifconfig does not show the device unless I revert this patch. With the
>> patch
>> reverted the device works as expected. This is verified on two different
>> machines that are both using ath9k mini-pcie wifi cards.
>>
>>>> ath9k: fix going to full-sleep on PS idle
>>
>>>> commit c1afdaff90538ef085b756454f12b29575411214 upstream.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at http://www.tux.org/lkml/

fwiw, I find the same issue on an Asus P50IJ, same fix by reverting the 
commit from above.

Martin


02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)
	Subsystem: AzureWave Device 1089
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at feaf0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA 
PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Kernel driver in use: ath9k


