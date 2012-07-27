Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2G0F5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 01:57:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5869 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2G0F5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 01:57:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jul 2012 22:57:25 -0700
Message-ID: <50122E34.6080700@nvidia.com>
Date: Fri, 27 Jul 2012 14:59:16 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>,
        Axel Lin <axel.lin@gmail.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PWM subsystem for v3.6
References: <20120726071636.GA28129@avionic-0098.mockup.avionic-design.de> <CA+55aFy9JNZyhdTU+btUbBTKsHN1odX1-as=iTC_L9tZr=Oz1w@mail.gmail.com> <20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 27 Jul 2012 02:10:54 PM JST, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Thu, Jul 26, 2012 at 02:11:58PM -0700, Linus Torvalds wrote:
>> On Thu, Jul 26, 2012 at 12:16 AM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>>>
>>> The new PWM subsystem aims at collecting all implementations of the
>>> legacy PWM API and to eventually replace it completely. The subsystem
>>> has been in development for over half a year now and many drivers have
>>> already been converted. It has been in linux-next for a couple of weeks
>>> and there have been no major issues so I think it is ready for inclusion
>>> in your tree.
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

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
Tested-by: Alexandre Courbot <acourbot@nvidia.com>

I arrived too late to ack your patches, but if the practice is accepted 
please feel free to put these in the latest version of your pwm 
framework and pwm-backlight patches.

Alex.
