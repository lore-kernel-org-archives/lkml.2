Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2LDRef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 12:34:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58003 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2LDRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 12:34:34 -0500
MIME-Version: 1.0
In-Reply-To: <50BDB016.7010908@ti.com>
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com>
 <1352731270-27534-2-git-send-email-peter.ujfalusi@ti.com> <CAK5ve-JDCSSOKHQG-F1RoDii62=-DiPevaD6SafndYVvOgB6Fw@mail.gmail.com>
 <50BCB391.1070305@ti.com> <CAK5ve-+1eQ3mPLAu2Qxw4LjNA85oEtJE-wZcL=YpQ0xBFJ6+hQ@mail.gmail.com>
 <50BDB016.7010908@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 4 Dec 2012 09:34:12 -0800
Message-ID: <CAK5ve-K69=NqApFTFOZB7Z_KXcRLaWExzbkUhP=GeASMB7JYqw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] leds: leds-pwm: Convert to use devm_get_pwm
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 12:11 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hi Bryan,
>
> On 12/03/2012 07:32 PM, Bryan Wu wrote:
>> On Mon, Dec 3, 2012 at 6:13 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> Actually, I'm waiting for some feedback from DT maintainers about this
>> new binding. But it looks find to me.
>
> Would it be possible to have the first (or even better the first two) patch
> going for 3.8 and we can leave the DT bindings for 3.9?
> I would like to clean up, fix some of the OMAP related board files for 3.9
> which would need the patches for the leds-pwm driver itself.
>

What's best thing I can do is I can merge these patchset into my
-devel branch, after 3.8 merge window close I will move this -devel
branch to my for-next branch for 3.9 merge window.

Does this make sense to you?

Thanks,
-Bryan
