Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0GKPIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 11:08:21 -0400
Received: from lo.gmane.org ([80.91.229.12]:36155 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0GKPIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 11:08:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: SNATed connections show as original ip in /proc/net/tcp
Date: Sun, 11 Jul 2010 15:30:25 +0100
Message-ID: <151pg7-26g.ln1@chipmunk.wormnet.eu>
References: <op.vfn83jvflgimzx@win7>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noah McNallie <n0ah@n0ah.org> wrote:
> 
> just as the topic describes.
>
Probably better to post this to netdev?

> I'm currently doing SNAT to force some destination tcp ports to be routed  
> through a specific route rather than the default route. To accomplish this  
> I mark thoes packets with iptables, use 'ip' to specify marked packets via  
> the specified route, and then use iptables to change their source address.
> 
SNAT'ing locally sourced traffic?  That's pretty nasty.

Look into using 'ip rule' and a second routing table.

http://lartc.org/howto/lartc.rpdb.html

You will still need use iptables/MARK to do L4 (tcp/udp/etc) policy 
routing though, however now you can dump the ugly SNATing.

Cheers

-- 
Alexander Clouter
.sigmonster says: Where do your SOCKS go when you lose them in th' WASHER?

