Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab1ESRHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:07:12 -0400
Received: from s040.panelboxmanager.com ([72.55.186.60]:47430 "EHLO
	s040.panelboxmanager.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab1ESRHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:07:09 -0400
Message-ID: <4DD54E89.7050707@techboom.com>
Date: Thu, 19 May 2011 13:08:25 -0400
From: TB <lkml@techboom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: kernel BUG at net/ipv4/tcp_output.c:1006!
References: <1305307633.3866.61.camel@edumazet-laptop>	<4DCD86C0.9030904@techboom.com>	<1305316058.3120.6.camel@edumazet-laptop> <20110513.160138.1477780250019480052.davem@davemloft.net>
In-Reply-To: <20110513.160138.1477780250019480052.davem@davemloft.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s040.panelboxmanager.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - techboom.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-05-13 04:01 PM, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Fri, 13 May 2011 21:47:38 +0200
> 
>> I suspect we should push commit 2fceec13375e5d98 (tcp: len check is
>> unnecessarily devastating, change to WARN_ON) to stable if not already
>> done...
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2fceec13375e5d98
>>
>> David, is this commit in your stable queue ?
> 
> No, but now it is.

We've put this commit with the previous tcp_cubic patch on 60 of our
servers and we're waiting to see how it goes.
