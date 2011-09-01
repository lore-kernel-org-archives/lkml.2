Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab1IAJMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:12:06 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51867 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab1IAJMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:12:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110901105226.0d8dd8b2@endymion.delvare>
References: <1314852027-9523-1-git-send-email-xiyou.wangcong@gmail.com>
	<20110901105226.0d8dd8b2@endymion.delvare>
Date: Thu, 1 Sep 2011 17:12:00 +0800
Message-ID: <CAM_iQpVGO6Jfcdy4wWN7O-ZpTha2SbfK6xeaf8g9DRGuh=xcbg@mail.gmail.com>
Subject: Re: [PATCH] i2c: remove deprecated callbacks
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@xenotime.net>, Ben Dooks <ben-linux@fluff.org>,
        linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 4:52 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Cong,
>
> On Thu,  1 Sep 2011 12:40:27 +0800, WANG Cong wrote:
>> i2c_driver.attach_adapter and i2c_driver.detach_adapter are deprecated
>> and scheduled to be removed in Sep 2011.
>>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> I'm not sure what you are trying to achieve here.

I just want to make feature-removal-schedule.txt working. :)

>
> I am obviously aware of these functions being deprecated, I am the one
> who added the entry in feature-removal-schedule.txt. And as a matter of
> fact, I have a patch ready for months now.
>
> I could understand you sending a patch if the entry had expired long
> ago, but this isn't the case: it is marked for September 2011 and you
> send a patch on September 1st. Hardly a coincidence. While there
> certainly is a benefit in people reading feature-removal-schedule.txt
> and trying to clean it up by closing old (presumably forgotten)
> entries, this doesn't apply here.
>
> Furthermore, you didn't even check if the deprecated callbacks were
> still in use. It turns out that there are 9 drivers still using one of
> them (6 macintosh drivers and 3 sound drivers) so plain removing it
> will cause build breakages. We obviously don't want to do that, so I am
> not going to apply your patch (nor mine) for now.

Hmm, sorry that I didn't know this, maybe we can defer the removal
of these callbacks?

>
> I know that Benjamin Herrenschmidt is working on converting (some of)
> the macintosh drivers. I don't have any news for some time though. Ben,
> are you done with the conversion by now? It would be great to get it
> merged in kernel 3.2.
>
> Cong, do you have a specific interest in these callbacks being removed?
>
> If you want to help, then instead of sending a patch which I already
> have and virtually everybody could have written, please get the
> remaining 3 drivers converted to the current i2c binding model:
>  sound/ppc/keywest.c
>  sound/aoa/codecs/onyx.c
>  sound/aoa/codecs/tas.c

Sure, if I can... so how do we convert them? Any examples?

Thanks!
