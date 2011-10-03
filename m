Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab1JCUNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:13:46 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:33861 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757505Ab1JCUNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:13:38 -0400
Message-ID: <4E8A1770.20001@xenotime.net>
Date: Mon, 03 Oct 2011 13:13:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Jan Keromnes <jan.keromnes@gmail.com>
CC: torvalds@linux-foundation.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][TRIVIAL] Fixed alphabetical order in CREDITS
References: <4E88A947.7020702@gmail.com> <4E88AEE5.2050904@xenotime.net> <4E8A0BA4.4020905@gmail.com>
In-Reply-To: <4E8A0BA4.4020905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/11 12:23, Jan Keromnes wrote:
> On 10/02/2011 08:35 PM, Randy Dunlap wrote:
>> On 10/02/11 11:11, Jan Keromnes wrote:
>>> diff --git a/CREDITS b/CREDITS
>>> index 07e32a8..650402c 100644
>>> --- a/CREDITS
>>> +++ b/CREDITS
>>> @@ -90,7 +90,7 @@ N: Erik Andersen
>>>   E:andersen@codepoet.org
>>>   W:http://www.codepoet.org/
>>>   P: 1024D/30D39057 1BC4 2742 E885 E4DE 9301  0C82 5F9B 643E 30D3 9057
>>> -D: Maintainer of ide-cd and Uniform CD-ROM driver,
>>> +D: Maintainer of ide-cd and Uniform CD-ROM driver,
>> I don't see a change for the line above or several other lines (maybe something
>> ate the trailing spaces that you were trying to fix).
> Yes sorry about that, something in my mailing process is eating trailing spaces.
> 
> Please pull from:
> 
>     git://github.com/jankeromnes/linux.git for-linus
> 
> to get the changes.

>>> @@ -2489,6 +2489,10 @@ S: 12725 SW Millikan Way, Suite 400
>>>   S: Beaverton, Oregon 97005
>> OSDL is no longer there.
> I was unable to ask Patrick Mochel about his current whereabouts, both his email addresses do not exist anymore. How should I fix this? Surely not replace the old address by his Linked In location: Greater Seattle Area?
>>>   S: USA

I would just delete those snail mail address lines.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
