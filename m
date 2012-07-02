Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab2GBWOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:14:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49653 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab2GBWOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:14:36 -0400
Message-ID: <4FF21D48.50301@linaro.org>
Date: Tue, 03 Jul 2012 00:14:32 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>, "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: linux-next : cpuidle - could you add my tree please
References: <4FDEE98D.7010802@linaro.org> <CACRpkdYaLweX-4YkWotuFFWoqEjOLKoNCsurCxxWNfq7QznPnw@mail.gmail.com> <4FF19947.3040608@linaro.org> <201207022149.36629.rjw@sisk.pl>
In-Reply-To: <201207022149.36629.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 09:49 PM, Rafael J. Wysocki wrote:
> On Monday, July 02, 2012, Daniel Lezcano wrote:
>>
>> On 07/02/2012 11:09 AM, Linus Walleij wrote:
>>> On Mon, Jun 25, 2012 at 3:27 PM, Daniel Lezcano
>>> <daniel.lezcano@linaro.org> wrote:
>>>
>>>> we discussed last week to put in place a tree grouping the cpuidle
>>>> modifications [1]. Is it possible to add the tree ?
>>>>
>>>> git://git.linaro.org/people/dlezcano/cpuidle-next.git #cpuidle-next
>>>
>>> Thanks for doing this.
>>>
>>> Since MAINTAINERS is lacking a listed maintainer for cpuidle,
>>> are you also going to add yourself as maintainer and list this
>>> tree in that file, or is this a one-time exercise?
>>
>> I will be glad to do that if Len and Rafael agree on that.
> 
> Len Brown has been a cpuidle maintainer for some time now.  Moreover,
> he's been taking patches, but Linus refused to pull his entire tree during the
> last merge window (as you probably know).  I honestly don't think this is
> a good enough reason for replacing him as a cpuidle maintainer by force.
> 
> So, you should ask Len whether or not he's willing to pass the cpuidle
> maintenance to someone else.

No, no. You are misunderstanding what I am proposing. I don't want to
replace Len I just want to act as a "proxy". I understand a maintainer
can be busy and could not have enough time to take care of the subsystem
is maintaining during a period because he's too busy for that.
Trust me, I fully understand that :)

As there are a lot of modifications of cpuidle, I am proposing to take
the patches when they are acked-by, to create a consolidated tree,
providing a better integration for cpuidle, a wider testing, preventing
conflicts and facilitating Len's work if he agrees to pull from this tree.

If that makes sense to add myself to the MAINTAINER file as a
co-maintainer (understand: send to me also the patches, so I can take
care of them if Len does not respond), I am ok with that.

It is just about helping :)

> I know that Len hasn't been responsive recently, but I also know that he
> _does_ respond to inquiries sent directly to him.

Do you mean to its intel address ?

Thanks
  -- Daniel

> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

