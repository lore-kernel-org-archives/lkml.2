Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1LVAwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:52:43 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:46416 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752186Ab1LVAwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:52:41 -0500
Message-ID: <4EF28D6A.7080505@xenotime.net>
Date: Wed, 21 Dec 2011 17:52:42 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Samuel Ortiz <samuel@sortiz.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: linux-next: Tree for Dec 19 (nfc)
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au>	 <4EEFA21B.5010305@xenotime.net> <1324399181.5354.0.camel@sortiz-mobl>	 <4EF23A1F.60803@xenotime.net> <1324500160.5354.3.camel@sortiz-mobl>	 <4EF2569D.1070806@xenotime.net> <1324510522.5354.5.camel@sortiz-mobl>
In-Reply-To: <1324510522.5354.5.camel@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 03:35 PM, Samuel Ortiz wrote:
> On Wed, 2011-12-21 at 13:58 -0800, Randy Dunlap wrote:
>> On 12/21/2011 12:42 PM, Samuel Ortiz wrote:
>>> Hi Randy,
>>>
>>> On Wed, 2011-12-21 at 11:57 -0800, Randy Dunlap wrote:
>>>> On 12/20/2011 08:39 AM, Samuel Ortiz wrote:
>>>>> Hi Randy,
>>>>>
>>>>> On Mon, 2011-12-19 at 12:44 -0800, Randy Dunlap wrote:
>>>>>> On 12/18/2011 11:55 PM, Stephen Rothwell wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> Changes since 20111216:
>>>>>>
>>>>>>
>>>>>> (not new today, just not reported earlier)
>>>>> John applied my fix for this one. It should be fixed now.
>>>>
>>>> Hi Samuel,
>>>>
>>>> Is this supposed to be fixed in linux-next?
>>>> It still fails today (linux-next 20111221).
>>> Do you have a .config for me to look at ?
>>
>> Sure, one of several that failed is attached.
> Thanks, I just tried this one and it seems to work fine. What's your
> toolchain ?
> I'm using: gcc version 4.6.2 (Debian 4.6.2-4)

I'm using:
> gcc --version
gcc (GCC) 4.5.2

so maybe it is something that has been fixed in gcc...

Thanks for checking the config.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
