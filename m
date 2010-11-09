Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0KIADF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 19:03:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab0KIADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 19:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rMlDHu7qTGAaTrhx91RG0YWZQi4hHq5WJLF4FuNjgj2bTGcdHEAc/Rv+ihhBsbRVMC
         sIswhVG04J2owhpZHUjmOpR64Rf/JE/MpzfSI+bL9jh1d2j1rahJiv2+JfWQzCH9Pb2I
         jXNz5pMZZTRG3gyTUOSHnp0SydW756y4l2H90=
MIME-Version: 1.0
In-Reply-To: <20101108235407.GB18385@linux-sh.org>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<1289147348-31969-6-git-send-email-alchark@gmail.com>
	<20101108041721.GA11605@linux-sh.org>
	<20101108141407.GA25739@alchark-u3s.lan>
	<20101108204315.GA12050@linux-sh.org>
	<AANLkTikXffMT9ZiUpm2QAoW+KPJN3MBf55Dgruj1EJN0@mail.gmail.com>
	<20101108213008.GB17708@linux-sh.org>
	<20101108234239.GA20819@alchark-u3s.lan>
	<20101108235407.GB18385@linux-sh.org>
Date: Tue, 9 Nov 2010 03:03:01 +0300
Message-ID: <AANLkTim047K-RjLLcz3124Wm+-he8s5AirAsD6R_kitN@mail.gmail.com>
Subject: Re: [PATCH 6/6 v4] ARM: Add support for the display controllers in
 VT8500 and WM8505
From: Alexey Charkov <alchark@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/8 Paul Mundt <lethal@linux-sh.org>:
> On Tue, Nov 09, 2010 at 02:42:39AM +0300, Alexey Charkov wrote:
>> From 95942cc0cd0909d700c236ba63d3488ec9fccf1a Mon Sep 17 00:00:00 2001
>> From: Alexey Charkov <alchark@gmail.com>
>> Date: Tue, 9 Nov 2010 02:25:40 +0300
>> Subject: [PATCH 3/3] ARM: Add support for the display controllers in VT8500 and WM8505
>>
>> This adds drivers for the LCD controller found in VIA VT8500 SoC,
>> GOVR display controller found in WonderMedia WM8505 SoC and for the
>> Graphics Engine present in both of them that provides hardware
>> accelerated raster operations (used for copyarea and fillrect).
>>
>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>> ---
>>
>> This incorporates fixes to the issues last mentioned by Paul.
>>
>> I just dropped <asm/irq.h>, as that seems to be not used at all currently
>> (must have been some old cut-and-paste as well). As for the Graphics
>> Engine, I decided not to disable it for now at device exit time, at least
>> until we reach a conclusion on how or whether to implement support for its
>> alpha-mixing capabilities. Unlike with display drivers, this should have no
>> user-visible consequences. This can be changed later, when time comes for
>> device clocks and power management support.
>>
> Looks good to me!
>
> Reviewed-by: Paul Mundt <lethal@linux-sh.org>
>

Thanks, Paul!

Is there anybody I should address specifically to get this merged?

Best regards,
Alexey
