Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab2HDFQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 01:16:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38170 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab2HDFQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 01:16:13 -0400
Date: Sat, 4 Aug 2012 07:16:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Pandita, Vikram" <vikram.pandita@ti.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-omap <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Subject: Re: [PATCH v2] printk: add option to print cpu id
Message-ID: <20120804051608.GB6728@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Pandita, Vikram" <vikram.pandita@ti.com>,
	Kay Sievers <kay@vrfy.org>, linux-omap <linux-omap@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Venu Byravarasu <vbyravarasu@nvidia.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mike Turquette <mturquette@linaro.org>,
	Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AB@BGMAIL02.nvidia.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AE@BGMAIL02.nvidia.com>
 <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com>
 <CAPXgP13UBwQLs+m_aSk3Ljbktz8WrL+ZO_Tfhrt_+tRBCARyQQ@mail.gmail.com>
 <CAFm5wm0nf47bcTu7iiXA3geR_5dDTF1tnf81Lz7JzbWkKdhUtA@mail.gmail.com>
 <CAPXgP11A=QfOt4SL2GvhsepP8JiDFfdaAhi6-AhW++-AvOz+aw@mail.gmail.com>
 <20120803104212.GA6936@x1.osrc.amd.com>
 <CAFm5wm0rsvuBafMH+9PpKwfaBimbRrVzxYV0nD_pg1yisAYwxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFm5wm0rsvuBafMH+9PpKwfaBimbRrVzxYV0nD_pg1yisAYwxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 09:46:15AM -0700, Pandita, Vikram wrote:
> I mostly work with ARM Soc - specifically on OMAP. SMP multi core
> systems in ARM-v7 world started to show up only few years back -
> unlike x86 world.

This is exactly the thing: other SMP vendors have made it so far without
emitting which core is doing what in dmesg.

> ARM systems are a bit unique when it comes to security( read trust
> zone ), and handling of FIQ's. Most of the ARM cortex-A series SoC's
> out there have some kind of affinity to CPU0 being the master. One use
> case has been, it has helped to know with this printk logging, if such
> constraints are honored.
>
> Sometimes, tracking of some lockup cases between cpu's because of bad
> code has also been helpful with this logging support. For now i will
> post v3 of the patch and add arm-list and linux-omap list, and there
> might be users there can benefit.

Right, so if arm people need this thing, why not make it arm-only? I
still fail to see the need for this (... at all, actually).

Thanks.

-- 
Regards/Gruss,
    Boris.
