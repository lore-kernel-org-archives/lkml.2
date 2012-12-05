Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2LEPgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:36:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33661 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2LEPgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:36:49 -0500
Message-ID: <50BF6A04.4040204@ti.com>
Date: Wed, 5 Dec 2012 16:36:36 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/3] leds: leds-pwm: Convert to use devm_get_pwm
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com> <1352731270-27534-2-git-send-email-peter.ujfalusi@ti.com> <CAK5ve-JDCSSOKHQG-F1RoDii62=-DiPevaD6SafndYVvOgB6Fw@mail.gmail.com> <50BCB391.1070305@ti.com> <CAK5ve-+1eQ3mPLAu2Qxw4LjNA85oEtJE-wZcL=YpQ0xBFJ6+hQ@mail.gmail.com> <50BDB016.7010908@ti.com> <CAK5ve-K69=NqApFTFOZB7Z_KXcRLaWExzbkUhP=GeASMB7JYqw@mail.gmail.com>
In-Reply-To: <CAK5ve-K69=NqApFTFOZB7Z_KXcRLaWExzbkUhP=GeASMB7JYqw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 06:34 PM, Bryan Wu wrote:
> What's best thing I can do is I can merge these patchset into my
> -devel branch, after 3.8 merge window close I will move this -devel
> branch to my for-next branch for 3.9 merge window.
> 
> Does this make sense to you?

Not sure if I can get changes related to leds-pwm through linux-omap in this
way. The practice is that l-o should be 'in a working condition' alone -
without linux-next.

But I'll find something else while waiting for 3.10 to clean up the omap board
files related to this.

-- 
Péter
