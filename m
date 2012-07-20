Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2GTDeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:34:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52294 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2GTDeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:34:18 -0400
MIME-Version: 1.0
X-Originating-IP: [202.62.83.106]
In-Reply-To: <5006DE5F.8010700@xenotime.net>
References: <CANYdXnrf-f2e=3YKpwweSmvrYdmy7z_yOEyZ11k=La=8b3W6Pw@mail.gmail.com>
	<5006DE5F.8010700@xenotime.net>
Date: Fri, 20 Jul 2012 09:04:17 +0530
Message-ID: <CANYdXno-wGKze-i-xvbgu3Xwpa6r19gajCkrdhYhCswXUOmm-Q@mail.gmail.com>
Subject: Re: A question on printascii
From: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on ARM architecture.

On Wed, Jul 18, 2012 at 9:33 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 07/18/2012 06:03 AM, Shashidhar Hiremath wrote:
>
>> HI,
>>   I want to use printascii to debug my serial driver. How do I enable
>> it and use the feature.
>>   Currently I have enabled in menuconfig and done an extern on the
>> printascii api, this doesn't seem to work, So any hints for debugging
>> serial drivers ?
>>
>
>
> Enabled what/where in menuconfig?
>
> It looks like only a few CPU architecures or platforms
> implement "printascii".  What architecture/platform are you trying
> to use it on?
>
> --
> ~Randy



-- 
regards,
Shashidhar Hiremath
