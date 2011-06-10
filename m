Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1FJDcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:32:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48590 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1FJDcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=E3wRSR5+eIERDUqaMEVlpOaIkHKHRiK860ZfzPo6C2EVjjCeJ/VA9Gf4FUa2H16jo4
         w55yMYAHTxWwBkBgcNzzRXcY0Hxrsh9lC86Sm6cZz75Cbx15XWlm+tpnRXKgNAJB8Xf1
         qD14YTuTPe43C7FnzGCftnlgBTvVHAzogHOwI=
Message-ID: <4DF1902A.1040305@gmail.com>
Date: Fri, 10 Jun 2011 13:31:54 +1000
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
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>	 <20110610025532.GE26006@linux-sh.org>  <4DF189F2.3040009@gmail.com>	 <1307675512.20439.2.camel@Joe-Laptop>  <4DF18BDC.8010306@gmail.com> <1307676240.20439.9.camel@Joe-Laptop>
In-Reply-To: <1307676240.20439.9.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/11 13:24, Joe Perches wrote:
> On Fri, 2011-06-10 at 13:13 +1000, Ryan Mallon wrote:
>> On 10/06/11 13:11, Joe Perches wrote:
>>> On Fri, 2011-06-10 at 13:05 +1000, Ryan Mallon wrote:
>>>> On 10/06/11 12:55, Paul Mundt wrote:
>>>>> On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
>>>>>> I no longer work at Bluewater Systems. Update my email address accordingly.
>>>>> Is this sort of churn really necessary?
>>> get_maintainer uses the name and address in the first seen
>>> commit matching on the full name where possible.
>> Okay, what is the correct fix then so that people get the right email
>> address for me?
> I believe updating the MAINTAINERS file and
> authoring and committing patches that take
> your email address out of files works well.

If I strip my email address, but leave my name and copyright in the 
files the patch will have the same amount of churn right?

> Some think that it's better to keep current
> email addresses in the files.  I think it
> has to do with European data retention laws.
>
> Not sure if that applies to you.

I basically just want email to arrive at the correct address. I can 
catch misdirected stuff which gets Cc'ed to a mailing list, but 
sometimes people send me things off list which will just get lost.

~Ryan

