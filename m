Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1FFQLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:11:41 -0400
Received: from outmail015.snc4.facebook.com ([66.220.144.147]:42671 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753703Ab1FFQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:11:39 -0400
Message-ID: <4DECFC5C.40603@fb.com>
Date: Mon, 06 Jun 2011 09:12:12 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] atomic: generalize atomic_add_unless_return
References: <1306889876-5327-1-git-send-email-asharma@fb.com>	 <BANLkTinEkfRH-xJRyrtajSLEkEwrau7yRA@mail.gmail.com> <1307259315.20604.2.camel@edumazet-laptop>
In-Reply-To: <1307259315.20604.2.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/11 12:35 AM, Eric Dumazet wrote:

>>> + * Returns the old value of @v + @a.
>>> + */
>>> +static inline int atomic_add_unless_return(atomic_t *v, int a, int u)
>>  [...]
>>
>> also, the semantics here appear to deviate from the other atomic
>> funcs.  the existing xxx_return funcs return the new result, not the
>> old.
>> -mike
>
> Arun comment is wrong, this function does return the new value of the
> atomic_t after our operation, not the old ;)

The comment is technically correct:

old value of @v + @a = new value of @v.

I'll try to make it less confusing :)

Mike: Thanks for the review. I'll fix up the commit log and the func 
name and post a new patch.

  -Arun

