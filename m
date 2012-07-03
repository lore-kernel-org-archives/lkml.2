Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab2GCNZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:25:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63844 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab2GCNZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:25:44 -0400
Message-ID: <4FF2F2D3.4090200@linaro.org>
Date: Tue, 03 Jul 2012 15:25:39 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
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
References: <4FDEE98D.7010802@linaro.org> <201207022149.36629.rjw@sisk.pl> <4FF21D48.50301@linaro.org> <201207031059.13758.rjw@sisk.pl> <4FF2EC1A.7020702@linaro.org> <20120703231948.33cca18e3cc3d6e497ab022d@canb.auug.org.au>
In-Reply-To: <20120703231948.33cca18e3cc3d6e497ab022d@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 03:19 PM, Stephen Rothwell wrote:
> Hi Daniel,
> 
> On Tue, 03 Jul 2012 14:56:58 +0200 Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>>
>>> So do you have a branch in the cpuidle-next.git tree that isn't going to
>>> be rebased?
>>
>> No. I am following Linus tree and adding the patches on top of it.
> 
> Please don't rebase your tree more than necessary - it just makes thing
> hard for anyone using your tree as a base for further development and
> throws away any testing you may have done.

Ok, let me sync with Len and Rafael about the best way to do that.

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

