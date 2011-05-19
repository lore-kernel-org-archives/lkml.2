Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab1ESPyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:54:11 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:3487
	"EHLO CH1EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932268Ab1ESPyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:54:09 -0400
X-SpamScore: -12
X-BigFish: VS-12(zzbb2cK1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DD53D1B.4060600@freescale.com>
Date: Thu, 19 May 2011 10:54:03 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/2.0.14-1.fc13 SeaMonkey/2.0.14
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
References: <1305813272-31826-1-git-send-email-timur@freescale.com>	<1305813272-31826-7-git-send-email-timur@freescale.com>	<20110519153358.5876f310@lxorguk.ukuu.org.uk>	<4DD533DE.1020705@freescale.com> <20110519165039.7fd8ec34@lxorguk.ukuu.org.uk>
In-Reply-To: <20110519165039.7fd8ec34@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> > > The kfifo API is probably faster and cleaner. Much of tty still uses
>>> > > CIRC_* because they predate the new APIs.
>> > 
>> > Ok, I'll change it.
> I flag that one up as a general comment - don't feel you need to change
> it if CIRC_* works in your case.

CIRC_* does work for me, so I'll keep it as-is.

>>> > > I guess the only other thing to consider is whether you want to implement
>>> > > a SYSRQ interface on your console ?
>> > 
>> > I don't think byte channels can support SYSRQ, but I'll look into it.

> What some drivers do in this case is nominate some obscure ctrl sequence
> to mean 'sysrq' unless doubled (eg ctrl-^ etc)

Ok, I can do that.

> Depends if the functionality is useful in your environment or not

It is, but I'd like to add it later so that I can make the 2.6.40 window (if it
isn't already too late).


-- 
Timur Tabi
Linux kernel developer at Freescale

