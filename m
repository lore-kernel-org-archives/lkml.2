Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0LBQMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:12:45 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:13923
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757243Ab0LBQMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:12:44 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h691h637h668h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Message-ID: <4CF7C56F.7040001@freescale.com>
Date: Thu, 2 Dec 2010 10:12:31 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>, Michael Ellerman <michael@ellerman.id.au>,
        Greg KH <gregkh@suse.de>, Wood Scott-B07421 <scottwood@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <1290594227.4446.12.camel@concordia> <20101124120818.7951bcb4@udp111988uds.am.freescale.net> <20101124182353.GA10589@suse.de> <1290638647.14502.10.camel@concordia> <20101129214439.GA9830@kroah.com> <4CF42053.8060801@freescale.com> <20101129223030.GA14663@kroah.com> <4CF42B02.1030009@freescale.com> <20101130032915.GA13386@kroah.com> <4CF551A0.7030200@freescale.com> <20101201010011.GB31571@kroah.com> <AANLkTi=foTZsnNBgYYAZySPWuwueEraeXGTQz+1aefKm@mail.gmail.com>
In-Reply-To: <AANLkTi=foTZsnNBgYYAZySPWuwueEraeXGTQz+1aefKm@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2010 16:13:54.0652 (UTC) FILETIME=[EA9489C0:01CB923B]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> 
> It's racy at many levels, symlinks and other stuff are not replaced
> atomically, you get a "move" uevent", but it's not easy to connect the
> event to the old and new device. Device nodes are not renamed at all,
> there isn't even support for that in the kernel now.

Kay, thank you so much for this explanation.  I wish every function in the
kernel were described so thoroughly!  My life would be so much easier.

I put your text into a patch and posted it for review.

-- 
Timur Tabi
Linux kernel developer at Freescale

