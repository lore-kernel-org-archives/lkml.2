Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab2CMBuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:50:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58523 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355Ab2CMBuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:50:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120313100625.b500f0efb546a9f4ceeb12ba@canb.auug.org.au>
References: <20120309183732.512d3676599da324f4747219@canb.auug.org.au>
	<4F5E1ECC.1040605@atmel.com>
	<CAMXH7KH_vgri3EPRvkXR+LddRUc=0ve=4u7yr51utBfgV5bF3w@mail.gmail.com>
	<20120313100625.b500f0efb546a9f4ceeb12ba@canb.auug.org.au>
Date: Mon, 12 Mar 2012 20:50:14 -0500
Message-ID: <CAMXH7KFw703n3UyXFj0cGZ_scpvHR8c+iguuUQPuEQgfswnaRw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the cpuidle-cons tree with the
 arm-soc tree
From: Rob Lee <rob.lee@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Rob,
>
> On Mon, 12 Mar 2012 12:03:48 -0500 Rob Lee <rob.lee@linaro.org> wrote:
>>
>> On Mon, Mar 12, 2012 at 11:05 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>> > -----BEGIN PGP SIGNED MESSAGE-----
>> > Hash: SHA1
>> >
>> > On 03/09/2012 08:37 AM, Stephen Rothwell :
>> >>
>> >> Today's linux-next merge of the cpuidle-cons tree got a conflict
>> >> in arch/arm/mach-at91/cpuidle.c between commit 00482a4078f4 ("ARM:
>> >> at91: implement the standby function for pm/cpuidle") from the
>> >> arm-soc tree and commit 7a1f6e72dce1 ("ARM: at91: Consolidate time
>> >> keeping and irq enable") from the cpuidle-cons tree.
>> >>
>> >> I fixed it up (I think - see below) and can carry the fix as
>> >> necessary.
>> >
>> > Yes: resolution correct. Please carry it.
>>
>> Who should carry this fixup and related necessary at91 changes?  Me?
>> FYI, my at91 changes are dependent on my core cpuidle change, but my
>> core cpuidle changes do not require any at91 changes as the at91 and
>> other platform changes were only made to consolidate duplicate code.
>
> I will carry the fixup and Linus will presumably do the same fix when he
> merges these trees in his tree.  I am not sure what you mean by "related
> at91 changes".
>

Thanks Stephen.  By "related changes" I just meant that if I were to
make a branch to carry the fixup, I'd need to all merge in the at91
related changes that are on linux-next but not on an rc tag yet.  But
please ignore this statement if it doesn't make sense.  I'm not yet
knowledgeable on the workflow once submitted patchsets reach this
level.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
