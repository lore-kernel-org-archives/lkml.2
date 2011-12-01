Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1LAO6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:58:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48614 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1LAO6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:58:41 -0500
MIME-Version: 1.0
In-Reply-To: <4ED75F53.30709@redhat.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
Date: Thu, 1 Dec 2011 15:58:41 +0100
Message-ID: <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

let me ask you some details of your interesting idea (how to
achieve the same functionality as with vtunerc driver):

[...]

> The driver, as proposed, is not really a driver, as it doesn't support any
> hardware. The kernel driver would be used to just copy data from one
> userspace

Please stop learning me what can be called driver and what nope.
Your definition is nonsense and I don't want to follow you on it.

> application to the other. The same result could be obtained in userspace,
> by implementing a library. Such library could even use LD_PRELOAD to support
> binary only applications, like what libv4l does. In terms of performance,
> such library would probably perform better than a kernel driver, as there's
> no need to do context switching for each call, and no need to talk with a
> device (where kernel outperforms userspace). Also, depending on how such
> library
> is implemented, double buffering might be avoided.
>
> So, from architectural POV, this code should be written as an userspace
> library.
> BTW, alsa also came with the same results, years ago, as audio remote
> streaming is supported via userspace tools, like pulseaudio.

Can you show me, how then can be reused most important part
of dvb-core subsystem like tuning and demuxing? Or do you want me
to invent wheels and to recode everything in the library? Of course
I can be wrong, I'm no big kernel hacker. So please show me the
way for it. BTW, even if you can find the way, then data copying
from userspace to the kernel and back is also necessery. I really
don't see any advantage of you solution.

Honza
