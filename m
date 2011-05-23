Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab1EWUQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:16:33 -0400
Received: from mail.candelatech.com ([208.74.158.172]:40113 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1EWUQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:16:32 -0400
Message-ID: <4DDAC099.5020306@candelatech.com>
Date: Mon, 23 May 2011 13:16:25 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joe@perches.com, justinmattock@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]net:8021q:vlan.c Fix pr_info to read on line in the syslog.
References: <1306166698-2036-1-git-send-email-justinmattock@gmail.com>	<1306167781.8687.20.camel@Joe-Laptop> <20110523.155630.1404321441037491870.davem@davemloft.net>
In-Reply-To: <20110523.155630.1404321441037491870.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 12:56 PM, David Miller wrote:
> From: Joe Perches<joe@perches.com>
> Date: Mon, 23 May 2011 09:23:01 -0700
>
>> though I think that emitting names on startup isn't necessary and
>> this is enough:
>
> Agreed, it's not like Ben and I are Napoleon or anything...

I'm fine with that as well.  It was good for the ego, but I
won't mind not getting emails from folks that accidentally
look at their DSL router logs and assume I wrote (and can debug)
the entire AT&T network :)

Thanks,
Ben

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

