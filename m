Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1LAIBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:01:30 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:17792 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753329Ab1LAIB3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:01:29 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVIMA9-01-CKR-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Unhandled IRQs on AMD E-450
Date: Thu, 1 Dec 2011 16:01:12 +0800
Message-ID: <1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
In-Reply-To: <20111130154445.GA27198@gere.osrc.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Unhandled IRQs on AMD E-450
Thread-Index: AcyvtXtfz0qVZOx/Sgib+qeEAJ+ztwASaWDw
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com> <20111130154445.GA27198@gere.osrc.amd.com>
From: "Huang, Shane" <Shane.Huang@amd.com>
To: Borislav Petkov <bp@amd64.org>,
        Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>
CC: <linux-kernel@vger.kernel.org>, "Huang, Shane" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 01 Dec 2011 08:01:20.0094 (UTC) FILETIME=[690DDFE0:01CCAFFF]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

> Shane, can you guys take a look at this, sounds like some unfortunate
> sharing of AHCI and network IRQ numbers.

I'm adding Dong who might help on this.


Thanks,
Shane


