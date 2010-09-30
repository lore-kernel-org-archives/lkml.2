Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0I3Mcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:32:48 -0400
Received: from smtp.df.ru ([195.42.160.16]:48106 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab0I3Mcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:32:46 -0400
Date: Thu, 30 Sep 2010 16:30:48 +0400
From: Alexey Vlasov <renton@renton.name>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Packet time delays on multi-core systems
Message-ID: <20100930123048.GA4094@beaver.vrungel.ru>
References: <20100929191851.GC86786@beaver.vrungel.ru> <1285796721.5211.156.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1285796721.5211.156.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 11:45:21PM +0200, Eric Dumazet wrote:
> But if you send SYN packets in the same time, (logged), this might
> slow
> down the reception (and answers) of ICMP frames. LOG target can be
> quite
> expensive...

Yes, it's clear that  some slow down can appear, but 100 ms is too much,
and this happens at 200 SYN packets in 2 minutes just as in my example.
On old servers where some tx/rx are missing in NIC card I don't see
such a situation even at more then 1000 SYN-packets per sec.

> Is using other rules gives same problem ?
>
> iptables -A OUTPUT -p tcp -m tcp --dport 80 --tcp-flags

No, only LOG gives such a scheme.

-- 
BRGDS. Alexey Vlasov.
