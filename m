Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab2EIOf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:35:58 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:32983 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab2EIOf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:35:56 -0400
MIME-Version: 1.0
X-Originating-IP: [109.64.13.136]
In-Reply-To: <CAAZUjxBp7f_Tt3bXSOcac6RmeT23npELYO52P_2LdMN-MdH=7g@mail.gmail.com>
References: <CAAZUjxBp7f_Tt3bXSOcac6RmeT23npELYO52P_2LdMN-MdH=7g@mail.gmail.com>
Date: Wed, 9 May 2012 17:35:55 +0300
Message-ID: <CAOtvUMfZeZ0OSXDjeo0xFF-hdQwzLfrdCucJfP_hM_1ZJ8oXBA@mail.gmail.com>
Subject: Re: Work queues and cpu isolation
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: wilson self <wself00@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wilson,

On Wed, May 9, 2012 at 12:03 AM, wilson self <wself00@gmail.com> wrote:
> I have done some reading on the subject of work queues and CPU
> isolation, and specifically I've read a number of posts from Max K.
> dating back to 2008 on the subject of CPU isolation.  However, I have
> not seen much in the way of discussion on the subject in more recent
> times, specifically in the 3.x kernels; where it appears there are
> some significant differences in the structure of workqueue in general.
>
> Is there anyone currently doing work on additional isolation of CPUs
> from work queues? I have some requirement to further isolate cores on
> a machine from these queues and am hoping someone here could point me
> in the right direction.
>

Yes, I am and so do many other people on the general topic of CPU isolation.

Start here: https://github.com/gby/linux/wiki

Continue here: https://lkml.org/lkml/2012/5/3/268

And if you are interested in CPU isolation in general, then these will
interest you as well:

http://lwn.net/Articles/495422/

http://lkml.indiana.edu/hypermail/linux/kernel/1202.1/00590.html (this
last patch set has gone into 3.4-rc1 already)

I'd be very glad to cooperate :-)

Gilad

> Thanks.
> wilson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
