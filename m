Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0CYUfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:35:21 -0400
Received: from crca.org.au ([74.207.252.120]:49204 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0CYUfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:35:19 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BABC93E.3000805@crca.org.au>
Date: Fri, 26 Mar 2010 07:36:14 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC 03/15] PM / Hibernate: separate block_io
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <201003252112.25204.rjw@sisk.pl> <4BABC3D1.1050104@crca.org.au> <201003252133.50206.rjw@sisk.pl>
In-Reply-To: <201003252133.50206.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 26/03/10 07:33, Rafael J. Wysocki wrote:
> On Thursday 25 March 2010, Nigel Cunningham wrote:
>> Hi.
>>
>> On 26/03/10 07:12, Rafael J. Wysocki wrote:
>>> On Thursday 25 March 2010, Nigel Cunningham wrote:
>>>> Hi again.
>>>>
>>>> On 25/03/10 09:58, Nigel Cunningham wrote:
>>>>> Hi.
>>>>>
>>>>> On 25/03/10 08:22, Jiri Slaby wrote:
>>>>>> On 03/24/2010 09:30 PM, Pavel Machek wrote:
>>>>>>> On Tue 2010-03-23 17:17:31, Jiri Slaby wrote:
>>>>>>>> +int sws_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
>>>>>>>> +{
>>>>>>>> +	return submit(READ, sws_resume_bdev, page_off * (PAGE_SIZE>>     9),
>>>>>>>> +			virt_to_page(addr), bio_chain);
>>>>>>>> +}
>>>>>>>
>>>>>>> sws_ is kind of strange prefix. We were trying to get away from
>>>>>>> "swsuspend" name for quite some time...
>>>>>>
>>>>>> No problem to change the prefix to anything else. Do you (anybody)
>>>>>> suggest anything?
>>>>>>
>>>>>
>>>>> How about some abbreviation of hibernate? "hib"?
>>>>
>>>> On further reflection, how about "std" (suspend to disk)? I think that's
>>>> less ugly than the 'hib' suggestion :)
>>>
>>> But it also decodes as "standard" if someone is not in the right context. :-)
>>
>> Ah...
>>
>>> If the "bio" part of the name is not essential (ie. there's no conflicting name
>>> already), we could call it simply hibernate_read_page().
>>
>> Yeah. So we're going with hibernate or hib_ if it needs abbreviating?
>
> I'd just use "hibernate" without abbreviating if reasonably possible.
> We can also use "image_" in some cases I guess.

k.

Nigel
