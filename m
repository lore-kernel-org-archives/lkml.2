Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1FJDyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:54:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54290 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1FJDyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iwHZbEGiKqyjHG4mHlFpnVLNQ4XqKlcHEMHRe5I1ZTwuJ1liyDREGma7if1uyUJDAE
         B143Wrt+OCB8X/9/oV1B4GikG7WQP2YgT+Un8Bbj+q1+Yg9PcKf7Yh7uDFTVio6+egoR
         9IHrgE80tvSGh06m+WICVuoF7b6R0HLVkUEtk=
Message-ID: <4DF19565.9070601@gmail.com>
Date: Fri, 10 Jun 2011 13:54:13 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
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
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com> <20110610025532.GE26006@linux-sh.org> <4DF189F2.3040009@gmail.com> <1307675512.20439.2.camel@Joe-Laptop> <4DF18BDC.8010306@gmail.com> <1307676240.20439.9.camel@Joe-Laptop> <4DF1902A.1040305@gmail.com> <20110610035115.GF26006@linux-sh.org>
In-Reply-To: <20110610035115.GF26006@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/11 13:51, Paul Mundt wrote:
> On Fri, Jun 10, 2011 at 01:31:54PM +1000, Ryan Mallon wrote:
>> On 10/06/11 13:24, Joe Perches wrote:
>>> On Fri, 2011-06-10 at 13:13 +1000, Ryan Mallon wrote:
>>>> On 10/06/11 13:11, Joe Perches wrote:
>>>>> On Fri, 2011-06-10 at 13:05 +1000, Ryan Mallon wrote:
>>>>>> On 10/06/11 12:55, Paul Mundt wrote:
>>>>>>> On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
>>>>>>>> I no longer work at Bluewater Systems. Update my email address
>>>>>>>> accordingly.
>>>>>>> Is this sort of churn really necessary?
>>>>> get_maintainer uses the name and address in the first seen
>>>>> commit matching on the full name where possible.
>>>> Okay, what is the correct fix then so that people get the right email
>>>> address for me?
>>> I believe updating the MAINTAINERS file and
>>> authoring and committing patches that take
>>> your email address out of files works well.
>> If I strip my email address, but leave my name and copyright in the
>> files the patch will have the same amount of churn right?
>>
> Not necessarily. You can leave the copyright bits intact but simply
> update (or strip out) the address from the MODULE_AUTHOR part so people
> still get the proper data from modinfo and so on. There are many people
> with non-working email addresses in copyright statements tree-wide, so
> there's certainly a precedent for it. It's also a motivator for not
> bothering with inlining the email address in the future, unless it's to
> avoid ambiguity (ie, a work done on behalf of an employer, who retains
> all rights).
>
> If there are files that you have authored but get_maintainers is
> groveling the commits and using your old address, you can preempt this by
> simply adding a MAINTAINERS entry with the appropriate file pattern, too.

Okay, so what is the preferred solution. Do I leave the old address in 
the files and add MAINTAINERS entries for everything with my correct 
address, or do I delete my email address (but leave my name) in all of 
the files?

~Ryan


