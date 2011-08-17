Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1HQJpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:45:52 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:36997 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1HQJpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:45:50 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz9371K542M1432N98dKzz1202hz31iz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang-B34182 <B34182@freescale.com>
To: "'Bounine, Alexandre'" <Alexandre.Bounine@idt.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: Li Yang-R58472 <r58472@freescale.com>,
        Zang Roy-R61911 <r61911@freescale.com>,
        "'linuxppc-dev@ozlabs.org'" <linuxppc-dev@ozlabs.org>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        Gala Kumar-B11780 <B11780@freescale.com>
Subject: RE: [PATCH] rio: Use discovered bit to test if enumeration is
 complete
Thread-Topic: [PATCH] rio: Use discovered bit to test if enumeration is
 complete
Thread-Index: AQHMVjpYtYso6LG/tkWTr6eOaOnkC5UUyS0AgAwJtiA=
Date: Wed, 17 Aug 2011 09:45:48 +0000
Message-ID: <9A1C2A9ACC704641BC472A1588CE16470EB559@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1312856226-3695-1-git-send-email-b34182@freescale.com>
 <0CE8B6BE3C4AD74AB97D9D29BD24E552020244E5@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552020244E5@CORPEXCH1.na.ads.idt.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.185]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

Could you please apply this patch into your tree?

Thanks a lot!

Regards,

Liu Gang

-----Original Message-----
From: Bounine, Alexandre [mailto:Alexandre.Bounine@idt.com] 
Sent: Tuesday, August 09, 2011 8:36 PM
To: Liu Gang-B34182; linux-kernel@vger.kernel.org
Cc: Li Yang-R58472; Zang Roy-R61911; linuxppc-dev@ozlabs.org; Liu Gang-B34182; akpm@linux-foundation.org; Gala Kumar-B11780
Subject: RE: [PATCH] rio: Use discovered bit to test if enumeration is complete

On Monday, August 08, 2011 at 10:17 PM, Liu Gang wrote:
> Subject: [PATCH] rio: Use discovered bit to test if enumeration is 
> complete
> 
> The discovered bit in PGCCSR register indicates if the device has been 
> discovered by system host. In Rapidio system, some agent devices can 
> also be master devices. They can issue requests into the system.
> 
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
>  drivers/rapidio/rio-scan.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>



