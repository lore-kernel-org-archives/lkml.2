Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1FVPXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:23:41 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:7349
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180Ab1FVPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:23:39 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E0208F4.4030800@freescale.com>
Date: Wed, 22 Jun 2011 10:23:32 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>,
        <alan@lxorguk.ukuu.org.uk>, <arnd@arndb.de>
Subject: Re: [PATCH 6/7] [v2] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
References: <1305830092-20104-1-git-send-email-timur@freescale.com>
In-Reply-To: <1305830092-20104-1-git-send-email-timur@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> The ePAPR embedded hypervisor specification provides an API for "byte
> channels", which are serial-like virtual devices for sending and receiving
> streams of bytes.  This driver provides Linux kernel support for byte
> channels via three distinct interfaces:
> 
> 1) An early-console (udbg) driver.  This provides early console output
> through a byte channel.  The byte channel handle must be specified in a
> Kconfig option.
> 
> 2) A normal console driver.  Output is sent to the byte channel designated
> for stdout in the device tree.  The console driver is for handling kernel
> printk calls.
> 
> 3) A tty driver, which is used to handle user-space input and output.  The
> byte channel used for the console is designated as the default tty.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>

I know you guys are busy, but can I get an ACK or two on this patch, if there
are no issues with it?  It's the only one of the seven that doesn't have one.  I
think v2 has addressed all of the concerns raised on version 1.

-- 
Timur Tabi
Linux kernel developer at Freescale

