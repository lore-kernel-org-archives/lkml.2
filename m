Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2G0MOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:14:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52846 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2G0MOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
References: <20120726071636.GA28129@avionic-0098.mockup.avionic-design.de>
	<CA+55aFy9JNZyhdTU+btUbBTKsHN1odX1-as=iTC_L9tZr=Oz1w@mail.gmail.com>
	<20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
Date: Fri, 27 Jul 2012 17:44:21 +0530
Message-ID: <CAK9yfHyz=D=O=iZjAseKX5gmrp08E5vGjzQFPJ09vwebOAWoag@mail.gmail.com>
Subject: Re: [GIT PULL] PWM subsystem for v3.6
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
        Axel Lin <axel.lin@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2012 10:40, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> On Thu, Jul 26, 2012 at 02:11:58PM -0700, Linus Torvalds wrote:
>> On Thu, Jul 26, 2012 at 12:16 AM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>> >
>> > The new PWM subsystem aims at collecting all implementations of the
>> > legacy PWM API and to eventually replace it completely. The subsystem
>> > has been in development for over half a year now and many drivers have
>> > already been converted. It has been in linux-next for a couple of weeks
>> > and there have been no major issues so I think it is ready for inclusion
>> > in your tree.
>>
>> For new subsystems like this, I really want ack's from the people who
>> are expected to use it.
>
> At least the patch that adds me as the maintainer is Acked-by: Sascha
> Hauer, who did the original work, and Arnd Bergmann who was involved in
> the review process. Other people such as Shawn Guo and Mark Brown have
> also been reviewing these patches and new patches have been contributed
> by Eric Bénard, Axel Lin, Sachin Kamat, Alexandre Courbot, Alexandre
> Pereira da Silva and Philip Avinash.
>

Using this on Samsung Exynos platform.

Acked-by: Sachin Kamat <sachin.kamat@linaro.org>

> I'm adding all of them on Cc so they can ack this (I'm assuming acking
> this email will suffice).
>
>> For a gitorious pull like this, I also want signed tags with the gpg
>> key having signatures from people I recognize. I don't think I have
>> such a key from you.
>
> Right. I don't have any signatures on my GPG key, but I'm not aware of
> any kernel developers in my area and unfortunately I don't get around
> much either. I can request key-signing via users@kernel.org and see if
> I missed anyone. I think that is the correct mailing list? I remember
> reading about it a while back but I can't find the link anymore.
>
> Thierry
