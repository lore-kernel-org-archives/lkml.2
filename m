Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2DGA6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:58:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58650 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2DGA6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:58:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120407002828.GG6589@ZenIV.linux.org.uk>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org> <20120407002828.GG6589@ZenIV.linux.org.uk>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 6 Apr 2012 17:57:44 -0700
X-Google-Sender-Auth: fZxcD-NJ9Ql7-9C9uHSJmGsLR94
Message-ID: <CAB=NE6Xg9hM1WFBsNJL50bS0vNx97fg5imDNog5tSFG4RUqgoQ@mail.gmail.com>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 5:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Apr 06, 2012 at 05:11:22PM -0700, Luis R. Rodriguez wrote:
>
>> You do not need to make dual licenses when licenses are compatible
>> with each other, and in fact at times this can confuse developers / legal.
>> This has been well documented by SFLC through their "Maintaining
>> Permissive-Licensed Files in a GPL-Licensed Project: Guidelines for
>> Developers" [0] which was inspired by the ambiguity of the MadWifi
>> Project's Dual BSD/GPL license tradition. The list of GPL-Compatible
>> licenses can be found on the FSF's website [1].
>
> This is obvious crap.  Explain to me, please, what makes your "GPL compatible"
> different from "GPLv2";

GPLv2 is GPLv2, GPL-Compatible means the module is not GPLv2 but
instead one of the licenses that are GPLv2 compatible.

> at least that would be honest ("we have relicensed a copy of BSD/GPL code to
> GPL alone - the license allows that and any  modifications done here are declared
> GPL-only, so you can't pull them into the BSD-licensed variants")

That's the thing Al, the purpose of this patch is not to address
getting code from BSD to Linux but the inverse, let BSD folks benefit
from some of our driver work which is permissively licensed. In that
case we are declaring the module to GPL-Compatible license. When we
take BSD code and GPL it we have to also change the license header as
documented in the documentation provided by SFLC. An example driver
that had this done is drivers/net/wireless/ath/carl9170/main.c and
friends. We however have at times code licensed only under a
permissive license and want other BSD families to help take that code
and benefit from it. This all started for wireless with ath5k to help
OpenBSD reap benefits from the ar5k HAL hat we took to embrace into
Linux. We followed suit with ath9k to ensure BSD family can reap
benefits from the driver.

> "GPL compatible" is not a license; it's a set of licenses.

Great point, and I think Linus makes the same point.

> Incidentally,
> belonging to that set is irrelevant to legality of including into the kernel,
> since GPLv3 a member and it's *NOT* compatible with the kernel license.

The FSF website indeed does not have a handy URL to only list GPLv2
compatible licenses. That may be nice.

I think on both threads the issues highlighted are the technical
artifacts (not addressed here) Vs the actual software license of the
files.

  Luis
