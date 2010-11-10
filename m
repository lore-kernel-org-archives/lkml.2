Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0KJTID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:08:03 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:47605 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754879Ab0KJTIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:08:00 -0500
Message-ID: <4CDAEDCD.5050603@bluewatersys.com>
Date: Thu, 11 Nov 2010 08:09:01 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/16 v2] pramfs: headers
References: <4CD518C5.6000509@gmail.com>	<4CD7076D.80507@bluewatersys.com>	<AANLkTinJJG0K=BPS0CPzDWcgpRn_yPxZ819N408SwD6d@mail.gmail.com>	<4CD85489.8000503@bluewatersys.com>	<AANLkTim8rAQnVYpZdykd2VuL1N9CvkGj88Kf5qpSuJsC@mail.gmail.com>	<4CD9B09F.5090707@bluewatersys.com>	<AANLkTiky0LLnipJN3tCwcW6F2LEK-REEd=Ovo0ewMubR@mail.gmail.com> <AANLkTik+Vx8W1qXEZ=AqedRSj_D4-k70Xa4h-bnW2MRH@mail.gmail.com>
In-Reply-To: <AANLkTik+Vx8W1qXEZ=AqedRSj_D4-k70Xa4h-bnW2MRH@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 09:15 PM, Marco Stornelli wrote:
> 2010/11/9 Geert Uytterhoeven <geert@linux-m68k.org>:
>> On Tue, Nov 9, 2010 at 21:35, Ryan Mallon <ryan@bluewatersys.com> wrote:
>>> You can still do all of those things without having a fixed endianess.
>>> You just have to have one extra step of telling the external tools what
>>> the endianess is. IMHO, it is better to have the overhead of the endian
>>> conversion in the tools since it is less costly there than an the
>>> embedded system.
>>>
>>> I'm just trying to understand why the fixed endianess rule cannot be
>>> bent for such a specialised filesystem.
>>
>> When it was decided that filesystems should be fixed-endian and support for
>> big-endian ext2 was dropped, the overhead of doing the fixed conversions was
>> deetermined negligible due to compiler optimization.
>> That was ages ago, and current embedded systems run circles around the
>> machines of those days.
>>
>> Note that this is about metadata only. Actual file contents are always just
>> byte streams.
>>
> 
> I can add that the penalties in this case are  negligible due to the
> compensation of the very fast access of the media. In addition, from
> performance point of view I'm pretty happy (you can see the some
> benchmark on the project web site).

Thanks for the explanation guys.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
