Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0IBVqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:46:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58941 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab0IBVqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Zp8gr7zbCnPsLg8+JJMaUl/2xpJG9qAd3IdfIVRYV0PxqMCuCm3mS60szA1dsIO7ku
         jNCpfC/XnNwwVanHxnOouLvBBYXFKxzhm7G8tmEgIjE8KzunwIUnsjD4c1y3y4zXdoDd
         0099j7Ugfesj27oZU36HDBDMnMVm7Ex8eb4wQ=
Message-ID: <4C801B51.9000008@gmail.com>
Date: Thu, 02 Sep 2010 14:46:57 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: trivial@kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH 02/91] arch/alpha/Kconfig Update broken web addresses
 in the arch directory.
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com> <1283461606-7803-3-git-send-email-justinmattock@gmail.com> <20100902141012.9769b977.rdunlap@xenotime.net>
In-Reply-To: <20100902141012.9769b977.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 02:10 PM, Randy Dunlap wrote:
> On Thu,  2 Sep 2010 14:06:33 -0700 Justin P. Mattock wrote:
>
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
>>   	bool "LX164"
>>   	help
>>   	  A technical overview of this board is available at
>> -	<http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
>> +	<http://web.archive.org/web/*/http://www.unix-ag.org/
>> +	  Linux-Alpha/Architectures/LX164.html>.
>>
>>   config ALPHA_LYNX
>>   	bool "Lynx"
>> @@ -483,7 +484,8 @@ config ALPHA_AVANTI
>>   	help
>>   	  Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
>>   	  Alphas. Info at
>> -	<http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
>> +	<http://web.archive.org/web/*/http://www.unix-ag.org/Linux-Alpha/
>> +	  Architectures/Avanti.html>.
>>
>>   config ALPHA_BROKEN_IRQ_MASK
>>   	bool
>> --
>
> I wouldn't split long URLs, regardless of any column limit _guidelines_.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

yeah that's what I was going by..(theres a few in here that do this)I'll 
go through and fix those up.

Justin P. Mattock
