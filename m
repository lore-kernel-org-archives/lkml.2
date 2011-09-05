Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1IEUuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:50:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59021 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1IEUuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <1315252298.1243.21.camel@ted>
References: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com> <1315252298.1243.21.camel@ted>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 6 Sep 2011 04:49:57 +0800
X-Google-Sender-Auth: V4puEBJVc6SWUEOSUc2H7rdWP00
Message-ID: <CAK5ve-KAN9xX=+hCaWdn8m838dU4=0qmaTR4-u2xknEJB1oXuA@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds-class: change back LEDS_CLASS to tristate
 instead of bool
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 3:51 AM, Richard Purdie
<richard.purdie@linuxfoundation.org> wrote:
> On Tue, 2011-09-06 at 03:09 +0800, Bryan Wu wrote:
>> LEDS_CLASS is required by leds and trigger drivers, but we can build it
>> as module. So change this option back as tristate and treak the help
>> message as well.
>>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>
> Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>
>

Thanks a lot, Richard.

I also suggest we set LEDS_TRIGGERS as tristate, because it should be
a module when CONFIG_LEDS_CLASS=m.

-Bryan
