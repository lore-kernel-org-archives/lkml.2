Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1GCBoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 21:44:01 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:58570
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832Ab1GCBn4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 21:43:56 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: Gala Kumar-B11780 <B11780@freescale.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "akpm@kernel.org" <akpm@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-console@vger.kernel.org" <linux-console@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 6/7] [v2] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Thread-Topic: [PATCH 6/7] [v2] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Thread-Index: AQHMFlNy6WlNuEDNKUqo+z69jU2A/5TabHyA
Date: Sun, 3 Jul 2011 01:43:52 +0000
Message-ID: <CAOZdJXVyujA0fsnvYnCcqDYhmgYMk0DwBTh-wEkFN4fCDVYdcA@mail.gmail.com>
References: <1305830092-20104-1-git-send-email-timur@freescale.com>
In-Reply-To: <1305830092-20104-1-git-send-email-timur@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.129.36.64]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <BA00853FE71E9D4987D023849E367C2D@freescale.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 1:34 PM, Timur Tabi <timur@freescale.com> wrote:
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

Greg, would you please pick up this patch for 3.1?  Patches 1-5 are
already queued through the PowerPC tree.

Thank you.

The patch is available here if you need to download it:
http://patchwork.ozlabs.org/patch/96443/

-- 
Timur Tabi
Linux kernel developer at Freescale
