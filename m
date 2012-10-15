Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2JOPDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 11:03:17 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:27490 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab2JOPDQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 11:03:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI9371I1432Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3hd25hf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441hbe9i35h1155h)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: "linuxppc-dev@linux.freescale.net" <linuxppc-dev@linux.freescale.net>,
        Kumar Gala <galak@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Anatolij Gustschin <agust@denx.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [for 3.4] drivers/virt: the Freescale hypervisor
 driver doesn't need to check MSR[GS]
Thread-Topic: [PATCH 1/2] [for 3.4] drivers/virt: the Freescale hypervisor
 driver doesn't need to check MSR[GS]
Thread-Index: AQHNquYvubd/9a+gOEyr1OdZiR0ssw==
Date: Mon, 15 Oct 2012 15:03:07 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B708100EF3@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1337281828-31120-1-git-send-email-timur@freescale.com>
In-Reply-To: <1337281828-31120-1-git-send-email-timur@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <210BC353762AB6468FA9539AC4858575@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 2:10 PM, Timur Tabi <timur@freescale.com> wrote:
> The MSR[GS] bit indicates whether the kernel is running in processor guest
> state mode, but such a check is unnecessary.  The driver already checks
> for the /hypervisor node and the fsl,hv-version property, so it already
> knows that it's running under the Freescale hypervisor.
>
> There is nothing in the driver that inherently requires guest state,
> anyway.
>
> This fixes a break that can occur in some randconfig builds.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---

Kumar, I posted this patch back in May.  Can you apply it, please?  It
fixes a build break.

-- 
Timur Tabi
Linux kernel developer at Freescale
