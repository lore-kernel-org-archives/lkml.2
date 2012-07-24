Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2GXTTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:19:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab2GXTTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:19:32 -0400
Message-ID: <500EF541.50009@redhat.com>
Date: Tue, 24 Jul 2012 13:19:29 -0600
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com> <20120724182409.GB10534@zod.bos.redhat.com>
In-Reply-To: <20120724182409.GB10534@zod.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/12 12:24, Josh Boyer wrote:
> On Tue, Jul 24, 2012 at 11:20:11AM -0700, Linus Torvalds wrote:
>> On Tue, Jul 24, 2012 at 11:12 AM, Josh Boyer <jwboyer@redhat.com> wrote:
>>>
>>> +#define __NFDBITS      (8 * (int) sizeof(long int))
>>
>> I don't know if the type change is needed, but who the hell uses "long int"?
>
> Not strictly, no.  I believe in my brief tests, just the int cast was
> sufficient.  I can respin if you'd like.  I probably need to anyway to
> CC stable on this.
All that's strictly necessary is that cast to (int).  That avoids the 
problem.

Jeff
