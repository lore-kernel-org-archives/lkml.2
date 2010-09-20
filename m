Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0ITTak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:30:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54019 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab0ITTai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kO4aK8Ryi4PhpcUKGxu1Pn47/iCyYvBSaCqZgxykLRrDr9wlVRaj6+KZ7/8Xrfosbl
         2okrRepf7d0m3lZA6gtkN/lxUYiWRbeC+0bxgnLfUKRCHqKal05BB9Z/ek8iAdxob8wr
         dKSVw2jUQc4eq6UfXNIqZJybHEXetvI1gO+vo=
Message-ID: <4C97B652.50707@gmail.com>
Date: Mon, 20 Sep 2010 12:30:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: trivial@kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/91] arch/alpha/Kconfig Update broken web addresses
 in the arch directory.
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com> <1283461606-7803-3-git-send-email-justinmattock@gmail.com> <AANLkTikDUUoWSWZhtgGyi3QH6uHJz1Op-inH6_V+e21K@mail.gmail.com>
In-Reply-To: <AANLkTikDUUoWSWZhtgGyi3QH6uHJz1Op-inH6_V+e21K@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 02:49 PM, Matt Turner wrote:
> On Thu, Sep 2, 2010 at 5:06 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> The below patch updates a broken web address that is no longer
>> working due to company buyout, and/or change of location.
>> (Please have a look through, and let me know if any of them
>> need to be changed, and I'll resend an updated patch).
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   arch/alpha/Kconfig |    6 ++++--
>>   1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
>> index b9647bb..16ae162 100644
>> --- a/arch/alpha/Kconfig
>> +++ b/arch/alpha/Kconfig
>> @@ -219,7 +219,8 @@ config ALPHA_LX164
>>         bool "LX164"
>>         help
>>           A technical overview of this board is available at
>> -<http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
>> +<http://web.archive.org/web/*/http://www.unix-ag.org/
>> +         Linux-Alpha/Architectures/LX164.html>.
>>
>>   config ALPHA_LYNX
>>         bool "Lynx"
>> @@ -483,7 +484,8 @@ config ALPHA_AVANTI
>>         help
>>           Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
>>           Alphas. Info at
>> -<http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
>> +<http://web.archive.org/web/*/http://www.unix-ag.org/Linux-Alpha/
>> +         Architectures/Avanti.html>.
>>
>>   config ALPHA_BROKEN_IRQ_MASK
>>         bool
>> --
>> 1.7.2.1
>
> Hi Justin,
> These two links are pretty useless. I think we'd do better to remove
> them until we write proper articles for the AlphaLinux.Org Wiki.
>
> Matt
>


with these two urls, instead of removing the whole thing should I just 
use: http://www.alphalinux.org/
this way theirs at-least something there

Justin P. Mattock
