Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0K2VvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:51:22 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:42265
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab0K2VvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:51:21 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h691h637h668h67dh65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Message-ID: <4CF42053.8060801@freescale.com>
Date: Mon, 29 Nov 2010 15:51:15 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Michael Ellerman <michael@ellerman.id.au>, Greg KH <gregkh@suse.de>,
        Scott Wood <scottwood@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        <devicetree-discuss@vger.kernel.org>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com> <20101118112146.3275eb08@udp111988uds.am.freescale.net> <4CE5657D.8060105@freescale.com> <20101118121356.3491da72@udp111988uds.am.freescale.net> <1290594227.4446.12.camel@concordia> <20101124120818.7951bcb4@udp111988uds.am.freescale.net> <20101124182353.GA10589@suse.de> <1290638647.14502.10.camel@concordia> <20101129214439.GA9830@kroah.com>
In-Reply-To: <20101129214439.GA9830@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2010 21:52:33.0953 (UTC) FILETIME=[BA969110:01CB900F]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> > + * "Never use this function, bad things will happen" - gregkh
> Nice, I like it :)
> 
> I'll go queue this up.

How about something a little more descriptive?  You said that the networking
code can use it.  Could you add some text to explain what the networking code
does with it, and why it's the only allow caller of this code?

-- 
Timur Tabi
Linux kernel developer at Freescale

