Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2BQDKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:10:19 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:50092
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab2BQDKR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:10:17 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202hzzz2dh2a8h668h839h8e2h8e3h946hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Li Yang-R58472 <r58472@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Liu Qiang-B32616 <B32616@freescale.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 RESEND] fsl-sata: I/O load balancing
Thread-Topic: [PATCH V2 RESEND] fsl-sata: I/O load balancing
Thread-Index: AQHM7Qzfo8jQ2564h0i7EYKSnS53IJZAaMZg
Date: Fri, 17 Feb 2012 03:09:54 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F0574273C@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
 <1329439216.2892.36.camel@pasglop>
In-Reply-To: <1329439216.2892.36.camel@pasglop>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.126]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I tried a debian install on the p5020ds here and I find SATA to be
>extremely slow, generating millions of interrupts. I think the defaults
>should be a lot more aggressive at coalescing.

The P5020 has a hardware problem with SATA, making it generate more interrupts than it should.  A new revision of the silicon will fix it.

- Leo

