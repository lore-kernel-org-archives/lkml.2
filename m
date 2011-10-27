Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1J0Ikc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:40:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45086 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1J0Ika convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:40:30 -0400
MIME-Version: 1.0
In-Reply-To: <1319701536.10258.74.camel@jtkirshe-mobl>
References: <CAMuHMdXxqKoPNNo9a+VK-Yzu0Qp-8zY2+OhHL6pDPF=dsnNK5Q@mail.gmail.com>
	<CAMuHMdUW5PjPU7qNOPA16CbxHJs-bL4r+aFcEGV95SDRBotXRg@mail.gmail.com>
	<1319701536.10258.74.camel@jtkirshe-mobl>
Date: Thu, 27 Oct 2011 10:40:30 +0200
X-Google-Sender-Auth: 2AxPQ6Iu-VNwX22c65bfLYzG578
Message-ID: <CAMuHMdUXg3D=+dCHZ=OwzfD2eejSaB73Y-sgv2cXoH4cnjzV5w@mail.gmail.com>
Subject: Re: drivers/net/ethernet/apple
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: jeffrey.t.kirsher@intel.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 09:45, Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
> On Wed, 2011-10-26 at 22:16 -0700, Geert Uytterhoeven wrote:
>> On Tue, Oct 25, 2011 at 22:19, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > drivers/net/ethernet/apple/mac89x0.c is a driver for the Crystal
>> Semiconductor
>> > (Now Cirrus Logic) CS89[02]0, so it belongs in
>> drivers/net/ethernet/cirrus,
>> > next to cs89x0.c.
>>
>> And on the first -next run since its inclusion:
>>
>> | drivers/net/ethernet/apple/mac89x0.c:107:20: error: cs89x0.h: No
>> such file or directory
>>
>> it needs the (shared) header file which is in
>> drivers/net/ethernet/cirrus/.
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/4835488/
>
> Ah, yeah, now it is coming back to me why I placed cs89x0.[ch] in the
> drivers/net/ethernet/apple/ because it was grouped with the "common"
> drivers.  The intent was to group drivers that use common code together.
>
> I can put together a patch to fix this if you are not able to.

I will create a patch to move mac89x0 to .../cirrus, when I get to compiling a
Mac kernel myself.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
