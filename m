Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab2F2Tdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 15:33:46 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:39768 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755194Ab2F2Tdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:33:45 -0400
Message-ID: <1340998421.3066.10.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: AF_BUS socket address family
From: Ben Hutchings <bhutchings@solarflare.com>
To: Chris Friesen <chris.friesen@genband.com>
CC: Vincent Sanders <vincent.sanders@collabora.co.uk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 29 Jun 2012 20:33:41 +0100
In-Reply-To: <4FEDF107.8030700@genband.com>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
	 <4FEDF107.8030700@genband.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 12:16 -0600, Chris Friesen wrote:
> On 06/29/2012 10:45 AM, Vincent Sanders wrote:
> > This series adds the bus address family (AF_BUS) it is against
> > net-next as of yesterday.
> >
> > AF_BUS is a message oriented inter process communication system.
> >
> > The principle features are:
> >
> >   - Reliable datagram based communication (all sockets are of type
> >     SOCK_SEQPACKET)
> >
> >   - Multicast message delivery (one to many, unicast as a subset)
> >
> >   - Strict ordering (messages are delivered to every client in the same order)
> >
> >   - Ability to pass file descriptors
> >
> >   - Ability to pass credentials
> >
> 
> I haven't had time to look at the code yet, but if you haven't already 
> I'd like to propose adding the ability for someone with suitable 
> privileges to eavesdrop on all communications.  We've been using 
> something similar to this (essentially a simplified multicast unix 
> datagram protocol) for many years now and having a tcpdump-like ability 
> is very useful for debugging.

It's in there (look for 'eavesdrop' in 08/15).

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

