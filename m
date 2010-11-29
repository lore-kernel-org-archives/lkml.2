Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0K2Wgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:36:54 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:18183 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0K2Wgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:36:53 -0500
X-SpamScore: -22
X-BigFish: VS-22(zz1432N98dN1447Rzz1202hzzz2dh2a8h691h637h668h67dh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Message-ID: <4CF42B02.1030009@freescale.com>
Date: Mon, 29 Nov 2010 16:36:50 -0600
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
References: <4CE54E40.9040503@freescale.com> <20101118112146.3275eb08@udp111988uds.am.freescale.net> <4CE5657D.8060105@freescale.com> <20101118121356.3491da72@udp111988uds.am.freescale.net> <1290594227.4446.12.camel@concordia> <20101124120818.7951bcb4@udp111988uds.am.freescale.net> <20101124182353.GA10589@suse.de> <1290638647.14502.10.camel@concordia> <20101129214439.GA9830@kroah.com> <4CF42053.8060801@freescale.com> <20101129223030.GA14663@kroah.com>
In-Reply-To: <20101129223030.GA14663@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2010 22:38:09.0662 (UTC) FILETIME=[1932A1E0:01CB9016]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I really don't want to get into it, but the networking code is the only
> thing that allows this due to the userspace "want" to rename devices
> because we can't create symlinks to network devices like we can for all
> other devices (as they use device nodes.)
> 
> When this function is called, userspace had better know exactly what is
> going on as it can get confused due to the lack of uevents happening.

Thanks for the explanation, but I'm just concerned that you'll add a comment
that says, "don't call this function".  A quick grep will show that there are
users of this function, and we'll have this exact conversation all over again.

-- 
Timur Tabi
Linux kernel developer at Freescale

