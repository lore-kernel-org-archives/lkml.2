Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0IUFCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 01:02:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39969 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0IUFCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 01:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r328COalWptUIIceBYASmgQ3cUVdP5WjBfbHMSm1pjB+GfSq3jWkH9UdqWeEb8UU5E
         cS5Tzk6q47jVJL4yqp+fk7Wtt4qPKr/XTuoyZvOPyqh0sTyOdEmivqf5/ZQ52e/lVml+
         PHqPZmkBLtLooLYD+oWZcDvnLb5mc4fcgr6AE=
Message-ID: <4C983C7D.1050000@gmail.com>
Date: Mon, 20 Sep 2010 22:02:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com>
In-Reply-To: <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 09:52 PM, Matt Turner wrote:
> On Tue, Sep 21, 2010 at 12:18 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> Signed-off-by: Matt Turner<mattst88@gmail.com>
>
> Yeah... I didn't give my sign off.
>
> [snip]

alright... My mistake,amongst putting this together I got a little 
cluttered..

>
>> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
>> index b9647bb..8da39ce 100644
>> --- a/arch/alpha/Kconfig
>> +++ b/arch/alpha/Kconfig
>> @@ -219,7 +219,7 @@ config ALPHA_LX164
>>         bool "LX164"
>>         help
>>           A technical overview of this board is available at
>> -<http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
>> +<http://www.alphalinux.org/>.
>>
>>   config ALPHA_LYNX
>>         bool "Lynx"
>> @@ -483,7 +483,7 @@ config ALPHA_AVANTI
>>         help
>>           Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
>>           Alphas. Info at
>> -<http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
>> +<http://www.alphalinux.org/>.
>>
>>   config ALPHA_BROKEN_IRQ_MASK
>>         bool
>> diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
>> index 85b4aea..c5051aa 100644
>> --- a/arch/alpha/kernel/sys_sio.c
>> +++ b/arch/alpha/kernel/sys_sio.c
>> @@ -154,7 +154,7 @@ noname_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
>>          * bridge (PIRQ0-PIRQ3).  The table below is based on
>>          * information available at:
>>          *
>> -        *   http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
>> +        *  http://web.archive.org/web/*/http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
>>          *
>>          * I have no information on the Avanti interrupt routing, but
>>          * the routing seems to be identical to the Noname except
>
> This change looks harmless. After all, it's changing a comment. But wait.
>
> You're adding a */ into a block comment, thereby prematurely closing
> the comment and breaking compilation.

didnt even think about that.. I really appreciate you pointing this 
out..  I'll go through the whole thing and see if I can figure a good 
fix for the archive.org stuff

>
> I imagine that any other places you've changed the link to archive.org
> has the same problem.
>
> I appreciate the work, but please drop arch/alpha from your patch.
> I'll go through and fix those links at the same time as I update a lot
> of other Kconfig information.
>
> Matt
>

alright.. cool..

Justin P. Mattock
