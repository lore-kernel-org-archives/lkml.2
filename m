Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab1CNQqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:46:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58679 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab1CNQqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:46:46 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=qN=i3VW=VXPQ1PAFTXFgo3O_jqykTkc7A7JLF@mail.gmail.com>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
 <1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
 <AANLkTi=Yv1fHVTC-BVBJ3WRPGOmOC3fCJ13G-dCegLYo@mail.gmail.com> <AANLkTi=qN=i3VW=VXPQ1PAFTXFgo3O_jqykTkc7A7JLF@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 Mar 2011 10:46:25 -0600
X-Google-Sender-Auth: 60_9ZhPLfdWNj3UApJa3tcZXSP8
Message-ID: <AANLkTi=o8CbHjJHZETokQP8bz5SyLnyLLadM4UMyZc=6@mail.gmail.com>
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bibek BASU <bibek.basu@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 10:37 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Mon, Mar 7, 2011 at 3:32 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
>> Grant can you have a look at this GPIO driver from a while back?
>>
>> Bibek can probably repost it if you don't have it in your archive...
>>
>> It'd be great if you could take this through the GPIO tree if/when
>> it's OK with you.
>
> Ping on this, the ux500-core tree is now sent to Russell for merging
> into 2.6.39 so if possible I'd like to have this merged into the
> GPIO tree (unless there are still review comments...) note
> Samuel's ACK if you pick it.

I'm fine with it, but it looks like it needs to go via Russell's tree
if it depends on the rest of the ux500-core patches.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.
