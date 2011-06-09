Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1FIUkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:40:25 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:34126
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892Ab1FIUkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:40:22 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DF12FAD.9010101@freescale.com>
Date: Thu, 9 Jun 2011 15:40:13 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linuxppc-dev@lists.ozlabs.org>,
        <alan@lxorguk.ukuu.org.uk>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <akpm@kernel.org>, <cmetcalf@tilera.com>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307646794-26374-1-git-send-email-timur@freescale.com> <201106092213.13755.arnd@arndb.de> <4DF12A94.6070605@freescale.com> <20110609203117.GB14235@kroah.com>
In-Reply-To: <20110609203117.GB14235@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Why is binary compatibility important?  Isn't this a brand new driver
> for a brand new system?  What userspace tools are out there in the wild
> for such a thing?

This driver (and the hypervisor it talks to, plus the apps, etc) has been in
internal development for three years.  There hasn't been a lot of effort
internally to release this software upstream until recently.

I personally have been complaining about it for quite some time, but I have no
control over our internal release process.  Even when the hardware has been
announced and available for purchase, the BSP is sometimes only available under
NDA.  Eventually, everything is publicly released, and most of the code is
pushed upstream, but it's a long and painful struggle at times.

My concern has been dealing with the headaches of bug reports from customers,
etc as they upgrade their kernel but not their apps, and then wonder why nothing
works.

But as Arnd pointed out, it really isn't as big of deal as I make it out to be.
 I can maintain compatibility internally.  I blame my allergy medicine.

-- 
Timur Tabi
Linux kernel developer at Freescale

