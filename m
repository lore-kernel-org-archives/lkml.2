Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2DCCaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:30:06 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:19243 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab2DCC37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:29:59 -0400
Message-ID: <4F7A60A4.5040600@hp.com>
Date: Mon, 02 Apr 2012 19:29:56 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, remi@remlab.net, levinsasha928@gmail.com,
        remi.denis-courmont@nokia.com, davej@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phonet: Check input from user before allocating
References: <1333417997.18626.1.camel@edumazet-glaptop> <20120402.215911.1929019308299701014.davem@davemloft.net> <1333419304.18626.5.camel@edumazet-glaptop> <20120402.222300.1137842205135530387.davem@davemloft.net>
In-Reply-To: <20120402.222300.1137842205135530387.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 07:23 PM, David Miller wrote:
> From: Eric Dumazet<eric.dumazet@gmail.com>
> Date: Tue, 03 Apr 2012 04:15:04 +0200
>
>> Any idea of a representative benchmark in dgram af_unix ?
>
> Maybe you could try to make bw_unix from lmbench use
> SOCK_DGRAM? :-)

I don't know it isn't entirely bitrotted, but there are streaming and 
datagram AF_UNIX tests in netperf - they require conditional inclusion 
via ./configure --enable-unixdomain:

http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#DG_005fSTREAM

happy benchmarking,

rick jones
