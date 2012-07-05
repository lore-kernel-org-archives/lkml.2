Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab2GENdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:33:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61732 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2GENdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:33:20 -0400
Message-ID: <4FF5979C.6030802@linaro.org>
Date: Thu, 05 Jul 2012 15:33:16 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>, linux-acpi@vger.kernel.org,
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
References: <4FDEE98D.7010802@linaro.org> <20120703231948.33cca18e3cc3d6e497ab022d@canb.auug.org.au> <4FF2F2D3.4090200@linaro.org> <201207031854.51163.rjw@sisk.pl>
In-Reply-To: <201207031854.51163.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 06:54 PM, Rafael J. Wysocki wrote:
> On Tuesday, July 03, 2012, Daniel Lezcano wrote:
>> On 07/03/2012 03:19 PM, Stephen Rothwell wrote:
>>> Hi Daniel,
>>>
>>> On Tue, 03 Jul 2012 14:56:58 +0200 Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>>>>
>>>>> So do you have a branch in the cpuidle-next.git tree that isn't going to
>>>>> be rebased?
>>>>
>>>> No. I am following Linus tree and adding the patches on top of it.
>>>
>>> Please don't rebase your tree more than necessary - it just makes thing
>>> hard for anyone using your tree as a base for further development and
>>> throws away any testing you may have done.
>>
>> Ok, let me sync with Len and Rafael about the best way to do that.
> 
> Please create a branch in your tree for me to pull from and let me know
> which one it is.  Please note that this branch must not be rebased after I've
> pulled from it and it's going to be included into my linux-next branch
> automatically.

Ok that sounds good.

Let me put in place the branch and rework my patches because they
conflict with the 'disable' flag moved to the per cpu structure.
In the meantime, I will send you the other patches which do not conflict.


> I'll include it into my v3.6 push, because I have a couple of cpuidle patches
> queued up already.  We'll need to discuss the future of it after 3.6, though.

Ok, cool.

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

