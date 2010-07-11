Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0GKPMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 11:12:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60285 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab0GKPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 11:12:04 -0400
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, "Alexander Clouter" <alex@digriz.org.uk>
Subject: Re: SNATed connections show as original ip in /proc/net/tcp
References: <op.vfn83jvflgimzx@win7> <151pg7-26g.ln1@chipmunk.wormnet.eu>
Date: Sun, 11 Jul 2010 11:11:59 -0400
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Noah McNallie" <n0ah@n0ah.org>
Message-ID: <op.vfopt9kclgimzx@win7>
In-Reply-To: <151pg7-26g.ln1@chipmunk.wormnet.eu>
User-Agent: Opera Mail/10.60 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010 10:30:25 -0400, Alexander Clouter <alex@digriz.org.uk>  
wrote:

> Noah McNallie <n0ah@n0ah.org> wrote:
>>
>> just as the topic describes.
>>
> Probably better to post this to netdev?
>
>> I'm currently doing SNAT to force some destination tcp ports to be  
>> routed
>> through a specific route rather than the default route. To accomplish  
>> this
>> I mark thoes packets with iptables, use 'ip' to specify marked packets  
>> via
>> the specified route, and then use iptables to change their source  
>> address.
>>
> SNAT'ing locally sourced traffic?  That's pretty nasty.
>
> Look into using 'ip rule' and a second routing table.
>
> http://lartc.org/howto/lartc.rpdb.html
>
> You will still need use iptables/MARK to do L4 (tcp/udp/etc) policy
> routing though, however now you can dump the ugly SNATing.
>
> Cheers
>

ok i'll stick it there i must have missed that browsing mailing lists last  
night... uhh as far as ip rule i am using that, that's how i match the  
packets with the firewall mark that need to go out a specific interface  
and to a specific route... i don't believe ip rule has any option to match  
packets based on destination port and change their source address and  
route them out any specific interface, or i'd be doing that all along as  
that would be much better.

noah
