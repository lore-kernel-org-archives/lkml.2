Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2JVS7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:59:42 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45271 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab2JVS7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:59:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-Lm6T0u08ZV+kw5+X_JUAoXksoPcxBo9FKAqQgdp6RRLA@mail.gmail.com>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
 <CACRpkdapB5x2MEKKvDU2MBKPVKXwYCx+HDYFUcY0vskeVOxPTg@mail.gmail.com> <CAK5ve-Lm6T0u08ZV+kw5+X_JUAoXksoPcxBo9FKAqQgdp6RRLA@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 22 Oct 2012 11:59:19 -0700
Message-ID: <CAK5ve-KDqi0HwE8upAmRmZUPcs=wgid_9QkQNksSGFUkWdEi+Q@mail.gmail.com>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>
Cc: akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya,

Can I get some Acked or Tested-by from Rafael or Miles before I put it
in my linux-leds tree?

Thanks,
-Bryan

On Thu, Oct 18, 2012 at 12:34 PM, Bryan Wu <cooloney@gmail.com> wrote:
> On Thu, Oct 18, 2012 at 11:35 AM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
>> On Thu, Oct 18, 2012 at 8:18 PM, Bryan Wu <cooloney@gmail.com> wrote:
>>
>>> Mutex lock is not safe in atomic context like the bug reported by
>>> Miles Lane:
>> (...)
>>> This patch replace mutex lock with spin lock which is safe for this case.
>>>
>>> Reported-by: Miles Lane <miles.lane@gmail.com>
>>> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
>>> Cc: Linus Walleij <linus.walleij@linaro.org>
>>> Signed-off-by: Bryan Wu <cooloney@gmail.com>
>>
>> Looks correct to me:
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>
> Thanks, Linus.
>
> Miles, could you please help to try this patch on your testing system?
> I really appreciate it.
>
> -Bryan
