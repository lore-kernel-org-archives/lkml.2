Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2AXXwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:52:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42427 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2AXXwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:52:23 -0500
MIME-Version: 1.0
In-Reply-To: <1327446024.11738.4.camel@work-vm>
References: <1327363550-19952-1-git-send-email-john.stultz@linaro.org>
 <1327363550-19952-3-git-send-email-john.stultz@linaro.org>
 <CAJfuBxwBfB7V_gikW44rTNAYvxKZwORwzdRrvyZM19feFwcwDQ@mail.gmail.com> <1327446024.11738.4.camel@work-vm>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 24 Jan 2012 16:51:51 -0700
Message-ID: <CAJfuBxw6M7LB_-GpmTxem-aqWz35CDDaaBv+8oqQ_R_SR7r_tQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] clocksource: scx200_hrt: Convert scx200 to use clocksource_register_hz
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 4:00 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Tue, 2012-01-24 at 11:53 -0700, Jim Cromie wrote:
>> On Mon, Jan 23, 2012 at 5:05 PM, John Stultz <john.stultz@linaro.org> wrote:
>> > Converts the scx200 clocksource to using clocksource_register_hz.
>> >
>> > This wasn't a straight conversion, so would like some extra review
>> > by the maintainers.
>> >
>>
>> hi John,
>>
>> very nice.  Tested with mhz27 too.
>>
>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>
> I assume you mean Acked-by:/Tested-by: ?  Or are you going to push this
> upstream?
>

huh - I thought SOB was appropriate since Im maintainer of scx200_hrt.
That said, youre maintainer of TIMEKEEPING, and author of the patch,
so I consider you upstream.  Lets make it instead:

Acked-by: Jim Cromie <jim.cromie@gmail.com>
Tested-by: Jim Cromie <jim.cromie@gmail.com>

Can you also push that trivial s/then/than/ patch I attached,
and/or should I resend it inline, with git-send-email ?

> thanks
> -john
>
>
