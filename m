Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0IORhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:37:10 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:12968 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0IORhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:37:09 -0400
Message-ID: <4C910441.20107@hp.com>
Date: Wed, 15 Sep 2010 13:37:05 -0400
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100826 Lightning/1.0b1 Thunderbird/3.0.7
MIME-Version: 1.0
To: Thomas Habets <thomas@habets.pp.se>
CC: Matt Carlson <mcarlson@broadcom.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Michael Chan <mchan@broadcom.com>
Subject: Re: BUG: IPv6 stops working after a while, needs ip ne del command
 to reset
References: <1282024802.2487.687.camel@edumazet-laptop> <alpine.DEB.1.10.1008171053230.21857@red.crap.retrofitta.se> <1282050920.2448.47.camel@edumazet-laptop> <alpine.DEB.1.10.1008171547090.21857@red.crap.retrofitta.se> <1282055659.2448.58.camel@edumazet-laptop> <alpine.DEB.1.10.1008171737260.21857@red.crap.retrofitta.se> <20100817171115.GA4134@mcarlson.broadcom.com> <alpine.DEB.1.10.1008171928160.21857@red.crap.retrofitta.se> <20100817183112.GA4351@mcarlson.broadcom.com> <alpine.DEB.1.10.1008172035520.21857@red.crap.retrofitta.se> <20100818012318.GA4630@mcarlson.broadcom.com> <alpine.DEB.1.10.1008180900350.21857@red.crap.retrofitta.se> <alpine.DEB.1.10.1009011034560.31938@red.crap.retrofitta.se> <4C7E65DA.5020106@hp.com> <alpine.DEB.1.10.1009142134440.25664@red.crap.retrofitta.se>
In-Reply-To: <alpine.DEB.1.10.1009142134440.25664@red.crap.retrofitta.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 03:56 PM, Thomas Habets wrote:
> 
> Sorry for the late reply. I've been swamped.
> 
> On Wed, 1 Sep 2010, Brian Haley wrote:
>> So are you running with this set to "Shared Network Port" mode?  I'm
>> guessing you are.
> 
> Yes, there's no dedicated ILO port.
> 
>> There was another report on netdev back in 11/2008 on this exact
>> hardware,
>> with the same problem.
> 
> I can't seem to find it. Do you happen to have the subject line or
> something?

It was actually a month earlier in 2008, I mis-typed, here's the link:

http://marc.info/?l=linux-netdev&m=122280545121251&w=2

>> I dug-up my notes on the problem, and from what I can tell, the receive
>> multicast filters on the NIC were getting removed, causing both incoming
>> IPv6 and IPv4 multicast packets to get dropped.
> 
> Sounds about right. From what I understand the relevant registers were
> still the same for me when it wasn't working though (if that indeed is
> how the filter is implemented).

One of the outcomes of that investigation was to update the firmware
and/or iLO, I'm not sure if either fixed the problem.

-Brian
