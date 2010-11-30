Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0K3TeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:34:04 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:28352
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab0K3TeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:34:03 -0500
X-SpamScore: -22
X-BigFish: VS-22(zz1432N98dN1447Rzz1202hzzz2dh2a8h691h637h668h67dh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Message-ID: <4CF551A0.7030200@freescale.com>
Date: Tue, 30 Nov 2010 13:33:52 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Michael Ellerman <michael@ellerman.id.au>, Greg KH <gregkh@suse.de>,
        Scott Wood <scottwood@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <4CE5657D.8060105@freescale.com> <20101118121356.3491da72@udp111988uds.am.freescale.net> <1290594227.4446.12.camel@concordia> <20101124120818.7951bcb4@udp111988uds.am.freescale.net> <20101124182353.GA10589@suse.de> <1290638647.14502.10.camel@concordia> <20101129214439.GA9830@kroah.com> <4CF42053.8060801@freescale.com> <20101129223030.GA14663@kroah.com> <4CF42B02.1030009@freescale.com> <20101130032915.GA13386@kroah.com>
In-Reply-To: <20101130032915.GA13386@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Nov 2010 19:35:12.0404 (UTC) FILETIME=[B4A7BD40:01CB90C5]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>> > > When this function is called, userspace had better know exactly what is
>>> > > going on as it can get confused due to the lack of uevents happening.
>> > 
>> > Thanks for the explanation, but I'm just concerned that you'll add a comment
>> > that says, "don't call this function".  A quick grep will show that there are
>> > users of this function, and we'll have this exact conversation all over again.
> Care to turn the above into a patch?  I'll be glad to apply that as well

One question: why are uevents not happening?

-- 
Timur Tabi
Linux kernel developer at Freescale

