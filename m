Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab2EXXQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:16:06 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:56779 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679Ab2EXXQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:16:04 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Menon\, Nishanth" <nm@ti.com>
Cc: "J\, KEERTHY" <j-keerthy@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "AnilKumar\, Chimata" <anilkumar@ti.com>,
        "linux-pm\@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Pihet-XID\, Jean" <j-pihet@ti.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [linux-pm] [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Organization: Texas Instruments, Inc.
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<20120426191159.GA9415@sirena.org.uk>
	<CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
	<20120427175657.GP18260@opensource.wolfsonmicro.com>
	<87397o3n4y.fsf@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1A67@DBDE01.ent.ti.com>
	<87mx5jy2li.fsf@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B6681@DBDE01.ent.ti.com>
	<EF62F09C0797D947AD4180A1043C0DF73C40BCE1@DLEE10.ent.ti.com>
	<87lil2jp2z.fsf@ti.com>
	<EF62F09C0797D947AD4180A1043C0DF73C40C247@DLEE10.ent.ti.com>
	<87pqadgqd5.fsf@ti.com>
	<CAOMWX4cjzLYuPmA-k=Z_pc5uw=CCViPjRYqs4VTyLX6T8HhtcA@mail.gmail.com>
Date: Thu, 24 May 2012 16:16:00 -0700
In-Reply-To: <CAOMWX4cjzLYuPmA-k=Z_pc5uw=CCViPjRYqs4VTyLX6T8HhtcA@mail.gmail.com>
	(Nishanth Menon's message of "Wed, 23 May 2012 08:27:06 -0500")
Message-ID: <87aa0xqifj.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Menon, Nishanth" <nm@ti.com> writes:

> On Wed, May 9, 2012 at 1:29 PM, Kevin Hilman <khilman@ti.com> wrote:
>> "Woodruff, Richard" <r-woodruff2@ti.com> writes:
>>
>>>> From: Hilman, Kevin
>>>> Sent: Tuesday, May 08, 2012 5:17 PM
>>>
>>>> A basic OMAP AVS driver has been in mainline for a long time, yet we
>>>> have not seen support submitted for all of these features.
>>>
>>> 1.5/3.5 is a feature.
>>
>> And I'm still waiting for it to be submitted upstream.
>>
>>> ABB is requirement for a production useable driver. Higher speed rated
>>> OMAP4 and all OMAP5 added these to be useable.
>>
>> ditto
>>
>>> Yes this is effort. Point of mentioning is to raise awareness of need.
>>
>> I'm well aware of the need.
>>
>>> Yet to be added feature has different meaning than functional gap.
>>
>> And both need to be submitted upstream.
>
> SR 1.5: http://marc.info/?l=linux-omap&m=129933897910785&w=2
> ABB: http://marc.info/?l=linux-omap&m=130939399209099&w=2
>
> I am not sure what you mean "need to be submitted upstream"?

You're right.  I should've said re-submitted and merged.  Both have been
submitted (and reviewed) but no follow up submissions after review, and
thus they're still out of tree.

> Just tired of seeing things perpetually change without considering
> even how to handle features that are mandatory for SoC even with code
> posted upstream to show exactly what it takes.. 

I'm sorry, but this is not perpetual change.  

This driver has been upstream in its current (admittedly
feature-limited) form for a long time, the only thing changing in
$SUBJECT series is the location of the driver.  Why all the fuss about
the missing features now?

> I think you do mean merged upstream in this context.

Correct.

Frameworks always have limitations.  The way they get extended/expanded
etc. is by the submission/review/merging of support for new
features/requirements.  The process for that is the same as any feature
in any part of the kernel.

Evolution, not intelligent design[1].

All of that being said, I'm not sure why this thread was hijacked for
this debate in the first place.  The point of $SUBJECT series is simply
to move and *existing* framework from arch/arm out to drivers.  The only
changes done are cleanups to make this move possible.

I for one would welcome extending this framework to ensure it supports
all the SoC features.  I just don't want those features to be a
prerequisite for this move from arch/arm to drivers.

Please, let's get this moved to drivers, and then add support for the
missing features.

Thanks,

Kevin

[1] http://kerneltrap.org/Linux/Kernel_Evolution
