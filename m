Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab0KRPb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:31:29 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:46880
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255Ab0KRPb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:31:28 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz98dNzz1202hzzz2dh2a8h637h668h67dh685h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Message-ID: <4CE546C5.8060401@freescale.com>
Date: Thu, 18 Nov 2010 09:31:17 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <4CE44B1B.9040709@freescale.com> <20101117215147.GA26792@suse.de> <4CE452CD.3050001@freescale.com> <20101117221903.GA4066@suse.de> <4CE45A4E.70308@freescale.com> <20101118022434.GA9833@suse.de>
In-Reply-To: <20101118022434.GA9833@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 15:32:20.0126 (UTC) FILETIME=[C9F193E0:01CB8735]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> You need to create one as you really have a "bus" here, as you
> described.

What about the fact that it's an Open Firmware driver?  My driver gets probed
for each byte channel node in the device tree.

I'm still not sure why you think I have a bus.  I don't see where the UART
drivers register a bus, and there's not a whole lot different between a byte
channel and a UART.

> Please take a step back and go to your original message where you
> described something like "we have a bus and devices we discover on the
> bus and they have ids". 

I never said we have a bus.  There is no entity that conglomerates the byte
channels.

-- 
Timur Tabi
Linux kernel developer at Freescale

