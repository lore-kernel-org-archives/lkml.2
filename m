Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2GANLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:11:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41950 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2GANLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:11:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120701121008.GF16319@n2100.arm.linux.org.uk>
References: <4FECB95D.7010200@zytor.com>
	<cover.1338222460.git.rubini@gnudd.com>
	<f85fefb10b7a7407b77180be65b18bf0426145b9.1338222461.git.rubini@gnudd.com>
	<20120701104401.GA4352@mail.gnudd.com>
	<20120701105934.GD16319@n2100.arm.linux.org.uk>
	<CAJe_ZheynaBcMiQiwnxPrEoGxhhAJyHDD6VM-uDEN_5Yg1vVpA@mail.gmail.com>
	<20120701121008.GF16319@n2100.arm.linux.org.uk>
Date: Sun, 1 Jul 2012 18:41:44 +0530
Message-ID: <CAJe_Zhdy0q8H9jhG=wXMVToUjevZk1XcGUm1oKSZvpDNZ1UdVg@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-arch@vger.kernel.org,
        giancarlo.asnaghi@st.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, hpa@zytor.com,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 July 2012 17:40, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Sun, Jul 01, 2012 at 05:28:16PM +0530, Jassi Brar wrote:
>> On 1 July 2012 16:29, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>> > On Sun, Jul 01, 2012 at 12:44:01PM +0200, Alessandro Rubini wrote:
>> >> How should I address the problem? (original code, published on
>> >> sourceforge was simply replicating a number of amba drivers into pci
>> >> drivers, but I don't think massive code duplication is ever sensible,
>> >> thus I preferred to reuse the existing drivers).
>> >
>> > I think the answer is... those primecell drivers need fixing in some way.
>> > Re-defining CS, DS and ES in drivers is rather silly given that they're
>> > x86 segment register names - so if PL330 can be fixed to make its names
>> > more specific, that sorts it out.
>> >
>> I am OK prefixing the regs with PL330_ or somesuch.
>>
>> The CS, DS and ES regs were named so as to match exactly the
>> terminology of the PL330 manual. So apparently even the ARM Ltd didn't
>> imagine ARM and X86 galaxies colliding so soon :)
>
> Whatever it says in documentation is neither here nor there.  We're humans,
> we can re-interpret, and we are capable of adding prefixes to names when
> they're stupidly chosen.
>
> Notice how I added MMCI_ and MCI_ to the register definitions for PL180
> for example.  I always do that kind of thing as a rule to avoid these kinds
> of problems right from the outset, and I don't understand why others don't
> do the same.  We've been through soo many "this symbol clashes with
> something else in the kernel tree" now that we really should be doing this
> automatically, and not waiting for the clash to happen.
>
I fully agree with your point and IIRC I always add some prefix to
definitions in header files.
Private defines in a .c file, without redundant prefixes, sounded like
safe to me at the time, but perhaps I was wrong.

Thanks.
