Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab2J3KFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:05:11 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:33714 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab2J3KFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:05:07 -0400
Message-ID: <508FA649.6090901@linaro.org>
Date: Tue, 30 Oct 2012 11:04:57 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] net: dsa/slave: Fix compilation warnings
References: <5afab1ebe83e4361f1fd75bbea0c559af195bf02.1351529738.git.viresh.kumar@linaro.org> <1351540778.2721.7.camel@bwh-desktop.uk.solarflarecom.com> <CAKohponL_3m2KVytiWm8ZHyB5aimk8CzGrqr5J0LMy8MFGodHg@mail.gmail.com> <CAKohponOKk5e2Sxyhjw-XvzVxF3tNp66rsnYCwvwHazAPAauKw@mail.gmail.com> <508F8779.8070300@linaro.org> <CAKohpokmfFSFsADmtOyN9JRCX8aVdNs+tDFhUQuM6sSQ+dFfUA@mail.gmail.com> <508F9724.50804@linaro.org> <CAKohpon8C5O4U+h3nr=8gaEQ1f-K9pqafw=5jPrhaGup_3re=g@mail.gmail.com> <508F9D5C.2020802@linaro.org> <CAKohpo=X0ZNSRZHFO==j43Hq0ZheQLmER9X+adsLQErAJT5f2w@mail.gmail.com>
In-Reply-To: <CAKohpo=X0ZNSRZHFO==j43Hq0ZheQLmER9X+adsLQErAJT5f2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 10:45 AM, Viresh Kumar wrote:
> On 30 October 2012 14:56, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> Well, it is the same here, no ? Except, it is up to the user to disable
>> the option.
> 
> I didn't wanted to add code like this:
> 
>>> +       select NET_DSA_TAG_DSA if (!NET_DSA_TAG_EDSA &&
>>> !NET_DSA_TAG_TRAILER)
> 
> Why should we select NET_DSA_TAG_DSA by default? What made us
> select that?

That was an example, like you I don't know the DSA at all.
I guess the maintainer will guide on that.

> For this reason, i went to the solution i offered.

Ok.

> Anyway, i just wanted to get rid of the warning. Whatever maintainer
> feels is better must be selected.

Yep.

  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

