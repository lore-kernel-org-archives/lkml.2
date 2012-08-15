Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2HORak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:30:40 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:45980 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755953Ab2HORai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:30:38 -0400
Message-ID: <502BDC62.4090408@xenotime.net>
Date: Wed, 15 Aug 2012 10:29:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Salar Ali Mumtaz <salaarali@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xconfig: Display dependency values in debug_info
References: <1343256982-11421-1-git-send-email-salaarali@gmail.com> <50107EB7.8000009@xenotime.net> <CA+jpPM=nrbpDJpaka6xAp4dbEOQjJrtwQWtUXwi_gGS9b4yK-A@mail.gmail.com> <50117812.5080302@xenotime.net> <50213D69.3060904@gmail.com> <5021486B.6020907@xenotime.net> <50240770.6070207@gmail.com> <5025A9C6.1080207@xenotime.net> <502BCF0B.3050401@gmail.com>
In-Reply-To: <502BCF0B.3050401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 09:32 AM, Salar Ali Mumtaz wrote:

> On 12-08-10 08:39 PM, Randy Dunlap wrote:
>> On 08/09/2012 11:54 AM, Salar Ali Mumtaz wrote:
>>
>>> On 12-08-07 12:55 PM, Randy Dunlap wrote:
>>>
>>>> In Kconfig language, is "" the same as 'n' ?
>>>> If so, I'm OK with your proposal above.
>>>>
>>>
>>>
>>> So a colleague of mine tested this and came up with a conclusion that expressions in Kconfig can only deal with boolean or tristate operands and no casting is made with strings. Using any string operand as part of a boolean expression is simply a type error and Kconfig probably marks such operand as 'n', regardless of its value.
>>>
>>
>>
>> My question was about FRV, which is a boolean,
>> but still did not display as 'n' in your example.
>>
>>
> 
> FRV is not a boolean.



Hm, why do you say that?  Please explain.


from arch/frv/Kconfig:

config FRV
	bool
	default y



-- 
~Randy
