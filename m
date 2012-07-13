Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2GMFHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:07:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33170 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2GMFHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:07:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-+0RHVfjAQjFJmJ=0e3K0JG3zq6uM3oMr-_0JJY0EM-pg@mail.gmail.com>
References: <1342000232-10105-1-git-send-email-devendra.aaru@gmail.com>
	<CAK5ve-+0RHVfjAQjFJmJ=0e3K0JG3zq6uM3oMr-_0JJY0EM-pg@mail.gmail.com>
Date: Fri, 13 Jul 2012 10:52:09 +0545
Message-ID: <CAHdPZaPPVABiT03=krcqohEXuHbWHgkZkMA5uYjwf=fhaOYN4w@mail.gmail.com>
Subject: Re: [PATCH] leds/leds-s3c24xx: use devm_gpio_request
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 9:12 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
> On Wed, Jul 11, 2012 at 5:50 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
>> Bryan,
>>
>>         This patch is not even compile tested, since my machine crashed, and
>> didn't have the ARM toolchain, sorry ..
>>
>
> Thanks, I built it successfully. It looks fine to me. I will apply
> this to my for-next branch.
>
> -Bryan
>
Thank Bryan, I  will set up my cross-toolchain soon.. sorry for not
compiling it.
