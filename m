Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2JVIZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:25:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43619 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2JVIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:25:29 -0400
MIME-Version: 1.0
In-Reply-To: <20121022075534.GA4931@avionic-0098.mockup.avionic-design.de>
References: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
	<CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com>
	<20121022060641.GB3900@localhost.localdomain>
	<CAKohpo=LHjV2tV1R34Q_As4s2Yh071+t-bLyFBDGSZ_u5vKo7Q@mail.gmail.com>
	<20121022075534.GA4931@avionic-0098.mockup.avionic-design.de>
Date: Mon, 22 Oct 2012 13:55:29 +0530
Message-ID: <CAKohpokDscKxhpKjdkbU+Q95VQPF-bDviyL3LAcbgeaQWk6ERw@mail.gmail.com>
Subject: Re: [PATCH V3] PWM: Add SPEAr PWM chip driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2012 13:25, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> We could probably do that in the core. I've had some discussions about
> this with Lars-Peter (Cc'ed) who also had doubts about how this is
> currently handled.
>
> What you're proposing is different, however. If we put that code in the
> core it will mean that once the module is unloaded, all PWM devices will
> be disabled. There is currently code in the core that prevents the chip
> from being removed if one or more PWM devices are busy. But as explained
> above, with the current core code this return value isn't useful at all.

This is what many drivers in pwm framework are doing currently too..
They disable
pwm and its clock and then do chip remove.

Sorry, i didn't get the conclusion completely :(
Should we keep code suggested by me in core or spear's driver?

--
viresh
