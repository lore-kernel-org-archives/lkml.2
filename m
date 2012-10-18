Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab2JRTed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:34:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42976 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab2JRTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdapB5x2MEKKvDU2MBKPVKXwYCx+HDYFUcY0vskeVOxPTg@mail.gmail.com>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
 <CACRpkdapB5x2MEKKvDU2MBKPVKXwYCx+HDYFUcY0vskeVOxPTg@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 18 Oct 2012 12:34:10 -0700
Message-ID: <CAK5ve-Lm6T0u08ZV+kw5+X_JUAoXksoPcxBo9FKAqQgdp6RRLA@mail.gmail.com>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
        akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:35 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Thu, Oct 18, 2012 at 8:18 PM, Bryan Wu <cooloney@gmail.com> wrote:
>
>> Mutex lock is not safe in atomic context like the bug reported by
>> Miles Lane:
> (...)
>> This patch replace mutex lock with spin lock which is safe for this case.
>>
>> Reported-by: Miles Lane <miles.lane@gmail.com>
>> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Bryan Wu <cooloney@gmail.com>
>
> Looks correct to me:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>

Thanks, Linus.

Miles, could you please help to try this patch on your testing system?
I really appreciate it.

-Bryan
