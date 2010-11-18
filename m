Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964Ab0KRRiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:38:19 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:3203 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab0KRRiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:38:18 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz98dNzz1202hzzz2dh2a8h637h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Message-ID: <4CE5647F.5000203@freescale.com>
Date: Thu, 18 Nov 2010 11:38:07 -0600
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
References: <20101117221903.GA4066@suse.de> <4CE45A4E.70308@freescale.com> <20101118022434.GA9833@suse.de> <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com> <20101118163321.GA2723@suse.de> <4CE5562B.8080604@freescale.com> <20101118165136.GA3103@suse.de> <4CE55ACB.80207@freescale.com> <20101118171856.GA4283@suse.de>
In-Reply-To: <20101118171856.GA4283@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 17:39:10.0128 (UTC) FILETIME=[81DBBB00:01CB8747]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> No, you can use the /dev/serial/ links to determine exactly which is
> which depending on the pci id, and other unique identifiers (serial
> numbers, etc.)

I just booted a Linux kernel with the driver I just emailed you, and there's no
/dev/serial/ directory.  The only directories under /dev/ are 'shm' and 'pts',
both of which are empty.

I'm also running a Fedora 13 x86 system, just to see if I need a full modern OS
to see these files.  Again, there is no /dev/serial/, even though I have serial
ports.

Also not that since I'm not registering the byte channels as serial devices, I
wouldn't expect anything in /dev/serial/ to reference them.

What does my driver need to do in order for these /dev/xxxx/ entries to contain
that information?

> Is this somehow not public code?  What just changed in the past 15
> minutes?

Sorry, when I said "not public", I didn't mean it in a legal sense.  Now that I
think about it, I guess that doesn't make much sense.

-- 
Timur Tabi
Linux kernel developer at Freescale

