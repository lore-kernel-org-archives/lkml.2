Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502Ab2JYGdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:33:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33236 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab2JYGdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda_2HCyY2hAcQ_xehqKqjF2-JCjsr67BHYyaqggd0xgUw@mail.gmail.com>
References: <CACRpkdbwUMbTeKnGX3u4KNQbGdY0wY518=tAm5MocwyVPZbBfQ@mail.gmail.com>
	<CA+55aFxVe77iv=SrG7tBa1OkRtdmeqmtr+vMYe3rxphvvMtV-g@mail.gmail.com>
	<CACRpkda_2HCyY2hAcQ_xehqKqjF2-JCjsr67BHYyaqggd0xgUw@mail.gmail.com>
Date: Thu, 25 Oct 2012 08:33:37 +0200
Message-ID: <CACRpkdYC4A_zO3E0WNm2M-69CCwmKtXhbET7NH4-FfO2tKHVFQ@mail.gmail.com>
Subject: Re: [GIT PULL] pinctrl patches for v3.7-rc3+
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 8:31 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Oct 25, 2012 at 2:04 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>
>> On Wed, Oct 24, 2012 at 4:57 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>>
>>> here are some accumulated pinctrl patches since -rc1, with a
>>> verboser description in the (signed) tag.
>>
>> Hmm. Your description contains several commits that were already
>> merged long ago (well, a week ago from your previous pull request). So
>> your shortlog etc are all bogus, and contains stuff that isn't
>> actually new to this pull. What happened?
>
> Hmmmm forgot to merge -rc1 and -rc2 into the fixes branch I
> guess, I'll fix it up and respin, sorry.

Bah I see you merged it all and let git sort it out :-)

I'll be more careful next time, thanks!

Yours,
Linus Walleij
