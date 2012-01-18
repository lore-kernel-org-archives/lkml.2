Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2ARRZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:25:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab2ARRZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:25:42 -0500
Message-ID: <4F17007A.9090102@zytor.com>
Date: Wed, 18 Jan 2012 09:25:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        tglx@linutronix.de, luca@luca-barbieri.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ix86: adjust asm constraints in atomic64 wrappers
References: <4F16E3AC020000780006D796@nat28.tlf.novell.com> <4F16F732.2050907@zytor.com> <4F1707F5020000780006D868@nat28.tlf.novell.com>
In-Reply-To: <4F1707F5020000780006D868@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 08:57 AM, Jan Beulich wrote:
>>
>> For functions with nonstandard calling conventions it is normal to
>> declare them as void foo(void);
>
> For the above, I'd like to keep atomic64_t in the signature. Would
> void foo(atomic64_t, ...) be acceptable?
>

Sounds reasonable to me.  It doesn't matter much.

 >
 >> It may be a good idea to prefix these symbols with __ though.
 >
 > But not in this patch. (Can't resist to add that if you think it
 > should be this way, why did you not make it a condition for accepting
 > theoriginal patch, which you committed?)
 >

I didn't say "condition", I said "it may be a good idea".  Agreed in not 
in this patch.

The other bit in all of that is that, guess what, some people with solid 
track records, like yourself, I generally trust to do things mostly 
right, and so I don't actually scrutinize quite as in depth as I would 
patches from other people.  Every now and then it means I stumble upon 
something later after I have thought about it more.  This is by and 
large fine.

	-hpa
