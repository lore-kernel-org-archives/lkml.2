Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2FFDvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 23:51:51 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:52093 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621Ab2FFDvs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 23:51:48 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "rubini@gnudd.com" <rubini@gnudd.com>,
        "anilkumar@ti.com" <anilkumar@ti.com>
Cc: "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "federico.vaga@gmail.com" <federico.vaga@gmail.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "wg@grandegger.com" <wg@grandegger.com>,
        Giancarlo ASNAGHI <giancarlo.asnaghi@st.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 6 Jun 2012 11:50:59 +0800
Subject: RE: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Thread-Topic: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Thread-Index: Ac1DO1KZGmE0xjcmSwi05ujBbNwSvwAWdJsA
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA5EC4E62@EAPEX1MAIL1.st.com>
References: <331ABD5ECB02734CA317220B2BBEABC13E9CB18A@DBDE01.ent.ti.com>
  <4FCE07EE.40003@pengutronix.de>
   <D5ECB3C7A6F99444980976A8C6D896384FA5EC4DFC@EAPEX1MAIL1.st.com>
   <4FC135C6.5030206@grandegger.com> <1677842.Pq7naXsvrI@harkonnen>
   <D5ECB3C7A6F99444980976A8C6D896384FA5EC4B37@EAPEX1MAIL1.st.com>
   <3650428.HarNR9HfNF@harkonnen> <20120605131337.GA15432@mail.gnudd.com>
  <20120605133013.GA16108@mail.gnudd.com>
 <20120605165008.GA21871@mail.gnudd.com>
In-Reply-To: <20120605165008.GA21871@mail.gnudd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: JZb4 Yuez cVEX c5r7 nuFr vT76 wDcL 0gXM 0zYQ 5k3i
 ABGa6Q== AC3eNg== AF/FdQ== AHbovw== AICCMA==
 AKS+og==;10;YQBsAGEAbgBAAGwAaQBuAHUAeAAuAGkAbgB0AGUAbAAuAGMAbwBtADsAYQBsAGEAbgBAAGwAeABvAHIAZwB1AGsALgB1AGsAdQB1AC4AbwByAGcALgB1AGsAOwBhAG4AaQBsAGsAdQBtAGEAcgBAAHQAaQAuAGMAbwBtADsAZgBlAGQAZQByAGkAYwBvAC4AdgBhAGcAYQBAAGcAbQBhAGkAbAAuAGMAbwBtADsAbABpAG4AdQB4AC0AYwBhAG4AQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGsAbABAAHAAZQBuAGcAdQB0AHIAbwBuAGkAeAAuAGQAZQA7AG4AZQB0AGQAZQB2AEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwByAHUAYgBpAG4AaQBAAGcAbgB1AGQAZAAuAGMAbwBtADsAdwBnAEAAZwByAGEAbgBkAGUAZwBnAGUAcgAuAGMAbwBtAA==;Sosha1_v1;7;{F83CAB82-97DC-446A-BCA8-D00EF101C093};YgBoAHUAcABlAHMAaAAuAHMAaABhAHIAbQBhAEAAcwB0AC4AYwBvAG0A;Wed,
 06 Jun 2012 03:50:59
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAFIARgBDAF0AIABjAF8AYwBhAG4AXwBwAGMAaQA6ACAAZwBlAG4AZQByAGkAYwAgAG0AbwBkAHUAbABlACAAZgBvAHIAIABjAF8AYwBhAG4AIABvAG4AIABQAEMASQA=
x-cr-puzzleid: {F83CAB82-97DC-446A-BCA8-D00EF101C093}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: rubini@gnudd.com [mailto:rubini@gnudd.com]
> Sent: Tuesday, June 05, 2012 10:20 PM
> To: anilkumar@ti.com
> Cc: mkl@pengutronix.de; Bhupesh SHARMA; federico.vaga@gmail.com;
> alan@lxorguk.ukuu.org.uk; wg@grandegger.com; Giancarlo ASNAGHI;
> alan@linux.intel.com; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
> 
> > I am late to the discussion, is there any specific reason to maintain
> a
> > separate platform file (c_can_pci.c).
> 
> Because it depends on pci and ifdef is bad.
> 
> > I think 90% of the code is copied from c_can_paltform.c, code
> > changes will be less if you merge to existing c_can platform driver.
> 
> Yes, but then we need to ifdef around, which merges two bad files
> into a single but worse file.
> 
> But since the only current user of c_can is the platform device, why
> not merging the platform with the core and having pci just register a
> platform device?  The only problem I see is that we need cooperation,
> because neither me nor federico have a c_can equipped board besides
> the pci one.
> 

I can see examples of where different platform files are present for SJA CAN controller
as well depending on the underlying bus being used: OpenFirmware, ISA, PCI, etc..,
whilst there is a single core file there as well 'sja1000.c'

[1] Kvaser PCI platform driver, using services exposed by sja1000 core:
	http://lxr.linux.no/linux+v3.4.1/drivers/net/can/sja1000/kvaser_pci.c

[2] EMS PCI platform driver, using services exposed by sja1000 core:
	http://lxr.linux.no/linux+v3.4.1/drivers/net/can/sja1000/ems_pci.c

[3] SJA1000 core:
	http://lxr.linux.no/linux+v3.4.1/drivers/net/can/sja1000/sja1000.c

Here each platform driver has its own version of register read/write routine implementation.
The C_CAN approach is similar to that used by SJA1000. Instead of merging the "platform with the core",
I would instead suggest to have two separate platform drivers (for each bus type) and invoke common
routines kept in say another file 'c_can_platform_common.c', thus insuring that there is no code
duplicity and we have a clean hierarchical structure as well. So we can have:
	- Core file, c_can.c
	- Common platform file, c_can_platform_common.c
	- Platform file, c_can_platform.c, c_can_pci.c, etc..

This ensures that nothing breaks at the end of the existing C_CAN users and we have a clean
file structure as well.

Ofcourse, Wolfgang has a better idea of this structure, as he defined the same for SJA1000 and I 
consulted with him on this, while he was reviewing my initial C_CAN patch set. I will let him and Marc
comment further on my proposal. Your comments are also most welcome :)

Regards,
Bhupesh
