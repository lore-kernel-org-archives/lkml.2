Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1LAO3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:29:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50593 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1LAO3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:29:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAGTjWtC2Toqd8H1Z9pHky7nJguOyedUoypU5zrWvi8X+v4cD3Q@mail.gmail.com>
References: <20111130233733.GA11577@maxin>
	<CAGTjWtCy_syX18y23mUD7HZJe3fdjUDCY7YDMwKesFFjd4VwZQ@mail.gmail.com>
	<20111201032113.GA6917@suse.de>
	<CAGTjWtC2Toqd8H1Z9pHky7nJguOyedUoypU5zrWvi8X+v4cD3Q@mail.gmail.com>
Date: Thu, 1 Dec 2011 16:29:06 +0200
Message-ID: <CAMhs6YzEvAQnq=HPWfWWcsQ1b=Jgc1u1R=u1y6US_1anVntAgQ@mail.gmail.com>
Subject: Re: [PATCH] firmware: google: fix gsmi.c build warning
From: Maxin B John <maxin.john@gmail.com>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, dlaurie@google.com, adurbin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 8:07 AM, Mike Waychison <mikew@google.com> wrote:
> On Wed, Nov 30, 2011 at 7:21 PM, Greg KH <gregkh@suse.de> wrote:
>> On Wed, Nov 30, 2011 at 03:56:25PM -0800, Mike Waychison wrote:
>>> On Wed, Nov 30, 2011 at 3:37 PM, Maxin B. John <maxin.john@gmail.com> wrote:
>>> > Use min_t() macro instead of min() to fix a build warning:
>>> >
>>>
>>> Looks good.  Greg, could you please pull this into your drivers tree?
>>
>> Yes I will if you ack it :)
>
> Acked-By: Mike Waychison <mikew@google.com>

Thanks !

>>
>> greg k-h

Warm Regards,
Maxin B. John
