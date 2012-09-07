Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab2IGJUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:20:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35506 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2IGJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120907080319.GA19102@localhost>
References: <CAA_GA1f=NvzNOpuKg7mO8TnvFXjtZDHBjBeXkSihV94eWRkncA@mail.gmail.com>
	<20120808070449.GA19904@localhost>
	<CAA_GA1fuEamnDoSk8ki-nXGY5k2t9BsPkfFaGmNPQ2A=MuV-Og@mail.gmail.com>
	<20120824090324.GA3878@localhost>
	<CAA_GA1dMk8TJ3Nv5vTRquBO3aRfdFbxpq9=+uVnF30tO3ymiSw@mail.gmail.com>
	<20120904095654.GA12384@localhost>
	<CAA_GA1cEhn6dKg2Q7fH4tJRJ2a+qryukHP84OKCm8Lb15phB8w@mail.gmail.com>
	<20120907070705.GA18082@localhost>
	<CAA_GA1eQ1WbnZDaSaLXhAo7Txt+v2WScDhF8_D3r0tHtZV8Xug@mail.gmail.com>
	<20120907080319.GA19102@localhost>
Date: Fri, 7 Sep 2012 17:20:01 +0800
Message-ID: <CAA_GA1cgym-8HbJiXFbHdnpwZY4G9NfGZwK3CUYxmnEVvMCtaQ@mail.gmail.com>
Subject: Re: BF561-EZKIT-SMP_defconfig build error in smp.c
From: Bob Liu <lliubbo@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 4:03 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> FYI, BF561-EZKIT-SMP_defconfig has this build error:
>
> kernel/built-in.o: In function `on_each_cpu mask':
> kernel/smp.c:708: undefined reference to `smp_call_function_many'
>

We have fixed this issue in our internal tree but haven't push to mainline.
I'll update it soon, thank you.

-- 
Regards,
--Bob
