Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1FJDNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:13:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52211 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1FJDNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZsBG7mrnKDPyXPw9cHVaxKLMWBGOBufNjSgD0un4Lcs/meFwqMyaBJ5phWCiZpJj24
         vW1dO87xeL/qMVM3oXy0EvZKkRll/9ttSengTxAFdzAMxZUyFUyRX/Tx+GtzBT7BPor+
         9ItNWnGc2n4exZ0PHg1VtDhFQFq4KFRt+ZOLM=
Message-ID: <4DF18BDC.8010306@gmail.com>
Date: Fri, 10 Jun 2011 13:13:32 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address across
 the kernel
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>	 <20110610025532.GE26006@linux-sh.org>  <4DF189F2.3040009@gmail.com> <1307675512.20439.2.camel@Joe-Laptop>
In-Reply-To: <1307675512.20439.2.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/11 13:11, Joe Perches wrote:
> On Fri, 2011-06-10 at 13:05 +1000, Ryan Mallon wrote:
>> On 10/06/11 12:55, Paul Mundt wrote:
>>> On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
>>>> I no longer work at Bluewater Systems. Update my email address accordingly.
>>> Is this sort of churn really necessary? By all means, update your
>>> MAINTAINERS entry accordingly, but the rest of it is really pretty
>>> pointless. People are invariably going to consult MAINTAINERS one way or
>>> another and get the updated value accordingly. For the rest of these you
>>> are just as well off ripping out the email address completely.
> I agree.
>
>> The MAINTAINERS entry for me only cover the arm ep93xx arch. Prior to
>> this patch, if I do (for example)
>>
>> ./scripts/get_maintainer.pl -f drivers/power/ds2782_battery.c
>>
>> It gives my old Bluewater email. With this change it gives my gmail
>> account. Not sure if that is because it extracts the email from the
>> source or from the git commit?
> It's the git commit.
>
> get_maintainer uses the name and address in the first seen
> commit matching on the full name where possible.
>
> You can override this with --noremove-duplicates
>
> $ ./scripts/get_maintainer.pl --noremove-duplicates -f drivers/power/ds2782_battery.c
> Anton Vorontsov<cbouatmailru@gmail.com>  (commit_signer:4/5=80%)
> Ryan Mallon<ryan@bluewatersys.com>  (commit_signer:3/5=60%)
> Andrew Morton<akpm@linux-foundation.org>  (commit_signer:1/5=20%)
> Peter Huewe<peterhuewe@gmx.de>  (commit_signer:1/5=20%)
> Mike Rapoport<mike@compulab.co.il>  (commit_signer:1/5=20%)
> linux-kernel@vger.kernel.org (open list)
Okay, what is the correct fix then so that people get the right email 
address for me?

~Ryan



