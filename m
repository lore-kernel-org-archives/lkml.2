Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1LGLzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:55:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57586 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1LGLzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:55:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAMhs6YzEvAQnq=HPWfWWcsQ1b=Jgc1u1R=u1y6US_1anVntAgQ@mail.gmail.com>
References: <20111130233733.GA11577@maxin>
	<CAGTjWtCy_syX18y23mUD7HZJe3fdjUDCY7YDMwKesFFjd4VwZQ@mail.gmail.com>
	<20111201032113.GA6917@suse.de>
	<CAGTjWtC2Toqd8H1Z9pHky7nJguOyedUoypU5zrWvi8X+v4cD3Q@mail.gmail.com>
	<CAMhs6YzEvAQnq=HPWfWWcsQ1b=Jgc1u1R=u1y6US_1anVntAgQ@mail.gmail.com>
Date: Wed, 7 Dec 2011 13:55:30 +0200
Message-ID: <CAMhs6YwHyAG8tU7+igZutKdQMHg+Qa4K73rcjY=9Fu0mDg_BWA@mail.gmail.com>
Subject: Re: [PATCH] firmware: google: fix gsmi.c build warning
From: Maxin B John <maxin.john@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, dlaurie@google.com, adurbin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 4:29 PM, Maxin B John <maxin.john@gmail.com> wrote:
> On Thu, Dec 1, 2011 at 8:07 AM, Mike Waychison <mikew@google.com> wrote:
>> On Wed, Nov 30, 2011 at 7:21 PM, Greg KH <gregkh@suse.de> wrote:
>>> On Wed, Nov 30, 2011 at 03:56:25PM -0800, Mike Waychison wrote:
>>>> On Wed, Nov 30, 2011 at 3:37 PM, Maxin B. John <maxin.john@gmail.com> wrote:
>>>> > Use min_t() macro instead of min() to fix a build warning:
>>>> >
>>>>
>>>> Looks good.  Greg, could you please pull this into your drivers tree?
>>>
>>> Yes I will if you ack it :)
>>
>> Acked-By: Mike Waychison <mikew@google.com>

Greg,  Ping ..
