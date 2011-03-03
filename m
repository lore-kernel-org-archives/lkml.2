Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab1CCXzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:55:00 -0500
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:37672 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1CCXy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:54:59 -0500
Message-ID: <4D702A24.70805@genband.com>
Date: Thu, 03 Mar 2011 17:54:12 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dev@nico22.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Network link detection
References: <20110303193006.GA29129@svh.nico22.de>	<4D700A5B.2000807@genband.com> <20110303.140106.191399853.davem@davemloft.net>
In-Reply-To: <20110303.140106.191399853.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2011 23:54:13.0778 (UTC) FILETIME=[4C73F720:01CBD9FE]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17990.002
X-TM-AS-Result: No--9.151800-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 04:01 PM, David Miller wrote:
> From: Chris Friesen <chris.friesen@genband.com>
> Date: Thu, 03 Mar 2011 15:38:35 -0600
> 
>> You might look at whether you could write a kernel module to register
>> for NETDEV_CHANGE notifications and pass that back to userspace.
> 
> This is the kind of responses you get when you ask networking specific
> questions and don't CC: netdev :-/

My apologies for misleading the original poster.  I can only claim a
brain fart since I've actually used rtnetlink for other things.

> There is this thing called netlink, you can listen for arbitrary
> network state change events on a socket, and get the link state
> notifications you are looking for.  It's in use by many real
> applications like NetworkManager and co.

For future reference then, to listen for link state notifications you'd
use NETLINK_ROUTE with nl_groups set to RTMGRP_LINK, and the link state
will be signaled in the if_flags field of received messages?

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
