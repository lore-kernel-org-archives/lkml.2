Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1JCXjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:39:32 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:43898 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1JCXjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:39:31 -0400
Message-ID: <4E8A46E9.2070509@genband.com>
Date: Mon, 03 Oct 2011 17:36:09 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: johnmusbach1@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Handling of multiple DHCP OFFERs
References: <loom.20111004T011704-753@post.gmane.org> <20111003.192129.745977451712127515.davem@davemloft.net>
In-Reply-To: <20111003.192129.745977451712127515.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Oct 2011 23:36:10.0866 (UTC) FILETIME=[3B633520:01CC8225]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18424.002
X-TM-AS-Result: No--11.165500-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 05:21 PM, David Miller wrote:
> From: John Musbach<johnmusbach1@gmail.com>
> Date: Mon, 3 Oct 2011 23:18:06 +0000 (UTC)
>
>> Hello, I am configuring a network that'll have multiple DHCP servers
>> and I was wondering how Linux handles receiving multiple DHCP OFFERs?
>> More specifically, how does it choose which one to prefer and how long
>> will it wait for a answer from a preferred server if the other server
>> answers first? Thanks.
>
> There are multiple userspace implementations of DHCP, and the kernel
> does not usually get involved at all.  You'll therefore have to ask
> the folks who write and maintain the various DHCP implementations.

What about netbooting?  Or are you expecting people to use initramfs 
with a userspace implementation?

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
