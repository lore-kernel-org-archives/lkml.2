Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab0LNRK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:10:26 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:40752 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab0LNRKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:10:24 -0500
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
	<8762ux49w7.fsf@deeprootsystems.com>
	<AANLkTikUoKPG4o1+pt9r6V6H+6LrwZpTN8X9X+AkimiB@mail.gmail.com>
Date: Tue, 14 Dec 2010 09:10:19 -0800
In-Reply-To: <AANLkTikUoKPG4o1+pt9r6V6H+6LrwZpTN8X9X+AkimiB@mail.gmail.com>
	(Ben Gardiner's message of "Tue, 14 Dec 2010 11:17:14 -0500")
Message-ID: <87ei9kwa9w.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gardiner <bengardiner@nanometrics.ca> writes:

> On Mon, Dec 13, 2010 at 4:53 PM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>> Ben Gardiner <bengardiner@nanometrics.ca> writes:
>>> [...]
>>> Everything seems to be in order there; I tested the resulting kernel
>>> with evtest and the expected output was observed. Note that
>>> davinci-next still contains the cherry-pick of the upstream commit of
>>> the polled gpio keys driver:
>>
>> oops... I've now removed that, since it is part of v2.6.36-rc5 already.
>> Thanks for checking.
>
> Oops on my part...
>

[...]

> It appears that dropping the cherry-pick caused the build failure.
>
> The commit that introduces the polled gpio keys driver (which was
> included in the series as a cherry pick) is commit
> 0e7d0c860a0dee49dacb7bbb248d1eba637075ad which is in
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git#master
> _after_ the tag v2.6.37-rc5.
>
> That's my fault. I incorrectly thought that commit
> 0e7d0c860a0dee49dacb7bbb248d1eba637075ad was _in_ 2.6.37-rc5 and
> stated this is previous emails. I'm sorry for the confusion; I think I
> jumped the gun there due to my excitement at getting this prerequisite
> driver committed.

OK, while waiting for it to arrive upstream, I've added it to my
'davinci-backports' branch, which is also merged into the master branch
of davinci git (but not in davinci-next, since it will go upstream via
another subsystem.)

Just pushed an updated version, and this time, I actually build tested for
davinci_all_defconfig and da8xx_omapl_defconfig. :)

Sorry for the churn,

Kevin

