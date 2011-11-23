Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1KWMyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:54:00 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54208 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1KWMx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:53:59 -0500
MIME-Version: 1.0
In-Reply-To: <1321993924.6445.74.camel@work-vm>
References: <1321956194-8382-1-git-send-email-linus.walleij@stericsson.com>
	<1321993924.6445.74.camel@work-vm>
Date: Wed, 23 Nov 2011 13:53:58 +0100
Message-ID: <CACRpkdYgVqEzf=b6hUHcFvWH+qTwANddsg4TZjxEbW_KXUQqmg@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH] rtc: disable the alarm in the hardware
From: Linus Walleij <linus.walleij@linaro.org>
To: rtc-linux@googlegroups.com
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 9:32 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Tue, 2011-11-22 at 11:03 +0100, Linus Walleij wrote:
>> From: Rabin Vincent <rabin.vincent@stericsson.com>
>>(...)
>> Fix this by disabling the alarm when there are no timers to run.
>
> Hey Linus,
>        Thanks for sending this along! It looks like a good fix to me! I'm a
> little amazed this hasn't cropped up sooner.  I'll do some further
> testing and then queue it for upstream.

Thanks, but thank Rabin who did all the root cause analysis,
I'm just his secretary... :-)

Linus
