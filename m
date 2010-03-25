Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0CYUe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:34:58 -0400
Received: from crca.org.au ([74.207.252.120]:55736 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab0CYUe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:34:57 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BABC926.8060203@crca.org.au>
Date: Fri, 26 Mar 2010 07:35:50 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jslaby@suse.cz>,
       jirislaby@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: what the patches do Re: [RFC 10/15] PM / Hibernate: user, implement
 user_ops reader
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <201003252114.36605.rjw@sisk.pl> <4BABC5B6.2070301@crca.org.au> <201003252129.10224.rjw@sisk.pl>
In-Reply-To: <201003252129.10224.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 26/03/10 07:29, Rafael J. Wysocki wrote:
> On Thursday 25 March 2010, Nigel Cunningham wrote:
>> Hi.
>>
>> On 26/03/10 07:14, Rafael J. Wysocki wrote:
>>> On Thursday 25 March 2010, Nigel Cunningham wrote:
>>>> Hi.
>>>>
>>>> On 25/03/10 16:30, Pavel Machek wrote:
>>>> [...]
>>>>
>>>>> I have some problems with sws_module_ops interface (handcoded locking
>>>>> is too ugly to live), but it is better than I expected. But there may
>>>>> be better solution available, one that does not need two interfaces to
>>>>> maintain (we can't really get rid of userland interface). What about
>>>>> this?
>>>>
>>>> Just picking up on that bracketed part: Can we flag the userland
>>>> interface (and uswsusp) as being planned for eventual removal now... or
>>>> at least agree to work toward that?
>>>
>>> No, we can't.
>>>
>>>> I'm asking because if we're going to make a go of getting the in-kernel
>>>> code in much better shape, and we have Rafael, Jiri and I - and you? -
>>>> all pulling in the same direction to improve it, there's going to come a
>>>> point (hopefully not too far away) where uswsusp is just making life too
>>>> difficult, and getting rid of it will be a big help.
>>>
>>> We're not dropping user space interfaces used by every distro I know of.
>>
>> So what's your long term plan then?
>
> First, improve the in-kernel thing, second, switch people to it, _then_ remove
> the s2disk interface (after we're reasonably sure it's not used by any major
> distro) and _finally_ simplify things after it's been removed.
>
> Does that sound reasonable?

Well, that's pretty much what I was thinking too - improve then remove. 
I was just suggesting that we flag now that this is our plan, so it 
doesn't come as a surprise to anyone later and we can proceed more 
quickly than might otherwise be the case. I'm imagining it won't take 
long to get uswsusp features into the kernel code.

Regards,

Nigel
