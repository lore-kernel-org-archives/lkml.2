Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab1EMBVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 21:21:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47252 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab1EMBVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 21:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EYFZJmHC5ccC9eXsj5KMTYaH8Ki0VuqHHSOVKQ+T7cKM28+zEqwSNpVxviaRPYoNlQ
         bDqCzLLzqIpNvfl6rdJq4zYhmv4IfrdbmLxR76BRCE78FqvLZoxlUpey72HrPoGtljL1
         zzxPonueVSMiS4qyOnhIiqI5cSqtW85OHKgpg=
Message-ID: <4DCC87A1.7050604@gmail.com>
Date: Fri, 13 May 2011 09:21:37 +0800
From: WeipingPan <panweiping3@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Tom Herbert <therbert@google.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net:set valid name before calling ndo_init()
References: <1305207541-13311-1-git-send-email-panweiping3@gmail.com> <1305214382.3795.28.camel@edumazet-laptop>
In-Reply-To: <1305214382.3795.28.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 11:33 PM, Eric Dumazet wrote:
> Le jeudi 12 mai 2011 à 21:39 +0800, Weiping Pan(潘卫平) a écrit :
>> From: Pan Weiping<panweiping3@gmail.com>
>>
>> A bug of bonding was invloved by e815d19ffe02bdfda1260949ef2b1806171,
>> see example 1 and 2.
>>
> I cant find e815d19ffe02bdfda1260949ef2b1806171 in net-next-2.6
>
> but I do find 1c5cae815d19ffe02bdfda1260949ef2b1806171
It's my bad. It should be 1c5cae815d19ffe02bdfda1260949ef2b1806171
> Please always use following when referring to a commit :
>
> ... in commit 1c5cae815d19 (net: call dev_alloc_name from
> register_netdevice) ...
>
> - just limit to _first_ 12 chars, no need to have full length
> - give the commit title
>
>
Ok, I will change the commit log and resend the patch.

thanks
Weiping Pan
