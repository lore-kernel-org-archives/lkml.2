Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2GBEtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:49:15 -0400
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:49910 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2GBEtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:49:14 -0400
Message-ID: <4FF12842.8080802@genband.com>
Date: Sun, 01 Jul 2012 22:49:06 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: vincent.sanders@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>	<20120629.153656.1141845894730637434.davem@davemloft.net>	<20120629231236.GA28593@mail.collabora.co.uk> <20120629.161821.948325645333976311.davem@davemloft.net>
In-Reply-To: <20120629.161821.948325645333976311.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2012 04:49:07.0100 (UTC) FILETIME=[034125C0:01CD580E]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19012.004
X-TM-AS-Result: No--4.162100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 05:18 PM, David Miller wrote:
> From: Vincent Sanders<vincent.sanders@collabora.co.uk>
> Date: Sat, 30 Jun 2012 00:12:37 +0100
>
>> I had hoped you would have at least read the opening list where I
>> outlined the underlying features which explain why none of the
>> existing IPC match the requirements.
> I had hoped that you had read the part we told you last time where
> we explained why multicast and "reliable delivery" are fundamentally
> incompatible attributes.
>
> We are not creating a full address family in the kernel which exists
> for one, and only one, specific and difficult user.

For what it's worth, the company I work for (and a number of other 
companies) currently use an out-of-tree datagram multicast messaging 
protocol family based on AF_UNIX.

If AF_BUS were to be accepted, it would be essentially trivial for us to 
port our existing userspace messaging library to use it instead of our 
current protocol family, and we would almost certainly do so.

I'd love to see AF_BUS go in.

Chris Friesen

