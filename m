Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2LOHWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 02:22:13 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63155 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2LOHWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 02:22:11 -0500
MIME-Version: 1.0
In-Reply-To: <50CBCF83.30700@us.ibm.com>
References: <20121119182616.GA4557@www.outflux.net>
	<CAGXu5jKdOsBUwZRwOQDeRdFjo-K=uEQdJNMgy4N1dyzrUGcAHw@mail.gmail.com>
	<50CBCF83.30700@us.ibm.com>
Date: Fri, 14 Dec 2012 23:22:10 -0800
X-Google-Sender-Auth: JYqk8Q7TzctFpmZn67G6HvTGybA
Message-ID: <CAGXu5jLtfoxPC-4d-StwWuuowMOFjzVsnzPn7wRhdaTAbiS43Q@mail.gmail.com>
Subject: Re: [PATCH] time: create __getnstimeofday for WARNless calls
From: Kees Cook <keescook@chromium.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 5:16 PM, John Stultz <johnstul@us.ibm.com> wrote:
> On 12/13/2012 10:17 AM, Kees Cook wrote:
>>
>> John, any feedback on this?
>>
> Sorry, yea, I've been meaning to get back to this.
>
> I'm still on the fence about just making getnstimeofday() safe for when
> timekeeping is suspended, but at the same time, your issue needs fixing.
> Also bailing out at the end still seems off to me. Even if someone is using
> the values despite the WARN_ON, they really are getting junk values, and for
> all the time that WARN_ON has been there, you're the first to report running
> into it.
>
> Even so, I think I'm ok with this patch for now, but I suspect we may want
> to rework it later.
>
> Looking at my inbox, I actually can't find a copy of this specific patch. Do
> you mind bouncing it to me, so I have something I can apply?
>
> Should this also get marked for -stable?

Nah, I don't think it's worth it.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
