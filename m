Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab1GERdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:33:03 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:57769 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884Ab1GERdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:33:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=e3SGrvVXOUvKT53dEdKc2Iwc6pxLBTtBbwUr65Eo/RzRcDVKtftbTIRv38bqwZzx;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4E134ACB.9020002@earthlink.net>
Date: Tue, 05 Jul 2011 13:32:59 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel -2.6.35.13 longterm
References: <4E13212D.3020005@earthlink.net> <20110705150557.GA2348@kroah.com>
In-Reply-To: <20110705150557.GA2348@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec7958d9b72ef969a1b7974924ab00e4ee72350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2011 11:05 AM, Greg KH wrote:
> On Tue, Jul 05, 2011 at 10:35:25AM -0400, Stephen Clark wrote:
>
>> Hello,
>>
>> Is it possible to get the following patches included in the longterm kernel
>> 2.6.35.13?
>>
> Possibly, but you need to email the correct person and email address,
> none of which you did :)
>
> Try stable@kernel.org, and the .35-longterm maintainer (hint, it's not
> me.)
>
>
Ok - hmmm maintainers in 2.6.35.13 still lists you - but I'll look at a later 
kernel maintainers file.
>> They let linux behave according to:
>>
>> "Basic Requirements for IPv6 Customer Edge Routers
>>     draft-ietf-v6ops-ipv6-cpe-router-09"
>>
> That looks like a new feature, not a regression or bugfix, right?
>
> Did you read Documentation/stable_kernel_rules.txt?
>
>
Not til just now. Yes it is a new feature, but with IPV6 it is seems that it 
would be of use.
I know that my company needs it as we are moving off of FreeBSD to Linux for our
fw/vpn/router appliance. The alternative is to just keep applying the patch myself.

>> From: Thomas Graf
>> Subject: [PATCH] ipv6: add special mode accept_ra=2 to accept RA
>> while configured as router
>> Date: Friday, September 3, 2010 - 5:59 am
>>
>>
> You forgot to mention what the git commit id this is upstream in Linus's
> branch, and to copy the people involved in the original patch (author,
> subsystem maintainer, etc.) to see if they agree it should go in.
>
>
How in the world do you get the commit info?
> greg k-h
>
>
Thanks for the response - I'll see if I can get all the info and do a proper 
submission.

Regards,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



