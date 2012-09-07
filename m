Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2IGVeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:34:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63971 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2IGVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFrTTcNfQ2d24oSWEsvw1OF6t91nv6Y_JQfiWx8Un7_u-A@mail.gmail.com>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
	<1346415691-13371-2-git-send-email-ulf.hansson@stericsson.com>
	<20120831192906.31162.97714@nucleus>
	<CAPDyKFrS7tKu5AcjL7+R8V5Nvo0O+BVwc8HtGFqQGSf12wMioQ@mail.gmail.com>
	<20120907001927.20289.41627@nucleus>
	<CAJOA=zM-u5ss8ZYWFHg43V7r5B6TXhRN70=JUccNjrppx4fDyg@mail.gmail.com>
	<CACRpkdYVkQTH=205ggcauH7RbNPvpPEP+o12AK30wcpRWVnx4A@mail.gmail.com>
	<CAPDyKFrTTcNfQ2d24oSWEsvw1OF6t91nv6Y_JQfiWx8Un7_u-A@mail.gmail.com>
Date: Fri, 7 Sep 2012 23:34:01 +0200
Message-ID: <CACRpkdbZSk7tTjG_-6NLoczbAGSCs4eqygFY7UmAkz+oQYOjVA@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: Provide option for clk_get_rate to issue hw for
 new rate
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Turquette, Mike" <mturquette@ti.com>,
        Ulf Hansson <ulf.hansson@stericsson.com>,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 2:29 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 7 September 2012 10:21, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Fri, Sep 7, 2012 at 3:00 AM, Turquette, Mike <mturquette@ti.com> wrote:
>>> On Thu, Sep 6, 2012 at 5:19 PM, Mike Turquette <mturquette@ti.com> wrote:
>>>> I'll take this series into clk-next.
>>>
>>> Oops, I forgot to ask about patch #3.  Which tree do you want that to
>>> go through?
>>
>> Just take it all through your tree if there are no major conflicts.
>> Acked-by etc.
>
> Agree, it makes it simpler to go through Mike's clock tree. At least
> let's try it out.
> I will likely have similar patch series with cross dependencies later
> on, so this can be a good first test and hopefully it works.

That will probably hit the next merge window anyway - these
patches will go into v3.7 as it looks, then you can finalize the
next series for v3.8.

> Although, don't we need an ack by Samuel Ortiz for the patch on mfd?
> "mfd: dbx500: Provide a more accurate smp_twd clock"

Confused, isn't that patch part of the latter series, and not
part of what Mike merged?

> Or, is it enough with Linus ack since he is the maintainer of that
> specific mfd file I have patched?

That's up to Mike, but I hardly think Sam is going to get very
angry about this if we merge it.

Yours,
Linus Walleij
