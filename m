Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2G0Kc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:32:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49034 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab2G0Kcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
References: <20120726071636.GA28129@avionic-0098.mockup.avionic-design.de>
	<CA+55aFy9JNZyhdTU+btUbBTKsHN1odX1-as=iTC_L9tZr=Oz1w@mail.gmail.com>
	<20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
Date: Fri, 27 Jul 2012 07:32:54 -0300
Message-ID: <CAAAP30GiFLCx3H7yZK9Gp_KggZ6B0Werfd0QY9t7GNqOp1o=5Q@mail.gmail.com>
Subject: Re: [GIT PULL] PWM subsystem for v3.6
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
        Axel Lin <axel.lin@gmail.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 2:10 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
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
> I'm adding all of them on Cc so they can ack this (I'm assuming acking
> this email will suffice).

I'm using this on LPC32XX.

Acked-By: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
