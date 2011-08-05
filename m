Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1HEDvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:51:11 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:46428
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998Ab1HEDvI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:51:08 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/serial/ucc_uart.c: Fix compiler warning
Thread-Topic: [PATCH] drivers/serial/ucc_uart.c: Fix compiler warning
Thread-Index: AQHMUyLmQrUU4BcNoEuWZeW0C615nA==
Date: Fri, 5 Aug 2011 03:51:05 +0000
Message-ID: <CAOZdJXWUzymk1iAJWVmY17c9exNk57mi-S2G-iiB=g9Ge=uF_Q@mail.gmail.com>
References: <1312445590-2559-1-git-send-email-galak@kernel.crashing.org>
In-Reply-To: <1312445590-2559-1-git-send-email-galak@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.129.36.64]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <6545896E63B9C84E9F5A002CE9AE9262@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 3:13 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
> drivers/tty/serial/ucc_uart.c: In function 'qe2cpu_addr':
> drivers/tty/serial/ucc_uart.c:238:2: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

Acked-by: Timur Tabi <timur@freescale.com>

-- 
Timur Tabi
Linux kernel developer at Freescale
