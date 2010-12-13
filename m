Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0LMVx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:53:56 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64599 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0LMVxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:53:53 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v6 0/5] da850-evm: add gpio-{keys,leds} for UI and BB expanders
Organization: Deep Root Systems, LLC
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
	<87tyild2ms.fsf@deeprootsystems.com>
	<AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
	<AANLkTi=HiJGwtznGRzFDz-4ywsB3rYPW0yF5U_RUruzV@mail.gmail.com>
Date: Mon, 13 Dec 2010 13:53:44 -0800
In-Reply-To: <AANLkTi=HiJGwtznGRzFDz-4ywsB3rYPW0yF5U_RUruzV@mail.gmail.com>
	(Ben Gardiner's message of "Mon, 13 Dec 2010 12:02:32 -0500")
Message-ID: <8762ux49w7.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gardiner <bengardiner@nanometrics.ca> writes:

> Hi Kevin,
>
> On Fri, Dec 10, 2010 at 11:33 AM, Ben Gardiner
> <bengardiner@nanometrics.ca> wrote:
>> On Fri, Dec 10, 2010 at 11:16 AM, Kevin Hilman
>>> [...]
>>> This series looks good to me, so I'll be queuing it in davinci-next for
>>> 2.6.38.  It should show up in davinci git shortly. [...]
>>
>> Thank you very much, Kevin.
>>
>> I will check linux-davinci/master on monday.
>
> I looked at git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git#davinci-next
> ; HEAD at the time was
>
>   commit 3004ce0d3a44525de63e18b01f7734bc8d64f2c5
>   Author: Ben Gardiner <bengardiner@nanometrics.ca>
>   Date:   Thu Dec 9 16:51:07 2010 -0500
>
>       da850-evm: KEYBOARD_GPIO_POLLED Kconfig conditional
>
>       Use the mach-davinci/Kconfig to enable gpio-keys-polled as default when
>       da850-evm machine is enabled.
>
>       Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
>       CC: Kevin Hilman <khilman@deeprootsystems.com>
>       CC: "Nori, Sekhar" <nsekhar@ti.com>
>       CC: Gabor Juhos <juhosg@openwrt.org>
>       Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>
> Everything seems to be in order there; I tested the resulting kernel
> with evtest and the expected output was observed. Note that
> davinci-next still contains the cherry-pick of the upstream commit of
> the polled gpio keys driver:

oops... I've now removed that, since it is part of v2.6.36-rc5 already.
Thanks for checking.

[...]
 > I also looked at
> git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git#master
> ; HEAD at the time was
>
>   commit 4bfbdddc0655a284a98304bc343c6bcaf81b8e4d
>   Merge: 771215c 7507fd3
>   Author: Kevin Hilman <khilman@deeprootsystems.com>
>   Date:   Fri Dec 10 16:25:27 2010 -0800
>
>       rebuild linux-davinci from branches
>
> There appears to be some double commits of the patch series. I tested
> it with evtest anyways and also observed the expected output.
>
> The following command and its output hopefully demonstrate what I am
> seeing as double commits.

Yes, there will be double commits in master, because of the way I manage
master using 'git merge -ours'.  But there shouldn't be double commits
between my "rebuild from braches" merges.  It can be confusing, but if
you look at the history with a graphical tool like 'gitk', it might shed
some light on what is going on.

I know it's confusing, but the davinci-next branch is the only important
branch in this tree for upstream purposes.

[...]

> Note that the cherry pick of the upstream commit of the polled gpio
> keys driver is here in 'master' also.

Yeah, that came from davinc-next.  Now that it's removed from there, it
should be ok.

I just pushed an updated davinci-next and master branch.  It sometimes
takes a bit to propagate to all the kernel.org mirrors, but the update
should be there shortly.

Thanks,

Kevin
