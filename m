Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab3AIDNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 22:13:08 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38143 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3AIDNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 22:13:07 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <CA+55aFxxv2h8TAxvwprdQEpaz4Ww5ime+t8rmpjnjv2t-mWYaQ@mail.gmail.com>
References: <20130108184920.GA1258@quad.lixom.net>
	<CA+55aFxxv2h8TAxvwprdQEpaz4Ww5ime+t8rmpjnjv2t-mWYaQ@mail.gmail.com>
Date: Tue, 8 Jan 2013 19:13:05 -0800
Message-ID: <CAOesGMgdV1dD5stpCiWVO8kL+E9U4+_3Zc7gUQ0YEiah4t1LbQ@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: arm-soc fixes for 3.8-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 6:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jan 8, 2013 at 10:49 AM, Olof Johansson <olof@lixom.net> wrote:
>>
>> A slightly larger delta than I'd ideally want by now, in part due to some
>> of the OMAP PM fixes that's adding a bit of code. I decided to include
>> it instead of push it to 3.9, but from here on out we'll be stricter.
>
> Ugh. Not only that, but:
>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes
>
> you have both a branch called "fixes" and a tag called "fixes".
> Ambiguous. And when you ask me to pull like the above, it actually
> picks the branch, not the tag.
>
> Don't do this. Either use the unambiguous name ("tags/fixes" rather
> than just "fixes") or don't push out branches and tags that have the
> same name.

I switched from the latter to the former a while back, and should
probably switch back. What happened in this case is that the tag
hadn't mirrored out from ra yet, so git request-pull fell back to the
branch name instead and I didn't notice. :(

A non-ambiguous name will still fall back to the branch name instead
of the (differently named) tag, but it'll be easier to catch when I
check the pull request contents before sending it.

Or maybe a better solution is to make git request-pull throw an error
if there is a local signed tag for the request, but none is found on
the server (or has different contents). I'll take a look at that.


-Olof
