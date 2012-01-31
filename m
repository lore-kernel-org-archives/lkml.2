Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2AaHMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:12:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45403 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2AaHMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:12:20 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH v2 3/3] arm: da830: move NAND and NOR devices as aemif
 MFD slaves
Thread-Topic: [PATCH v2 3/3] arm: da830: move NAND and NOR devices as aemif
 MFD slaves
Thread-Index: AQHM202khHLiVXMMKUGsorsXzhdwLZYcztgAgAex+qD//+OMgIABpAfA
Date: Tue, 31 Jan 2012 07:11:52 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3175EC1F@DBDE01.ent.ti.com>
References: <1327487156-10238-1-git-send-email-prakash.pm@ti.com>
 <1327487156-10238-3-git-send-email-prakash.pm@ti.com>
 <4F2016F4.2080302@mvista.com>
 <A73F36158E33644199EB82C5EC81C7BC3175BD35@DBDE01.ent.ti.com>
 <4F26739F.2070305@mvista.com>
In-Reply-To: <4F26739F.2070305@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Mon, Jan 30, 2012 at 16:10:31, Sergei Shtylyov wrote:
> Hello.
> 
> On 30-01-2012 10:58, Manjunathappa, Prakash wrote:
> 
> >>> NAND and NOR device are made as aemif devices slave, hence device
> >>> registration achieved via aemif MFD driver.
> 
> >>> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>
> >>> ---
> >>> Since v1:
> >>> Patch is generated using -M option.
> 
> >>>    arch/arm/mach-davinci/board-da830-evm.c |   31 +++++++++++++++++++++++--------
> >>>    1 files changed, 23 insertions(+), 8 deletions(-)
> 
> >>      Why only this file? Don't other board files have NAND/NOR devices?
> 
> > Yes I thought of sending board-da850 changes in separate patch. Should I have to send those changes also in this patch?
> 
>     There's also board-dm*.c files. I'd done them all in the same patch.

ok, I will consider all davinci board changes in next version of patch.

Thanks,
Prakash

> 
> WBR, Sergei
> 

