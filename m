Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1BFOWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 09:22:32 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59929 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1BFOWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 09:22:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FtdOcvmZaRGDFzxHGQkUwRYfmMPdh5GlZM5puxxivi38e+56abQW2tdv5GOTXJ0rMo
         WuGM2R52H7LsjqEGBqXWKCRwYM9duC5AOsU+K3ADr3A+9Hc8I3fvEy4UkX0Ndu7876z5
         GxrEHdaAnkO24ii5nafjBjnzsaVaeqR0al/6k=
Message-ID: <4D4EAEA1.9030106@googlemail.com>
Date: Sun, 06 Feb 2011 15:22:25 +0100
From: "R. Herbst" <ruediger.herbst@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Matt <jackdachef@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, benh@kernel.crashing.org
Subject: Re: Sun GEM PPC32 Bug?
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>	<1296852667.2349.804.camel@pasglop>	<20110204.145508.59670453.davem@davemloft.net> <AANLkTi=s7Yro4TqtmgW4HPnJx3HiWvX9iJ9NUOYXcR+j@mail.gmail.com>
In-Reply-To: <AANLkTi=s7Yro4TqtmgW4HPnJx3HiWvX9iJ9NUOYXcR+j@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.02.2011 21:32, schrieb Matt:
>> Is there a special Kernel parameter (sysctl.conf), that makes it
>> possible to use the Network. So how it is now I canŽt work with it. What
>> can I do at the moment?
>>      
>    
>> linuxopjemac, thank you for referring to Ben. He replied and might look into it.
>>      
>    
>> Meanwhile, I put the module reloading and interface restarting into a cron job that executes every hour: sudo crontab -e
>>      
> # m h  dom mon dow   command
> 0  *  *   *   *     /usr/sbin/fix-sungem
>
>    
>> and the script /usr/sbin/fix-sungem contains
>>      
> /sbin/ifdown eth0&&  /sbin/rmmod sungem&&  /sbin/modprobe sungem&&
> /sbin/ifup eth0
>
> Hope that helps somewhat
>
> Regards
>
> Matt
>    
Sorry. No positive effect in my case. Same bad Kernel-Messages for Sun-Gem.

Regards
Rüdi
