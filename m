Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1GVTBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:01:09 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:41932
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983Ab1GVTBH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:01:07 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-console@vger.kernel.org" <linux-console@vger.kernel.org>
Subject: Re: [PATCH] [v3] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Thread-Topic: [PATCH] [v3] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Thread-Index: AQHMPcwEIuAieLPSPEu3D/DBaxER+5T5G4MA
Date: Fri, 22 Jul 2011 19:00:40 +0000
Message-ID: <CAOZdJXVD6=UizQjgNK-rJm2hDpZG+Gupo6+M3wW-VS7O1rTo_Q@mail.gmail.com>
References: <1310169972-13756-1-git-send-email-timur@freescale.com>
In-Reply-To: <1310169972-13756-1-git-send-email-timur@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.129.36.64]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <45E7DC55A0B7F24986E4B3504547FDD2@freescale.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 8, 2011 at 7:06 PM, Timur Tabi <timur@freescale.com> wrote:
> The ePAPR embedded hypervisor specification provides an API for "byte
> channels", which are serial-like virtual devices for sending and receiving
> streams of bytes.  This driver provides Linux kernel support for byte
> channels via three distinct interfaces:
>
> 1) An early-console (udbg) driver.  This provides early console output
> through a byte channel.  The byte channel handle must be specified in a
> Kconfig option.
>
> 2) A normal console driver.  Output is sent to the byte channel designated
> for stdout in the device tree.  The console driver is for handling kernel
> printk calls.
>
> 3) A tty driver, which is used to handle user-space input and output.  The
> byte channel used for the console is designated as the default tty.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---

Greg,

I just want to make sure you haven't forgotten this patch.  Will you
be picking it up for 3.1?

-- 
Timur Tabi
Linux kernel developer at Freescale
