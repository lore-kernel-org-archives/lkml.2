Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2KHMyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:54:41 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45380 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2KHMyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:54:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh2x=nT8_95uu9tfEnOHy9Gkm6gEEAVAKKwPAqbLJz3bwFDNw@mail.gmail.com>
References: <1352215014-30305-1-git-send-email-linus.walleij@stericsson.com>
	<CAOh2x=nT8_95uu9tfEnOHy9Gkm6gEEAVAKKwPAqbLJz3bwFDNw@mail.gmail.com>
Date: Thu, 8 Nov 2012 13:54:39 +0100
Message-ID: <CACRpkdbZ8VLixWwKOEUMNe+6BJOwCs0Me3=7_oR8xvT9MZx1Aw@mail.gmail.com>
Subject: Re: [PATCH 3/5] gpiolib: remove duplicate pin range code
From: Linus Walleij <linus.walleij@linaro.org>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 6:14 AM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Tue, Nov 6, 2012 at 8:46 PM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> Commit 69e1601bca88809dc118abd1becb02c15a02ec71
>> "gpiolib: provide provision to register pin ranges"
>>
>> Introduced both of_gpiochip_remove_pin_range() and
>> gpiochip_remove_pin_ranges(). But the contents are exactly
>> the same so remove the OF one and rely on the range deletion
>> in the core.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> I can't believe that i did this :(

Don't worry, it's impossible to get these things right. I am
trying to fix it properly here and just introduce new bugs
for every fix I try to make.

Maybe I'll soon have something that actually doesn't
break x86...

Yours,
Linus Walleij
