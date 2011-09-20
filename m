Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab1ITVjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:39:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35382 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1ITVjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:39:07 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <201109202301.56983.arnd@arndb.de>
References: <1316537186-26753-1-git-send-email-swarren@nvidia.com>
	<20110920180731.GL7781@ponder.secretlab.ca>
	<201109202134.50242.arnd@arndb.de>
	<201109202301.56983.arnd@arndb.de>
Date: Tue, 20 Sep 2011 14:39:06 -0700
Message-ID: <CAOesGMg4kBH77Ou1xyyVT-Ojxg=9uyxmfsmhbbKquru=j+z6Gg@mail.gmail.com>
Subject: Re: [PATCH REPOST 1/2] arm/dt: Tegra: Update SDHCI nodes to match bindings
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, nicolas.pitre@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 2:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 20 September 2011, Arnd Bergmann wrote:
>> On Tuesday 20 September 2011, Grant Likely wrote:
>> > On Tue, Sep 20, 2011 at 07:43:29PM +0200, Arnd Bergmann wrote:
>> > > On Tuesday 20 September 2011, Stephen Warren wrote:
>> > > > The bindings were recently updated to have separate properties for each
>> > > > type of GPIO. Update the Device Tree source to match that.
>> > > >
>> > > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> > > > Acked-by: Olof Johansson <olof@lixom.net>
>> > > > ---
>> > > > I'd previously sent these to Grant assuming they'd go in his dt/next branch,
>> > > > but perhaps these should go in through Arnd's arm-soc next/dt branch?
>> > > >
>> > >
>> > > Which tree has the update that changed the bindings? I think it should
>> > > go into the same one.
>> > >
>> > > If it's already upstream, I can take it into the fixes branch.
>> >
>> > Already upstream
>>
>> Ok, I see. I've applied both patches to the fixes branch and will send
>> it out with the next pull request for 3.1 to Linus then.
>
> Sorry, I just noticed that the second patch is not a bug fix, so I took it out
> again and kept only patch 1/2 in the fixes branch for 3.1.
>
> Should I take the other one as well? It's probably better to let that
> go the proper way through the tegra tree for 3.2, right?

Given that you have a public tree right now, and I don't (since
kernel.org is down), please feel free to start a tegra/for-3.2 branch
for me and apply it there. I'll base further work on top of that if
needed.

(There also aren't a whole lot of other patches queued for 3.2 right now).

-Olof
