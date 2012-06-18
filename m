Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2FRDKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 23:10:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36020 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2FRDKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 23:10:04 -0400
MIME-Version: 1.0
In-Reply-To: <s5h8vfoojns.wl%tiwai@suse.de>
References: <1339478463-31172-1-git-send-email-amwang@redhat.com>
	<CAM_iQpUq39+VQMU6rq78iqpy2m-PnSwWUW4M3WYjpecVVv4jhw@mail.gmail.com>
	<s5h8vfoojns.wl%tiwai@suse.de>
Date: Mon, 18 Jun 2012 11:10:03 +0800
Message-ID: <CAM_iQpXEd8DOUVnpK-3N1qiGYyjWO5r5s8SL7vhvFM0kwH0-sA@mail.gmail.com>
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai.lu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 8:15 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 15 Jun 2012 19:11:12 +0800,
> Cong Wang wrote:
>>
>> On Tue, Jun 12, 2012 at 1:21 PM, Cong Wang <amwang@redhat.com> wrote:
>> >
>> > Takashi, could you help to test if the S4 regression is still
>> > there after this patch?
>>
>> Hello,
>>
>> Any comments?
>>
>> I have tested this revert on my laptop, with running simple
>> "suspend and resume" test for several times, I didn't see any
>> problem.
>
> Sorry for the late response.
>
> The problem happens only on certain laptops.  I've tested the recent
> IvyBridge laptops and these were OK with the reverted patch.  But a
> SandyBridge laptop, the one I tested in the last year, still hits the
> S4 problem with the reverted kernel.

Yeah, but the crashkernel=512M regression seems to happen
on more machines. :)

>
> But, the recent kernels seem to have other S4 problems on this
> machine, so it's not 100% clear whether it's triggered by that.
> At least, it jumpts to the boot at S4 resume more frequently when the
> patch is reverted.
>
> So, I need to start from 2.6.32 again to see what regressions have
> been introduced.  It'll take time, since I'd have to S4 20 cycles
> for reproducing the bug.
>

Ok, thanks for your update!
