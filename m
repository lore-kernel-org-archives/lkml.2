Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1I2PrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:47:13 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41126 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab1I2PrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:47:11 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20110929152752.GO21166@tbergstrom-lnx.Nvidia.com>
References: <1317248978-10829-1-git-send-email-pdeschrijver@nvidia.com>
	<1317248978-10829-3-git-send-email-pdeschrijver@nvidia.com>
	<20110929092951.GE23944@n2100.arm.linux.org.uk>
	<20110929152752.GO21166@tbergstrom-lnx.Nvidia.com>
Date: Thu, 29 Sep 2011 08:47:10 -0700
Message-ID: <CAOesGMhyV3tDUn=mErN-Yq79wy_01wM9S-9Aw7FVJtrqtGXJLw@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] arm/tegra: add support for ventana pinmuxing
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 8:27 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> On Thu, Sep 29, 2011 at 11:29:51AM +0200, Russell King - ARM Linux wrote:
>> On Thu, Sep 29, 2011 at 01:29:35AM +0300, Peter De Schrijver wrote:
>> > diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
>> > index f11b910..91a07e1 100644
>> > --- a/arch/arm/mach-tegra/Makefile
>> > +++ b/arch/arm/mach-tegra/Makefile
>> > @@ -31,6 +31,7 @@ obj-${CONFIG_MACH_SEABOARD}             += board-seaboard-pinmux.o
>> >
>> >  obj-${CONFIG_MACH_TEGRA_DT}             += board-dt.o
>> >  obj-${CONFIG_MACH_TEGRA_DT}             += board-harmony-pinmux.o
>> > +obj-${CONFIG_MACH_TEGRA_DT}             += board-seaboard-pinmux.o
>>
>> Since when did Tegra start using braces instead of parens in its Makefile?
>> I note some of Tegra's makefile is using braces and some of it parens.
>> What's the reason for this alternative style to the rest of kbuild?
>
> I have no idea. I just followed the style used for the other CONFIG_MACH_TEGRA_DT entries. Colin or Olof, any idea?


>From git logs, it looks like the first harmony board file that came
from Colin used braces, and from there it's likely that everyone just
copied and pasted -- I know that's what I did.

Thanks for catching it, Russell, it had obviously completely gone
unnoticed by me and others.

I'll fix up the rest of the file. Peter -- no need to respin, I'll fix
up when I apply.


-Olof
