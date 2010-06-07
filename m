Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0FGUlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:41:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57388 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0FGUll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EtPNiNfBN83WqZQznBdF1X5gkwi69ZvY7GniWAwdY0PW68XnfjyGekj6K1uo8zXzeD
         OR9DrvgVt2geX64sBZnVzYgLdeMHnyX4we9YO5Xkpg04aUAaEqvufnJEAp6APQPggF/7
         uq8t6zfBpYvYJPy4Fh0MvLjK8sY70wwQoQQMU=
MIME-Version: 1.0
In-Reply-To: <AANLkTimSFtaDzUPDEq4Z2J4O5sFG4vDkFHqs1eA1wG44@mail.gmail.com>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
	<alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
	<AANLkTimSFtaDzUPDEq4Z2J4O5sFG4vDkFHqs1eA1wG44@mail.gmail.com>
Date: Tue, 8 Jun 2010 06:41:40 +1000
Message-ID: <AANLkTinDSMqlwOsNfX-K2vDN9HeQL19mtXEDAp8mqVjz@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 6:26 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Jun 8, 2010 at 4:00 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>
>> On Mon, 7 Jun 2010, Dave Airlie wrote:
>>>
>>> 3 regressions fixes, one radeon loading on IGP, one i865 loading, one and
>>> an evergreen userspace interaction workaround.
>>
>> This is:
>>
>>         26 files changed, 372 insertions(+), 66 deletions(-)
>>
>> and there are apparently several reports of known problems (the problem
>> with modesetting) that isn't even addressed.
>
> Okay, not sure what the addressed regression you are talking about, do
> you want  regression fixes early like you always say or do you want to
> wait until I have every regression reported fixes before I send a pull
> request?

Oh the one where I said to the reporter, I've reproduced this, and
will fix it tomorrow when I have proper time and access to my test
machine?

I didn't think writing a fix in the 5 mins before I left the test
machine and sending it you was acceptable, again can you maintain some
semblance of consistency across maintainers/releases?

Like I'm happy if you really enforce this no features idea, I'd be
really happy if you did it every release since it makes it a lot
easier to push back to submaintainers if you can point at Linus not
pulling features from people. However its really hard to push back on
submaintainers and one of the reasons Eric talks to you direct after
rc1, when you can be very inconsistent about what you pull and from
whom. Like I can tell someone this isn't going in this release, then
you'll pull something uglier  from someone else in -rc3 and I end up
looking like stupid because I said there was no hope of getting
anything in. Consistency is something that would make everyone's life
easier, across all releases and all maintainers.

Dave.
