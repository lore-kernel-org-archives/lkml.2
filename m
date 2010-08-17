Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab0HQSbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:31:32 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2072 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241Ab0HQSbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:31:23 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Date: Tue, 17 Aug 2010 11:31:12 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Thomas Habets" <thomas@habets.pp.se>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, "Michael Chan" <mchan@broadcom.com>
Subject: Re: BUG: IPv6 stops working after a while, needs ip ne del
 command to reset
Message-ID: <20100817183112.GA4351@mcarlson.broadcom.com>
References: <alpine.DEB.1.10.1008161224510.13728@red.crap.retrofitta.se>
 <alpine.DEB.1.10.1008170719180.21857@red.crap.retrofitta.se>
 <1282024802.2487.687.camel@edumazet-laptop>
 <alpine.DEB.1.10.1008171053230.21857@red.crap.retrofitta.se>
 <1282050920.2448.47.camel@edumazet-laptop>
 <alpine.DEB.1.10.1008171547090.21857@red.crap.retrofitta.se>
 <1282055659.2448.58.camel@edumazet-laptop>
 <alpine.DEB.1.10.1008171737260.21857@red.crap.retrofitta.se>
 <20100817171115.GA4134@mcarlson.broadcom.com>
 <alpine.DEB.1.10.1008171928160.21857@red.crap.retrofitta.se>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.1008171928160.21857@red.crap.retrofitta.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 60740AFE3KC80399727-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:29:54AM -0700, Thomas Habets wrote:
> On Tue, 17 Aug 2010, Matt Carlson wrote:
> >>> But if problem remains even with "ifconfig eth0 allmulti" I suspect a
> >>> NIC firmware problem. (allmulti set to 1 all the 128 bits of filters)
> > Thomas, can you give me the output of 'ethtool -i eth0'?
> 
> $ sudo ethtool -i eth0
> driver: tg3
> version: 3.110
> firmware-version: 5715-v3.28, UMP 1.15
> bus-info: 0000:03:04.0

Thanks.  I put the question out to the firmware developer.  While we
wait, can you keep Eric's patch in place and give me the results along
with the output of 'ethtool -d eth0 | grep 0x047' after the problem
happens?

Eric's patch shows the hash registers at the time they are programmed.
I'm interested to see if the values change (by firmware) after the
failure.

