Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab1ESO2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:28:16 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:24251
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933392Ab1ESO2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:28:15 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DD528E8.20203@freescale.com>
Date: Thu, 19 May 2011 09:27:52 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/2.0.14-1.fc13 SeaMonkey/2.0.14
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
References: <1305813272-31826-1-git-send-email-timur@freescale.com> <1305813272-31826-7-git-send-email-timur@freescale.com> <20110519142225.GC21441@kroah.com>
In-Reply-To: <20110519142225.GC21441@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Why do this conversion in the driver?  Shouldn't that be something that
> userspace worries about?

The udbg interface is a very early kernel printk interface.  I don't know what
the "u" stands for, but "dbg" is for "debug".  The udbg interface is removed
once a normal console driver kicks in.

This is why I need to specify the byte channel handle via Kconfig.  This code is
used so early that not even the device tree is available.

All of the udbg_putc functions do this.

-- 
Timur Tabi
Linux kernel developer at Freescale

