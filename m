Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1COOd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:33:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60777 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab1COOd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:33:26 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinU7g4qLVwLwFXyt_j6tmGq-5MC9a-wy_cGvC9Y@mail.gmail.com>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
 <1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
 <AANLkTi=Yv1fHVTC-BVBJ3WRPGOmOC3fCJ13G-dCegLYo@mail.gmail.com>
 <AANLkTi=qN=i3VW=VXPQ1PAFTXFgo3O_jqykTkc7A7JLF@mail.gmail.com>
 <AANLkTi=o8CbHjJHZETokQP8bz5SyLnyLLadM4UMyZc=6@mail.gmail.com> <AANLkTinU7g4qLVwLwFXyt_j6tmGq-5MC9a-wy_cGvC9Y@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 15 Mar 2011 08:33:06 -0600
X-Google-Sender-Auth: VwOBXyk6kJ7Iy8ijP7MBcmVQfu8
Message-ID: <AANLkTikwjRgCB8nnkTeZq+AbjQ+ugQz_WMshEFMSFo=_@mail.gmail.com>
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bibek BASU <bibek.basu@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 3:10 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Mar 14, 2011 at 5:46 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Mon, Mar 14, 2011 at 10:37 AM, Linus Walleij
>> <linus.walleij@linaro.org> wrote:
>>> On Mon, Mar 7, 2011 at 3:32 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>>
>>>> Grant can you have a look at this GPIO driver from a while back?
>>>>
>>>> Bibek can probably repost it if you don't have it in your archive...
>>>>
>>>> It'd be great if you could take this through the GPIO tree if/when
>>>> it's OK with you.
>>>
>>> Ping on this, the ux500-core tree is now sent to Russell for merging
>>> into 2.6.39 so if possible I'd like to have this merged into the
>>> GPIO tree (unless there are still review comments...) note
>>> Samuel's ACK if you pick it.
>>
>> I'm fine with it, but it looks like it needs to go via Russell's tree
>> if it depends on the rest of the ux500-core patches.
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
> I won't get any more platform data in to Russells tree for this merge
> Window, so it'd be great if you could take this patch (the bulk of the driver)
> into the GPIO tree.
>
> I will submit platform data for the next merge Window, or maybe to
> Torvalds once he has Russell and yours merged. if I feel ambitious...

Ping me *after* Russell's tree gets merged and I'll pick it up.  I
don't want to mess about with apply-order breakage.

g.
