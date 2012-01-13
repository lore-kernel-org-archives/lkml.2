Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2AMJ5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:57:41 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:5337
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab2AMJ5j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:57:39 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz9371I1432N98dKzz1202hzz8275bh8275dha509lz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Li Yang-R58472 <r58472@freescale.com>
CC: "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH][SDK v1.2] sata: I/O load balancing
Thread-Topic: [PATCH][SDK v1.2] sata: I/O load balancing
Thread-Index: AQHM0dK3wsXQniayrkSVvMYo0/YyaZYKbrIA//+dy5Q=
Date: Fri, 13 Jan 2012 09:57:35 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB701320C@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1326443147-26645-1-git-send-email-qiang.liu@freescale.com>,<CADRPPNQsVB-2jR0UaX6RB_4PCf9kt4UXvAXnxaVk=LsBcwGowg@mail.gmail.com>
In-Reply-To: <CADRPPNQsVB-2jR0UaX6RB_4PCf9kt4UXvAXnxaVk=LsBcwGowg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
> From: linux-ide-owner@vger.kernel.org [linux-ide-owner@vger.kernel.org] on behalf of Li Yang [leoli@freescale.com]
> Sent: Friday, January 13, 2012 3:36 AM
> To: Liu Qiang-B32616
> Cc: jgarzik@pobox.com; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Liu Qiang-B32616
> Subject: Re: [PATCH][SDK v1.2] sata: I/O load balancing

> On Fri, Jan 13, 2012 at 4:25 PM, Qiang Liu <qiang.liu@freescale.com> wrote:
> > From: Qiang Liu <b32616@freescale.com>
> >
> > Reduce interrupt singnals through reset Interrupt Coalescing Control Reg.
> > Increase the threshold value of interrupt and timer will reduce the number
> > of complete interrupt sharply. Improve the system performance effectively.

> There is always a trade off of throughput and latency by using
> interrupt coalescing.  It's not reasonable to assume that the
> throughput is the only factor to be considered and set the coalescing
> threshold and timeout to the max value by default.  Have you carried
> out other benchmark like copying many small files?
No, I didn't test small file. I think this won't affect system load. I can have a test
and describe the result in next patch.

> It will be safer to make the coalescing runtime configurable like the
> sata_mv driver, IMO.
Ok, I will do it like this in next patch.


- Leo
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


