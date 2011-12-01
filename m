Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab1LASlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:41:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab1LASlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:41:04 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=s3E4aK5dlEwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=k2Tg5SkfwM9oBtrdy1AA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Suspend and resume on ASUS Laptops
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <1322763379.30977.33.camel@frodo>
References: <1322712689.30977.11.camel@frodo>
	 <201112011248.44449.oneukum@suse.de> <1322749734.30977.16.camel@frodo>
	 <201112011538.06912.oneukum@suse.de>  <4ED796AF.60606@linux.vnet.ibm.com>
	 <1322763379.30977.33.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 13:41:01 -0500
Message-ID: <1322764861.30977.35.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is useful, but here's the lspci -vv output of the
devices under ehci_hcd

00:1a.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 1157
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at dfc08000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1d.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 1157
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at dfc07000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

-- Steve


