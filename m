Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2CEKPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:15:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43752 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab2CEKPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:15:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.42.18.195 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE8619C2@HQMAIL01.nvidia.com>
References: <1330705873-10798-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BE861978@HQMAIL01.nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BE861991@HQMAIL01.nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BE8619C2@HQMAIL01.nvidia.com>
Date: Mon, 5 Mar 2012 11:15:32 +0100
Message-ID: <CACRpkdYrj2ay=k2MgYOekQtcfbP9FiY5Rju8VznJHrxG81Y7SQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: resurrect verbose pinmux-pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 7:24 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Stephen Warren wrote at Friday, March 02, 2012 10:41 AM:
>> Stephen Warren wrote at Friday, March 02, 2012 10:22 AM:
>> > Linus Walleij wrote at riday, March 02, 2012 9:31 AM:
>> > > From: Linus Walleij <linus.walleij@linaro.org>
>> > >
>> > > This reintroduces the verbosity in the pinmux-pins file, now this
>> > > file will list all pins, their names, owning device (and if it's
>> > > a hog) and also in applicable cases the function and group making
>> > > use of that pin right now.
>> > >
>> > > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> >
>> > It'd be nice if we could defer this fix until after all the API rework,
>> > because it'll cause all kinds of conflicts otherwise.
>>
>> Oh, I see this patch is in your for-next branch already before I had a chance
>> to comment on it. I guess I'll have write a patch to convert the removed struct
>> type to char*s and rebase on top of it:-(

Mainly because I saw it as a regression fix.

> I take that back. Can we please drop this patch and I'll provide an
> equivalent in my API rework series?

Yeah no problem, if the rest of the v3 patch set is OK I'll just
remove that patch.

Yours,
Linus Walleij
