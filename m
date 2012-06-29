Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2F2TuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 15:50:19 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:45674 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2F2TuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:50:18 -0400
X-Greylist: delayed 5504 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2012 15:50:16 EDT
Message-ID: <4FEDF107.8030700@genband.com>
Date: Fri, 29 Jun 2012 12:16:39 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: AF_BUS socket address family
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
In-Reply-To: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2012 18:16:40.0807 (UTC) FILETIME=[54ACD770:01CD5623]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19006.001
X-TM-AS-Result: No--8.450000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 10:45 AM, Vincent Sanders wrote:
> This series adds the bus address family (AF_BUS) it is against
> net-next as of yesterday.
>
> AF_BUS is a message oriented inter process communication system.
>
> The principle features are:
>
>   - Reliable datagram based communication (all sockets are of type
>     SOCK_SEQPACKET)
>
>   - Multicast message delivery (one to many, unicast as a subset)
>
>   - Strict ordering (messages are delivered to every client in the same order)
>
>   - Ability to pass file descriptors
>
>   - Ability to pass credentials
>

I haven't had time to look at the code yet, but if you haven't already 
I'd like to propose adding the ability for someone with suitable 
privileges to eavesdrop on all communications.  We've been using 
something similar to this (essentially a simplified multicast unix 
datagram protocol) for many years now and having a tcpdump-like ability 
is very useful for debugging.

Chris


