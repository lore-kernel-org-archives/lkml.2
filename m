Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0L2XKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:10:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35505 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab0L2XJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:09:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gg4TS2oQShcAOvsrJXyfhRqnD02rYzdTHa5ww58bbwqJLOw0HjykHro5/cKaLW2g7n
         VDC2x2Yk6h4JiE0r4ZFlzEJBg9FYLhDy7/m167d+nwHBRXmax4LH2dT+jSv6mF5IVIsR
         bbruEzc8ZE3ed8rdMTStlauGVshFq2ktPe+0c=
MIME-Version: 1.0
In-Reply-To: <20101229135315.5fe5c4e5@jbarnes-desktop>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
	<20101229131852.0792aac0@jbarnes-desktop>
	<20101229135315.5fe5c4e5@jbarnes-desktop>
Date: Thu, 30 Dec 2010 00:09:56 +0100
Message-ID: <AANLkTikk3Z_p+-uRB4iF8CUuMAyuKVtPbuht=hQOm2uH@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
From: Alex Riesen <raa.lkml@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 22:53, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> > Doesn't change anything here. Display stays blank.
>>
>> Sounds like your problem is separate from SSC then, more likely related
>> to panel power or backlight control.  Have you tried bisecting for the
>> problem between 2.6.35 and 2.6.36?
>
> Nevermind, I just checked out the bug, looks like it is panel power
> related.  Can you try this patch?

Tried. Does not work.

> If it doesn't work, can you send me the output of intel_reg_dumper from
> before you turn off the display and after you try to turn it back on?

See the links below (sorry, they files are a bit large):

Before running "xset dpms force standby":

  http://vin-soft.org/~raa/public/test/intel_gpu_dump-before

After running "sleep 3"

  http://vin-soft.org/~raa/public/test/intel_gpu_dump-after-suspend

After running "xset dpms force on"

  http://vin-soft.org/~raa/public/test/intel_gpu_dump-after-xset-on

After closing and opening the lid (displays backlight is back)

  http://vin-soft.org/~raa/public/test/intel_gpu_dump-after-lid
